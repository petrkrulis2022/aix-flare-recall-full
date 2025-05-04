// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AttestationProvider is Ownable {
    struct Attestation {
        address provider;
        string workType;
        uint256 timestamp;
        string details;
    }

    mapping(bytes32 => Attestation) public attestations;

    event AttestationCreated(
        bytes32 indexed attestationId,
        address indexed provider,
        string workType,
        uint256 timestamp
    );

    constructor(address initialOwner) Ownable(initialOwner) {}

    function createAttestation(
        string memory workType,
        string memory details
    ) external virtual returns (bytes32) {
        bytes32 attestationId = keccak256(
            abi.encodePacked(msg.sender, workType, block.timestamp)
        );

        attestations[attestationId] = Attestation({
            provider: msg.sender,
            workType: workType,
            timestamp: block.timestamp,
            details: details
        });

        emit AttestationCreated(
            attestationId,
            msg.sender,
            workType,
            block.timestamp
        );

        return attestationId;
    }

    function getAttestation(
        bytes32 attestationId
    ) external view virtual returns (Attestation memory) {
        return attestations[attestationId];
    }
}
