// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

interface IAIXAttestationProvider {
    function requestWorkAttestation(
        bytes32 workId,
        address requester,
        bytes calldata workProof
    ) external returns (bytes32 attestationId);

    function verifyAttestation(
        bytes32 attestationId
    ) external view returns (bool verified, bytes memory attestationData);
}
