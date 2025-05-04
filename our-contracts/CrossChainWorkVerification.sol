// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ComputationalWorkAttestation.sol";
import "./AttestationProvider.sol";

contract CrossChainWorkVerification is ComputationalWorkAttestation {
    // Inherit the `attestations` mapping from `AttestationProvider`
    struct CrossChainVerification {
        bytes32 sourceChainAttestationId;
        bytes32 targetChainAttestationId;
        bool verified;
    }

    mapping(bytes32 => CrossChainVerification) public crossChainVerifications;

    event CrossChainVerified(
        bytes32 indexed verificationId,
        bytes32 sourceChainAttestationId,
        bytes32 targetChainAttestationId,
        bool verified
    );

    constructor(
        address initialOwner
    ) ComputationalWorkAttestation(initialOwner) {
        // Initialize the mapping if needed
    }

    function verifyCrossChainWork(
        bytes32 sourceChainAttestationId,
        bytes32 targetChainAttestationId
    ) external returns (bytes32) {
        // Emit debug events to log the attestation details being checked
        emit CrossChainVerified(
            keccak256(abi.encodePacked("Debug", block.timestamp)),
            sourceChainAttestationId,
            targetChainAttestationId,
            attestations[sourceChainAttestationId].provider != address(0)
        );

        require(
            AttestationProvider
                .attestations[sourceChainAttestationId]
                .provider != address(0),
            "Source attestation does not exist"
        );
        require(
            AttestationProvider
                .attestations[targetChainAttestationId]
                .provider != address(0),
            "Target attestation does not exist"
        );

        bytes32 verificationId = keccak256(
            abi.encodePacked(
                sourceChainAttestationId,
                targetChainAttestationId,
                block.timestamp
            )
        );

        crossChainVerifications[verificationId] = CrossChainVerification({
            sourceChainAttestationId: sourceChainAttestationId,
            targetChainAttestationId: targetChainAttestationId,
            verified: true
        });

        emit CrossChainVerified(
            verificationId,
            sourceChainAttestationId,
            targetChainAttestationId,
            true
        );

        return verificationId;
    }

    function getCrossChainVerification(
        bytes32 verificationId
    ) external view returns (CrossChainVerification memory) {
        return crossChainVerifications[verificationId];
    }

    function getAttestation(
        bytes32 attestationId
    ) external view override returns (Attestation memory) {
        return attestations[attestationId];
    }
}
