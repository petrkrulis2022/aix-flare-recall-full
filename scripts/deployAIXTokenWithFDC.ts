import { ethers } from "hardhat";

async function main() {
    // Retrieve deployed contract addresses
    const aixValuationAddress = "<AIXValuation_Contract_Address>"; // Replace with actual address
    const aixVerificationAddress = "<AIXVerification_Contract_Address>"; // Replace with actual address

    // Deploy AIXTokenWithFDC with required constructor arguments
    const AIXTokenWithFDC = await ethers.getContractFactory("AIXTokenWithFDC");
    const contract = await AIXTokenWithFDC.deploy(aixValuationAddress, aixVerificationAddress);

    await contract.deployed();
    console.log("AIXTokenWithFDC deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
