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

interface IFDCRegistry {
    function getAttestationProvider(
        bytes32 attestationType
    ) external view returns (address);
}

contract AIXVerification {
    IFDCRegistry public fdcRegistry;

    struct VerifiedWork {
        bytes32 workId;
        address worker;
        uint256 cpuUsage;
        uint256 gpuUsage;
        uint256 memoryUsage;
        uint256 energyUsage;
        uint256 verificationTime;
        bool verified;
    }

    mapping(bytes32 => VerifiedWork) public verifiedWork;

    event VerificationRequested(
        bytes32 attestationId,
        bytes32 workId,
        address requester
    );

    constructor(address _fdcRegistry) {
        fdcRegistry = IFDCRegistry(_fdcRegistry);
    }

    function verifyComputationalWork(
        bytes32 workId,
        bytes calldata workProof
    ) external returns (bytes32 attestationId) {
        address providerAddress = fdcRegistry.getAttestationProvider(
            keccak256("COMPUTATIONAL_WORK")
        );
        IAIXAttestationProvider provider = IAIXAttestationProvider(
            providerAddress
        );

        attestationId = provider.requestWorkAttestation(
            workId,
            msg.sender,
            workProof
        );

        emit VerificationRequested(attestationId, workId, msg.sender);

        return attestationId;
    }

    function checkVerificationStatus(
        bytes32 attestationId
    ) external view returns (bool verified, VerifiedWork memory work) {
        if (verifiedWork[attestationId].verified) {
            return (true, verifiedWork[attestationId]);
        }

        address providerAddress = fdcRegistry.getAttestationProvider(
            keccak256("COMPUTATIONAL_WORK")
        );
        IAIXAttestationProvider provider = IAIXAttestationProvider(
            providerAddress
        );

        (bool attestationVerified, bytes memory attestationData) = provider
            .verifyAttestation(attestationId);

        if (!attestationVerified) {
            return (false, VerifiedWork(0, address(0), 0, 0, 0, 0, 0, false));
        }

        return (true, parseAttestationData(attestationData));
    }

    function parseAttestationData(
        bytes memory data
    ) internal pure returns (VerifiedWork memory work) {
        return
            VerifiedWork({
                workId: bytes32(0),
                worker: address(0),
                cpuUsage: 0,
                gpuUsage: 0,
                memoryUsage: 0,
                energyUsage: 0,
                verificationTime: block.timestamp,
                verified: true
            });
    }
}
