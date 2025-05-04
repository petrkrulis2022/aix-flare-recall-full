import { ethers } from "hardhat";

async function main() {
    const AIXCrossChainVerification = await ethers.getContractFactory("AIXCrossChainVerification");
    const contract = await AIXCrossChainVerification.deploy();

    await contract.deployed();
    console.log("AIXCrossChainVerification deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
