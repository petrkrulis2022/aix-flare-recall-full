// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract AIXSystemRegistry {
    address public aixToken;
    address public aixValuation;
    address public aixVerification;
    address public aixGovernance;

    address public ftsoRegistry;
    address public fdcRegistry;

    mapping(bytes32 => address) public dataProviders;
    mapping(bytes32 => address) public attestationProviders;

    event DataProviderRegistered(bytes32 dataType, address provider);
    event AttestationProviderRegistered(
        bytes32 attestationType,
        address provider
    );

    constructor(address _ftsoRegistry, address _fdcRegistry) {
        ftsoRegistry = _ftsoRegistry;
        fdcRegistry = _fdcRegistry;
    }

    function initializeSystem(
        address _aixToken,
        address _aixValuation,
        address _aixVerification,
        address _aixGovernance
    ) external {
        aixToken = _aixToken;
        aixValuation = _aixValuation;
        aixVerification = _aixVerification;
        aixGovernance = _aixGovernance;
    }

    function registerDataProvider(bytes32 dataType, address provider) external {
        dataProviders[dataType] = provider;
        emit DataProviderRegistered(dataType, provider);
    }

    function registerAttestationProvider(
        bytes32 attestationType,
        address provider
    ) external {
        attestationProviders[attestationType] = provider;
        emit AttestationProviderRegistered(attestationType, provider);
    }
}
