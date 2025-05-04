// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

// ====================================================================================================================
//
//
// DEPRECATED: use Web2Json instead
//
//
// ====================================================================================================================

import {ContractRegistry} from "@flarenetwork/flare-periphery-contracts/coston/ContractRegistry.sol";
import {IJsonApi} from "@flarenetwork/flare-periphery-contracts/coston/IJsonApi.sol";
import {IJsonApiVerification} from "./IJsonApiVerification.sol";

struct StarWarsCharacter {
    string name;
    uint256 numberOfMovies;
    uint256 apiUid;
    uint256 bmi;
}

struct DataTransportObject {
    string name;
    uint256 height;
    uint256 mass;
    uint256 numberOfMovies;
    uint256 apiUid;
}

struct ChainOfThought {
    string userId;
    string agentId;
    string userMessage;
    string log;
    uint256 cpuUsage;
    uint256 gpuUsage;
}

interface IStarWarsCharacterList {
    function addCharacter(IJsonApi.Proof calldata data) external;

    function getAllCharacters()
        external
        view
        returns (StarWarsCharacter[] memory);
}

contract StarWarsCharacterList {
    mapping(uint256 => StarWarsCharacter) public characters;
    uint256[] public characterIds;

    function addCharacter(IJsonApi.Proof calldata data) public {
        require(isJsonApiProofValid(data), "Invalid proof");

        DataTransportObject memory dto = abi.decode(
            data.data.responseBody.abi_encoded_data,
            (DataTransportObject)
        );

        require(characters[dto.apiUid].apiUid == 0, "Character already exists");

        StarWarsCharacter memory character = StarWarsCharacter({
            name: dto.name,
            numberOfMovies: dto.numberOfMovies,
            apiUid: dto.apiUid,
            bmi: (dto.mass * 100 * 100) / (dto.height * dto.height)
        });

        characters[dto.apiUid] = character;
        characterIds.push(dto.apiUid);
    }

    function getAllCharacters()
        public
        view
        returns (StarWarsCharacter[] memory)
    {
        StarWarsCharacter[] memory result = new StarWarsCharacter[](
            characterIds.length
        );
        for (uint256 i = 0; i < characterIds.length; i++) {
            result[i] = characters[characterIds[i]];
        }
        return result;
    }

    function abiSignatureHack(DataTransportObject calldata dto) public pure {}

    function isJsonApiProofValid(
        IJsonApi.Proof calldata _proof
    ) private pure returns (bool) {
        // Mock validation logic for demo purposes
        return keccak256(abi.encode(_proof.data)) != bytes32(0);
    }
}

contract JsonApi {
    mapping(uint256 => ChainOfThought) public chainOfThoughts;
    uint256[] public thoughtIds;

    event ChainOfThoughtAdded(
        uint256 indexed thoughtId,
        string userId,
        string agentId
    );

    function addChainOfThought(IJsonApi.Proof calldata data) public {
        require(isJsonApiProofValid(data), "Invalid proof");

        ChainOfThought memory thought = abi.decode(
            data.data.responseBody.abi_encoded_data,
            (ChainOfThought)
        );

        uint256 thoughtId = uint256(
            keccak256(
                abi.encodePacked(
                    thought.userId,
                    thought.agentId,
                    thought.userMessage
                )
            )
        );
        require(
            chainOfThoughts[thoughtId].cpuUsage == 0,
            "Chain of thought already exists"
        );

        chainOfThoughts[thoughtId] = thought;
        thoughtIds.push(thoughtId);

        emit ChainOfThoughtAdded(thoughtId, thought.userId, thought.agentId);
    }

    function getAllChainOfThoughts()
        public
        view
        returns (ChainOfThought[] memory)
    {
        ChainOfThought[] memory result = new ChainOfThought[](
            thoughtIds.length
        );
        for (uint256 i = 0; i < thoughtIds.length; i++) {
            result[i] = chainOfThoughts[thoughtIds[i]];
        }
        return result;
    }

    function isJsonApiProofValid(
        IJsonApi.Proof calldata _proof
    ) private pure returns (bool) {
        // Mock validation logic for demo purposes
        return keccak256(abi.encode(_proof.data)) != bytes32(0);
    }
}
