// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

interface IFTSO {
    function getCurrentPrice()
        external
        view
        returns (uint256 price, uint256 timestamp, uint256 decimals);
}

interface IFTSORegistry {
    function getFTSOAddress(bytes32 resource) external view returns (address);
}

contract AIXValuation {
    IFTSORegistry public ftsoRegistry;

    uint256 public cpuWeight = 40;
    uint256 public gpuWeight = 40;
    uint256 public electricityWeight = 20;

    bytes32 public constant CPU_RESOURCE = keccak256("CPU_RESOURCE");
    bytes32 public constant GPU_RESOURCE = keccak256("GPU_RESOURCE");
    bytes32 public constant ELECTRICITY = keccak256("ELECTRICITY");

    constructor(address _ftsoRegistry) {
        ftsoRegistry = IFTSORegistry(_ftsoRegistry);
    }

    function getCurrentAIXValue() external view returns (uint256) {
        uint256 cpuPrice = getLatestPrice(CPU_RESOURCE);
        uint256 gpuPrice = getLatestPrice(GPU_RESOURCE);
        uint256 electricityPrice = getLatestPrice(ELECTRICITY);

        uint256 aixValue = (cpuPrice *
            cpuWeight +
            gpuPrice *
            gpuWeight +
            electricityPrice *
            electricityWeight) / 100;

        return aixValue;
    }

    function getLatestPrice(bytes32 resource) internal view returns (uint256) {
        address ftsoAddress = ftsoRegistry.getFTSOAddress(resource);
        IFTSO ftso = IFTSO(ftsoAddress);

        (uint256 price, uint256 timestamp, uint256 decimals) = ftso
            .getCurrentPrice();

        return price;
    }

    function updateWeights(
        uint256 _cpuWeight,
        uint256 _gpuWeight,
        uint256 _electricityWeight
    ) external {
        require(
            _cpuWeight + _gpuWeight + _electricityWeight == 100,
            "Weights must sum to 100"
        );

        cpuWeight = _cpuWeight;
        gpuWeight = _gpuWeight;
        electricityWeight = _electricityWeight;
    }
}
