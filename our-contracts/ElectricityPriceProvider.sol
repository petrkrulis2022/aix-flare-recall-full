// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ElectricityPriceProvider is Ownable {
    uint256 public electricityPrice;

    event ElectricityPriceUpdated(uint256 newPrice);

    constructor(address initialOwner) Ownable(initialOwner) {}

    function updateElectricityPrice(uint256 _newPrice) external onlyOwner {
        electricityPrice = _newPrice;
        emit ElectricityPriceUpdated(_newPrice);
    }

    function getElectricityPrice() external view returns (uint256) {
        return electricityPrice;
    }
}
