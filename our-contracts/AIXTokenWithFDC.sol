// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./AIXValuation.sol";
import "./AIXVerification.sol";

contract AIXTokenWithFDC is ERC20 {
    AIXValuation public aixValuation;
    AIXVerification public aixVerification;

    event TokensMintedForVerifiedWork(
        bytes32 attestationId,
        address worker,
        uint256 amount
    );

    constructor(
        address _aixValuation,
        address _aixVerification
    ) ERC20("AI Exchange Token", "AIX") {
        aixValuation = AIXValuation(_aixValuation);
        aixVerification = AIXVerification(_aixVerification);
    }

    function mintForVerifiedWork(
        bytes32 attestationId
    ) external returns (uint256) {
        (
            bool verified,
            AIXVerification.VerifiedWork memory work
        ) = aixVerification.checkVerificationStatus(attestationId);

        require(verified, "Work not verified");
        require(work.worker == msg.sender, "Caller is not the worker");

        uint256 tokenAmount = calculateTokenAmountFromVerifiedWork(work);

        _mint(msg.sender, tokenAmount);

        emit TokensMintedForVerifiedWork(
            attestationId,
            msg.sender,
            tokenAmount
        );

        return tokenAmount;
    }

    function calculateTokenAmountFromVerifiedWork(
        AIXVerification.VerifiedWork memory work
    ) internal view returns (uint256) {
        uint256 cpuPrice = aixValuation.getLatestPrice(
            aixValuation.CPU_RESOURCE()
        );
        uint256 gpuPrice = aixValuation.getLatestPrice(
            aixValuation.GPU_RESOURCE()
        );
        uint256 electricityPrice = aixValuation.getLatestPrice(
            aixValuation.ELECTRICITY()
        );

        uint256 cpuValue = work.cpuUsage * cpuPrice;
        uint256 gpuValue = work.gpuUsage * gpuPrice;
        uint256 energyValue = work.energyUsage * electricityPrice;

        uint256 totalValue = cpuValue + gpuValue + energyValue;

        return totalValue;
    }
}
