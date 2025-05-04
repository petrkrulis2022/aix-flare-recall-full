// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract GPUPriceProvider is Ownable {
    uint256 public gpuPrice;

    event GPUPriceUpdated(uint256 newPrice);

    constructor(address initialOwner) Ownable(initialOwner) {}

    function updateGPUPrice(uint256 _newPrice) external onlyOwner {
        gpuPrice = _newPrice;
        emit GPUPriceUpdated(_newPrice);
    }

    function getGPUPrice() external view returns (uint256) {
        return gpuPrice;
    }
}
