import { ethers } from "hardhat";

async function main() {
    const ContractFactory = await ethers.getContractFactory("MockContracts");
    const contract = await ContractFactory.deploy();

    await contract.deployed();

    console.log("MockContracts deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
