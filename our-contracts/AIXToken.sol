// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./AIXSystemRegistry.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IAIXVerification {
    struct VerifiedWork {
        bytes32 workId;
        address worker;
        uint256 cpuUsage;
        uint256 gpuUsage;
        uint256 memoryUsage;
        uint256 energyUsage;
        uint256 verificationTime;
        bool verified;
    }

    function checkVerificationStatus(
        bytes32 attestationId
    ) external view returns (bool verified, VerifiedWork memory work);
}

interface IAIXValuation {
    function getLatestPrice(bytes32 resource) external view returns (uint256);
}

contract AIXToken is ERC20, Ownable {
    AIXSystemRegistry public registry;

    event TokensMintedForVerifiedWork(
        bytes32 attestationId,
        address worker,
        uint256 amount
    );

    constructor(
        address _registry
    ) ERC20("AI Exchange Token", "AIX") Ownable(msg.sender) {
        registry = AIXSystemRegistry(_registry);

        // Mint initial supply to the deployer's wallet
        uint256 initialSupply = 1_000_000 * 10 ** decimals(); // 1 million AIX tokens
        _mint(msg.sender, initialSupply);
    }

    // Resource usage tracking
    struct ComputationalResources {
        uint256 cpuUsage;
        uint256 gpuUsage;
        uint256 timestamp;
    }

    // Mapping from task ID to computational resources
    mapping(bytes32 => ComputationalResources) public taskResources;

    // Resource pricing (in token units)
    uint256 public cpuPricePerUnit = 1 * 10 ** 16; // 0.01 AIX per CPU unit
    uint256 public gpuPricePerUnit = 5 * 10 ** 16; // 0.05 AIX per GPU unit

    // Authorized minters (validators)
    mapping(address => bool) public authorizedMinters;

    // Constants for resource identifiers
    bytes32 public constant CPU_RESOURCE = keccak256("CPU_RESOURCE");
    bytes32 public constant GPU_RESOURCE = keccak256("GPU_RESOURCE");
    bytes32 public constant ELECTRICITY_RESOURCE = keccak256("ELECTRICITY");

    // Events
    event ResourcesRecorded(bytes32 taskId, uint256 cpuUsage, uint256 gpuUsage);
    event ResourcePricingUpdated(uint256 newCpuPrice, uint256 newGpuPrice);

    // Add a minter
    function addMinter(address minter) external onlyOwner {
        authorizedMinters[minter] = true;
    }

    // Remove a minter
    function removeMinter(address minter) external onlyOwner {
        authorizedMinters[minter] = false;
    }

    // Record computational resources for a task
    function recordTaskResources(
        bytes32 taskId,
        uint256 cpuUsage,
        uint256 gpuUsage
    ) external {
        require(
            authorizedMinters[msg.sender],
            "Not authorized to record resources"
        );

        taskResources[taskId] = ComputationalResources({
            cpuUsage: cpuUsage,
            gpuUsage: gpuUsage,
            timestamp: block.timestamp
        });

        emit ResourcesRecorded(taskId, cpuUsage, gpuUsage);
    }

    // Mint tokens based on computational resources
    function mintForTask(
        address to,
        bytes32 taskId
    ) external returns (uint256) {
        require(authorizedMinters[msg.sender], "Not authorized to mint");
        require(
            taskResources[taskId].timestamp > 0,
            "Task resources not recorded"
        );

        // Calculate token amount based on resource usage
        uint256 cpuCost = taskResources[taskId].cpuUsage * cpuPricePerUnit;
        uint256 gpuCost = taskResources[taskId].gpuUsage * gpuPricePerUnit;
        uint256 totalAmount = cpuCost + gpuCost;

        // Mint tokens
        _mint(to, totalAmount);

        // Clear task resources to prevent double-minting
        delete taskResources[taskId];

        return totalAmount;
    }

    // Update resource pricing (only owner)
    function updateResourcePricing(
        uint256 newCpuPrice,
        uint256 newGpuPrice
    ) external onlyOwner {
        cpuPricePerUnit = newCpuPrice;
        gpuPricePerUnit = newGpuPrice;

        emit ResourcePricingUpdated(newCpuPrice, newGpuPrice);
    }

    function mintForVerifiedWork(
        bytes32 attestationId
    ) external returns (uint256) {
        address verificationAddress = registry.aixVerification();
        IAIXVerification verification = IAIXVerification(verificationAddress);

        (
            bool verified,
            IAIXVerification.VerifiedWork memory work
        ) = verification.checkVerificationStatus(attestationId);

        require(verified, "Work not verified");
        require(work.worker == msg.sender, "Caller is not the worker");

        address valuationAddress = registry.aixValuation();
        IAIXValuation valuation = IAIXValuation(valuationAddress);

        uint256 tokenAmount = calculateTokenAmount(valuation, work);

        _mint(msg.sender, tokenAmount);

        emit TokensMintedForVerifiedWork(
            attestationId,
            msg.sender,
            tokenAmount
        );

        return tokenAmount;
    }

    function calculateTokenAmount(
        IAIXValuation valuation,
        IAIXVerification.VerifiedWork memory work
    ) internal view returns (uint256) {
        uint256 cpuPrice = valuation.getLatestPrice(CPU_RESOURCE);
        uint256 gpuPrice = valuation.getLatestPrice(GPU_RESOURCE);
        uint256 electricityPrice = valuation.getLatestPrice(
            ELECTRICITY_RESOURCE
        );

        uint256 cpuValue = work.cpuUsage * cpuPrice;
        uint256 gpuValue = work.gpuUsage * gpuPrice;
        uint256 energyValue = work.energyUsage * electricityPrice;

        uint256 totalValue = cpuValue + gpuValue + energyValue;

        return totalValue;
    }
}
