// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./AIXSystemRegistry.sol";

contract AIXGovernance {
    AIXSystemRegistry public registry;

    uint256 public votingPeriod = 3 days;
    uint256 public executionDelay = 2 days;

    struct Proposal {
        bytes32 id;
        address proposer;
        bytes32 proposalType;
        bytes parameters;
        uint256 startTime;
        uint256 endTime;
        uint256 forVotes;
        uint256 againstVotes;
        bool executed;
    }

    mapping(bytes32 => Proposal) public proposals;

    event ProposalCreated(bytes32 id, address proposer, bytes32 proposalType);

    constructor(address _registry) {
        registry = AIXSystemRegistry(_registry);
    }

    function createProposal(
        bytes32 proposalType,
        bytes calldata parameters
    ) external returns (bytes32) {
        bytes32 proposalId = keccak256(
            abi.encodePacked(proposalType, parameters, block.timestamp)
        );

        proposals[proposalId] = Proposal({
            id: proposalId,
            proposer: msg.sender,
            proposalType: proposalType,
            parameters: parameters,
            startTime: block.timestamp,
            endTime: block.timestamp + votingPeriod,
            forVotes: 0,
            againstVotes: 0,
            executed: false
        });

        emit ProposalCreated(proposalId, msg.sender, proposalType);

        return proposalId;
    }
}
