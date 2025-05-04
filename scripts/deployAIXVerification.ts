import { ethers } from "hardhat";

async function main() {
    const AIXVerification = await ethers.getContractFactory("AIXVerification");
    const contract = await AIXVerification.deploy();

    await contract.deployed();
    console.log("AIXVerification deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
