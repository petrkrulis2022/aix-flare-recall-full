import { ethers } from "hardhat";

async function main() {
    const AIXGovernance = await ethers.getContractFactory("AIXGovernance");
    const contract = await AIXGovernance.deploy();

    await contract.deployed();
    console.log("AIXGovernance deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
