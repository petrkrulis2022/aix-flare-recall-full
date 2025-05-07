// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../interfaces/IAIXAttestationProvider.sol";

contract MockIFDCRegistry {
    address public attestationProvider;

    constructor(address _attestationProvider) {
        attestationProvider = _attestationProvider;
    }

    function getAttestationProvider(
        bytes32 /* attestationType */
    ) external view returns (address) {
        return attestationProvider;
    }
}
