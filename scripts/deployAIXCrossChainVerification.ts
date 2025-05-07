import { ethers } from "hardhat";

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    // Deploy a mock IFDCRegistry contract
    const MockIFDCRegistry = await ethers.getContractFactory("MockIFDCRegistry");
    const fdcRegistry = await MockIFDCRegistry.deploy(deployer.address);
    await fdcRegistry.deployed();
    console.log("Mock IFDCRegistry deployed to:", fdcRegistry.address);

    // Deploy AIXVerification contract as a dependency
    const AIXVerification = await ethers.getContractFactory("AIXVerification");
    const aixVerification = await AIXVerification.deploy(fdcRegistry.address);
    await aixVerification.deployed();
    console.log("AIXVerification deployed to:", aixVerification.address);

    // Mock address for IFDCClient (replace with actual address if available)
    const fdcClientAddress = "0x0000000000000000000000000000000000000001";

    // Deploy AIXCrossChainVerification contract
    const AIXCrossChainVerification = await ethers.getContractFactory("AIXCrossChainVerification");
    const contract = await AIXCrossChainVerification.deploy(aixVerification.address, fdcClientAddress);

    await contract.deployed();
    console.log("AIXCrossChainVerification deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
