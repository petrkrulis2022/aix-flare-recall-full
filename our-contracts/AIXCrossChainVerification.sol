// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./AIXVerification.sol";

interface IFDCClient {
    function submitAttestationRequest(
        string calldata attestationType,
        bytes32 attestationId,
        bytes calldata workProof
    ) external;
}

contract AIXCrossChainVerification {
    AIXVerification public aixVerification;
    IFDCClient public fdcClient;

    mapping(bytes32 => bool) public supportedBlockchains;

    event CrossChainVerificationRequested(
        bytes32 attestationId,
        bytes32 chainId,
        bytes32 txHash,
        address requester
    );

    constructor(address _aixVerification, address _fdcClient) {
        aixVerification = AIXVerification(_aixVerification);
        fdcClient = IFDCClient(_fdcClient);

        supportedBlockchains[keccak256("ETHEREUM")] = true;
        supportedBlockchains[keccak256("POLYGON")] = true;
        supportedBlockchains[keccak256("AVALANCHE")] = true;
    }

    function verifyCrossChainWork(
        bytes32 chainId,
        bytes32 txHash,
        bytes calldata workProof
    ) external returns (bytes32 attestationId) {
        require(supportedBlockchains[chainId], "Blockchain not supported");

        bytes memory crossChainProof = abi.encodePacked(
            chainId,
            txHash,
            workProof
        );

        bytes32 workId = keccak256(crossChainProof);

        attestationId = aixVerification.verifyComputationalWork(
            workId,
            crossChainProof
        );

        emit CrossChainVerificationRequested(
            attestationId,
            chainId,
            txHash,
            msg.sender
        );

        return attestationId;
    }
}
