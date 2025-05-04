// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAttestationProvider {
    function createAttestation(
        string memory workType,
        string memory details
    ) external returns (bytes32);

    function getAttestation(
        bytes32 attestationId
    )
        external
        view
        returns (
            address provider,
            string memory workType,
            uint256 timestamp,
            string memory details
        );
}
