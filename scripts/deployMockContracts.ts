import { ethers } from "hardhat";

async function main() {
    // Deploy MockFTSORegistry
    const MockFTSORegistry = await ethers.getContractFactory("our-contracts/MockContracts.sol:MockFTSORegistry");
    const ftsoRegistry = await MockFTSORegistry.deploy();
    await ftsoRegistry.deployed();
    console.log("MockFTSORegistry deployed to:", ftsoRegistry.address);

    // Deploy MockFDCClient
    const MockFDCClient = await ethers.getContractFactory("our-contracts/MockContracts.sol:MockFDCClient");
    const fdcClient = await MockFDCClient.deploy();
    await fdcClient.deployed();
    console.log("MockFDCClient deployed to:", fdcClient.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
