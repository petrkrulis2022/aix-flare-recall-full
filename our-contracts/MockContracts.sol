// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MockFTSORegistry {
    function getCurrentPrice(
        string memory _symbol
    )
        external
        view
        returns (uint256 _price, uint256 _timestamp, uint256 _decimals)
    {
        if (keccak256(bytes(_symbol)) == keccak256(bytes("TAO"))) {
            return (1500000000, block.timestamp, 8); // $15.00
        } else if (keccak256(bytes(_symbol)) == keccak256(bytes("RNDR"))) {
            return (800000000, block.timestamp, 8); // $8.00
        } else if (keccak256(bytes(_symbol)) == keccak256(bytes("SUP"))) {
            return (500000000, block.timestamp, 8); // $5.00
        }
        return (100000000, block.timestamp, 8); // $1.00 default
    }
}

contract MockFDCClient {
    mapping(bytes32 => bool) public attestations;

    function submitAttestationRequest(
        string memory,
        bytes32 requestId,
        bytes memory
    ) external returns (bool) {
        // For demo purposes, automatically verify all attestations
        attestations[requestId] = true;
        return true;
    }

    function checkAttestationStatus(
        bytes32 requestId
    ) external view returns (bool verified, bytes memory data) {
        return (attestations[requestId], "");
    }
}
