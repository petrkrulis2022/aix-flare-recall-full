// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IAttestationProvider.sol";
import "./AttestationProvider.sol";

contract ComputationalWorkAttestation is AttestationProvider {
    struct WorkDetails {
        string hardwareSpecs;
        uint256 computationTime;
        uint256 energyConsumption;
    }

    mapping(bytes32 => WorkDetails) public workDetails;

    event WorkAttested(
        bytes32 indexed attestationId,
        string hardwareSpecs,
        uint256 computationTime,
        uint256 energyConsumption
    );

    constructor(address initialOwner) AttestationProvider(initialOwner) {}

    function attestWork(
        string memory workType,
        string memory hardwareSpecs,
        uint256 computationTime,
        uint256 energyConsumption,
        string memory details
    ) external returns (bytes32) {
        bytes32 attestationId = createAttestation(workType, details);

        workDetails[attestationId] = WorkDetails({
            hardwareSpecs: hardwareSpecs,
            computationTime: computationTime,
            energyConsumption: energyConsumption
        });

        emit WorkAttested(
            attestationId,
            hardwareSpecs,
            computationTime,
            energyConsumption
        );

        return attestationId;
    }

    function createAttestation(
        string memory workType,
        string memory details
    ) public override returns (bytes32) {
        bytes32 attestationId = keccak256(
            abi.encodePacked(workType, details, block.timestamp)
        );

        attestations[attestationId] = Attestation({
            provider: msg.sender,
            workType: workType,
            timestamp: block.timestamp,
            details: details
        });

        return attestationId;
    }

    function getWorkDetails(
        bytes32 attestationId
    ) external view returns (WorkDetails memory) {
        return workDetails[attestationId];
    }

    function getAttestation(
        bytes32 attestationId
    ) external view virtual override returns (Attestation memory) {
        return attestations[attestationId];
    }
}
