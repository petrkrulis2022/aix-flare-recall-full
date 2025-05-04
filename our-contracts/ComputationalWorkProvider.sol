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

    function registerProvider(
        address provider,
        bytes calldata credentials
    ) external returns (bool);
}

interface IFDCClient {
    function submitAttestationRequest(
        string calldata attestationType,
        bytes32 attestationId,
        bytes calldata workProof
    ) external;

    function checkAttestationStatus(
        bytes32 attestationId
    ) external view returns (bool verified, bytes memory attestationData);
}

contract ComputationalWorkProvider is IAIXAttestationProvider {
    IFDCClient public fdcClient;

    struct AttestationRequest {
        bytes32 workId;
        address requester;
        bytes workProof;
        bool verified;
        uint256 timestamp;
        bytes attestationData;
    }

    mapping(bytes32 => AttestationRequest) private attestationRequests;

    event AttestationRequested(
        bytes32 attestationId,
        bytes32 workId,
        address requester
    );
    event AttestationCompleted(bytes32 attestationId, bool verified);

    constructor(address _fdcClient) {
        fdcClient = IFDCClient(_fdcClient);
    }

    function requestWorkAttestation(
        bytes32 workId,
        address requester,
        bytes calldata workProof
    ) external override returns (bytes32 attestationId) {
        attestationId = keccak256(
            abi.encodePacked(workId, requester, block.timestamp)
        );

        attestationRequests[attestationId] = AttestationRequest({
            workId: workId,
            requester: requester,
            workProof: workProof,
            verified: false,
            timestamp: block.timestamp,
            attestationData: ""
        });

        fdcClient.submitAttestationRequest(
            "COMPUTATIONAL_WORK",
            attestationId,
            workProof
        );

        emit AttestationRequested(attestationId, workId, requester);

        return attestationId;
    }

    function verifyAttestation(
        bytes32 attestationId
    )
        external
        view
        override
        returns (bool verified, bytes memory attestationData)
    {
        AttestationRequest storage request = attestationRequests[attestationId];

        require(request.timestamp > 0, "Attestation not found");

        if (request.verified) {
            return (true, request.attestationData);
        }

        (bool fdcVerified, bytes memory fdcData) = fdcClient
            .checkAttestationStatus(attestationId);

        return (fdcVerified, fdcData);
    }

    function attestationCallback(
        bytes32 attestationId,
        bool verified,
        bytes calldata attestationData
    ) external {
        AttestationRequest storage request = attestationRequests[attestationId];
        request.verified = verified;
        request.attestationData = attestationData;

        emit AttestationCompleted(attestationId, verified);
    }

    function registerProvider(
        address provider,
        bytes calldata credentials
    ) external pure override returns (bool) {
        // Simplified implementation for example purposes
        return true;
    }
}
