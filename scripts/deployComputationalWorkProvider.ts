import { ethers } from "hardhat";

async function main() {
    const ComputationalWorkProvider = await ethers.getContractFactory("ComputationalWorkProvider");
    const contract = await ComputationalWorkProvider.deploy();

    await contract.deployed();
    console.log("ComputationalWorkProvider deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
