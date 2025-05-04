// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./AIXSystemRegistry.sol";

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

contract AIXToken is ERC20 {
    AIXSystemRegistry public registry;

    event TokensMintedForVerifiedWork(
        bytes32 attestationId,
        address worker,
        uint256 amount
    );

    constructor(address _registry) ERC20("AI Exchange Token", "AIX") {
        registry = AIXSystemRegistry(_registry);
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
        uint256 cpuPrice = valuation.getLatestPrice(keccak256("CPU_RESOURCE"));
        uint256 gpuPrice = valuation.getLatestPrice(keccak256("GPU_RESOURCE"));
        uint256 electricityPrice = valuation.getLatestPrice(
            keccak256("ELECTRICITY")
        );

        uint256 cpuValue = work.cpuUsage * cpuPrice;
        uint256 gpuValue = work.gpuUsage * gpuPrice;
        uint256 energyValue = work.energyUsage * electricityPrice;

        uint256 totalValue = cpuValue + gpuValue + energyValue;

        return totalValue;
    }
}
