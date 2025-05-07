import { ethers } from "hardhat";

async function main() {
    const AIXGovernance = await ethers.getContractFactory("AIXGovernance");
    const contract = await AIXGovernance.deploy("0xa02936109757a36705CC156aBf23eC2E47A7b76d");

    await contract.deployed();
    console.log("AIXGovernance deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
