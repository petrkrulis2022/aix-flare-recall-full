# Contracts

These are the contracts used in examples.
For a more detailed explanation look at `scripts/README.md`.

## Directory structure

```
contracts
├── fdcExample: contracts used in examples for all attestation types
├── proofOfReserves: contracts used in the Proof of reserves dApp example
├── GuessingGame.sol: simple guessing game contract using Flare's Secure Random
├── HelloWorld.sol: an example of a simple contract
├── PriceAnalytics.sol
├── README.md
└── SimpleFtsoExample.sol
```

# Contracts Directory

This directory contains all the smart contracts for the project. Organize contracts by functionality or module.

## Structure

- **AIXSystemRegistry.sol**: Manages system-wide registrations and permissions.
- **AIXToken.sol**: Implements the ERC-20 token with additional features.
- **AIXValuation.sol**: Handles resource valuation and price feed integration.
- **AIXVerification.sol**: Manages work verification and cross-chain attestations.

Subdirectories:

- **crossChainPayment/**: Contracts related to cross-chain payments.
- **fassets/**: Contracts for Flare assets.
- **fdcExample/**: Example contracts for FDC integration.
- **proofOfReserves/**: Proof of reserves contracts.
- **weatherInsurance/**: Contracts for weather-based insurance.
