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

    struct Task {
        bytes32 taskId;
        address worker;
        bytes32 attestationId;
        bool verified;
        bool paid;
        uint256 timestamp;
    }

    mapping(bytes32 => VerifiedWork) public verifiedWork;
    mapping(bytes32 => Task) public tasks;

    event VerificationRequested(
        bytes32 attestationId,
        bytes32 workId,
        address requester
    );

    event TaskSubmitted(bytes32 taskId, address worker);
    event TaskVerified(bytes32 taskId, bool success);
    event TaskPaid(bytes32 taskId, address worker, uint256 amount);

    constructor(address _fdcRegistry) {
        fdcRegistry = IFDCRegistry(_fdcRegistry);
    }

    function verifyComputationalWork(
        bytes32 workId,
        bytes memory workProof
    ) public returns (bytes32 attestationId) {
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
    ) public view returns (bool verified, VerifiedWork memory work) {
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
        bytes memory /* data */
    ) internal view returns (VerifiedWork memory work) {
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

    function verifyData(bytes memory /* data */) public pure returns (bool) {
        return true;
    }

    function getVerificationTime() public view returns (uint256) {
        return block.timestamp;
    }

    function submitTask(
        bytes32 taskId,
        bytes memory workProof
    ) external returns (bytes32) {
        bytes32 attestationId = verifyComputationalWork(taskId, workProof);

        tasks[taskId] = Task({
            taskId: taskId,
            worker: msg.sender,
            attestationId: attestationId,
            verified: false,
            paid: false,
            timestamp: block.timestamp
        });

        emit TaskSubmitted(taskId, msg.sender);

        return attestationId;
    }

    function verifyTask(bytes32 taskId) external returns (bool) {
        Task storage task = tasks[taskId];

        require(task.timestamp > 0, "Task not found");
        require(!task.verified, "Task already verified");

        (bool verified, VerifiedWork memory work) = checkVerificationStatus(
            task.attestationId
        );

        if (verified) {
            task.verified = true;
        }

        emit TaskVerified(taskId, verified);

        return verified;
    }

    function payForTask(bytes32 taskId) external returns (uint256) {
        Task storage task = tasks[taskId];

        require(task.timestamp > 0, "Task not found");
        require(task.verified, "Task not verified");
        require(!task.paid, "Task already paid");

        uint256 amount = 100; // Placeholder for payment logic

        task.paid = true;

        emit TaskPaid(taskId, task.worker, amount);

        return amount;
    }
}
