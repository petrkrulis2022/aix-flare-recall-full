# Solidity API

# 

## Functions

### constructor

[object Object]

- **Inputs:**

- **Outputs:**

### resetGame

[object Object]

- **Inputs:**

- **Outputs:**

### guess

[object Object]

- **Inputs:**

- **Outputs:**

## TokenTransfer

```solidity
struct TokenTransfer {
  address from;
  address to;
  uint256 value;
}
```

# 

## Functions

### collectAndProcessTransferEvents

[object Object]

- **Inputs:**

- **Outputs:**

# 

## Functions

### constructor

[object Object]

- **Inputs:**

- **Outputs:**

### collectAndProcessTransferEvents

[object Object]

- **Inputs:**

- **Outputs:**

### getTokenTransfers

[object Object]

- **Inputs:**

- **Outputs:**

### isEVMTransactionProofValid

[object Object]

- **Inputs:**

- **Outputs:**

# 

## Functions

### constructor

[object Object]

- **Inputs:**

- **Outputs:**

### safeMint

[object Object]

- **Inputs:**

- **Outputs:**

### supportsInterface

[object Object]

- **Inputs:**

- **Outputs:**

# 

## Functions

### constructor

[object Object]

- **Inputs:**

- **Outputs:**

### mint

[object Object]

- **Inputs:**

- **Outputs:**

# 

## Functions

### broadcastTokenSupply

[object Object]

- **Inputs:**

- **Outputs:**

## DataTransportObject

```solidity
struct DataTransportObject {
  int256 latitude;
  int256 longitude;
  string description;
  int256 temperature;
  int256 minTemp;
  uint256 windSpeed;
  uint256 windDeg;
}
```

# 

## Functions

### createPolicy

[object Object]

- **Inputs:**

- **Outputs:**

### claimPolicy

[object Object]

- **Inputs:**

- **Outputs:**

### resolvePolicy

[object Object]

- **Inputs:**

- **Outputs:**

### expirePolicy

[object Object]

- **Inputs:**

- **Outputs:**

### retireUnclaimedPolicy

[object Object]

- **Inputs:**

- **Outputs:**

### getInsurer

[object Object]

- **Inputs:**

- **Outputs:**

### getAllPolicies

[object Object]

- **Inputs:**

- **Outputs:**

### abiSignatureHack

[object Object]

- **Inputs:**

- **Outputs:**

## DataTransportObject

```solidity
struct DataTransportObject {
  int256 latitude;
  int256 longitude;
  uint256 weatherId;
  string weatherMain;
  string description;
  uint256 temperature;
  uint256 windSpeed;
  uint256 windDeg;
}
```

# 

## Functions

### createPolicy

[object Object]

- **Inputs:**

- **Outputs:**

### claimPolicy

[object Object]

- **Inputs:**

- **Outputs:**

### resolvePolicy

[object Object]

- **Inputs:**

- **Outputs:**

### expirePolicy

[object Object]

- **Inputs:**

- **Outputs:**

### retireUnclaimedPolicy

[object Object]

- **Inputs:**

- **Outputs:**

### getInsurer

[object Object]

- **Inputs:**

- **Outputs:**

### getAllPolicies

[object Object]

- **Inputs:**

- **Outputs:**

### abiSignatureHack

[object Object]

- **Inputs:**

- **Outputs:**

# 

## Functions

### constructor

[object Object]

- **Inputs:**

- **Outputs:**

### greetWorld

[object Object]

- **Inputs:**

- **Outputs:**

### greetByName

[object Object]

- **Inputs:**

- **Outputs:**

# 

## Functions

### convertToWei

[object Object]

- **Inputs:**

- **Outputs:**

### provableCalculateVariance

[object Object]

- **Inputs:**

- **Outputs:**

# 

## Functions

### getCurrentTokenPriceWithDecimals

[object Object]

- **Inputs:**

- **Outputs:**

### getTokenPriceInUSDWei

[object Object]

- **Inputs:**

- **Outputs:**

### isPriceRatioHigherThan

[object Object]

- **Inputs:**

- **Outputs:**

# 

## Functions

### constructor

[object Object]

- **Inputs:**

- **Outputs:**

### redeem

[object Object]

- **Inputs:**

- **Outputs:**

### getSettings

[object Object]

- **Inputs:**

- **Outputs:**

# 

## Functions

### constructor

[object Object]

- **Inputs:**

- **Outputs:**

### getLotSize

[object Object]

- **Inputs:**

- **Outputs:**

# 

## Functions

### constructor

[object Object]

- **Inputs:**

- **Outputs:**

### getRedemptionQueue

[object Object]

- **Inputs:**

- **Outputs:**

# 

## Functions

### registerAddress

[object Object]

- **Inputs:**

- **Outputs:**

# 

## Functions

### registerAddress

[object Object]

- **Inputs:**

- **Outputs:**

### isAddressValidityProofValid

[object Object]

- **Inputs:**

- **Outputs:**

## TokenTransfer

```solidity
struct TokenTransfer {
  address from;
  address to;
  uint256 value;
}
```

# 

## Functions

### collectTransferEvents

[object Object]

- **Inputs:**

- **Outputs:**

# 

## Functions

### collectTransferEvents

[object Object]

- **Inputs:**

- **Outputs:**

### getTokenTransfers

[object Object]

- **Inputs:**

- **Outputs:**

### isEVMTransactionProofValid

[object Object]

- **Inputs:**

- **Outputs:**

# 

## Functions

### getFdcHub

[object Object]

- **Inputs:**

- **Outputs:**

### getFdcRequestFeeConfigurations

[object Object]

- **Inputs:**

- **Outputs:**

### getFlareSystemsManager

[object Object]

- **Inputs:**

- **Outputs:**

### getRelay

[object Object]

- **Inputs:**

- **Outputs:**

## StarWarsCharacter

```solidity
struct StarWarsCharacter {
  string name;
  uint256 numberOfMovies;
  uint256 apiUid;
  uint256 bmi;
}
```

## DataTransportObject

```solidity
struct DataTransportObject {
  string name;
  uint256 height;
  uint256 mass;
  uint256 numberOfMovies;
  uint256 apiUid;
}
```

# 

## Functions

### addCharacter

[object Object]

- **Inputs:**

- **Outputs:**

### getAllCharacters

[object Object]

- **Inputs:**

- **Outputs:**

# 

## Functions

### addCharacter

[object Object]

- **Inputs:**

- **Outputs:**

### getAllCharacters

[object Object]

- **Inputs:**

- **Outputs:**

### abiSignatureHack

[object Object]

- **Inputs:**

- **Outputs:**

## Payment

```solidity
struct Payment {
  uint64 blockNumber;
  uint64 blockTimestamp;
  bytes32 sourceAddressHash;
  bytes32 receivingAddressHash;
  int256 spentAmount;
  bytes32 standardPaymentReference;
  uint8 status;
}
```

# 

## Functions

### registerPayment

[object Object]

- **Inputs:**

- **Outputs:**

# 

## Functions

### registerPayment

[object Object]

- **Inputs:**

- **Outputs:**

### isPaymentProofValid

[object Object]

- **Inputs:**

- **Outputs:**

## StarWarsCharacter

```solidity
struct StarWarsCharacter {
  string name;
  uint256 numberOfMovies;
  uint256 apiUid;
  uint256 bmi;
}
```

## DataTransportObject

```solidity
struct DataTransportObject {
  string name;
  uint256 height;
  uint256 mass;
  uint256 numberOfMovies;
  uint256 apiUid;
}
```

# 

## Functions

### addCharacter

[object Object]

- **Inputs:**

- **Outputs:**

### getAllCharacters

[object Object]

- **Inputs:**

- **Outputs:**

# 

## Functions

### addCharacter

[object Object]

- **Inputs:**

- **Outputs:**

### getAllCharacters

[object Object]

- **Inputs:**

- **Outputs:**

### abiSignatureHack

[object Object]

- **Inputs:**

- **Outputs:**

## DataTransportObject

```solidity
struct DataTransportObject {
  uint256 reserves;
}
```

# 

## Functions

### constructor

[object Object]

- **Inputs:**

- **Outputs:**

### verifyReserves

[object Object]

- **Inputs:**

- **Outputs:**

### updateAddress

[object Object]

- **Inputs:**

- **Outputs:**

### abiSignatureHack

[object Object]

- **Inputs:**

- **Outputs:**

