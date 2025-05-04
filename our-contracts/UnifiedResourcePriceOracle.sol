// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IFtsoRegistry {
    function getCurrentPrice(
        string memory _symbol
    )
        external
        view
        returns (uint256 _price, uint256 _timestamp, uint256 _decimals);
}

contract UnifiedResourcePriceOracle is Ownable {
    // FTSO Registry contract
    IFtsoRegistry public ftsoRegistry;

    // Resource prices
    uint256 public awsCpuPrice = 5; // 5 cents per CPU unit
    uint256 public awsGpuPrice = 25; // 25 cents per GPU unit
    uint256 public electricityPrice = 10; // 10 cents per kWh

    // Events
    event AwsPriceUpdated(string resourceType, uint256 newPrice);
    event ElectricityPriceUpdated(uint256 newPrice);

    constructor(address _ftsoRegistry) Ownable(msg.sender) {
        ftsoRegistry = IFtsoRegistry(_ftsoRegistry);
    }

    // Update FTSO Registry address
    function updateFtsoRegistry(address _ftsoRegistry) external onlyOwner {
        ftsoRegistry = IFtsoRegistry(_ftsoRegistry);
    }

    // Update AWS prices
    function updateAwsPrices(
        uint256 _cpuPrice,
        uint256 _gpuPrice
    ) external onlyOwner {
        awsCpuPrice = _cpuPrice;
        awsGpuPrice = _gpuPrice;

        emit AwsPriceUpdated("CPU", _cpuPrice);
        emit AwsPriceUpdated("GPU", _gpuPrice);
    }

    // Update electricity price
    function updateElectricityPrice(uint256 _newPrice) external onlyOwner {
        electricityPrice = _newPrice;
        emit ElectricityPriceUpdated(_newPrice);
    }

    // Fetch current prices from FTSO
    function fetchCurrentPrices(
        string memory symbol
    )
        external
        view
        returns (uint256 price, uint256 timestamp, uint256 decimals)
    {
        return ftsoRegistry.getCurrentPrice(symbol);
    }

    // Get resource cost
    function getResourceCost(
        uint256 cpuUsage,
        uint256 gpuUsage,
        uint256 electricityUsage
    ) external view returns (uint256 totalCost) {
        uint256 cpuCost = cpuUsage * awsCpuPrice;
        uint256 gpuCost = gpuUsage * awsGpuPrice;
        uint256 energyCost = electricityUsage * electricityPrice;

        totalCost = cpuCost + gpuCost + energyCost;
        return totalCost;
    }
}
