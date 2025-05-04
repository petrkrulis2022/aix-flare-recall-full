import { ethers } from "hardhat";

async function main() {
    const ContractFactory = await ethers.getContractFactory("UnifiedResourcePriceOracle");
    const contract = await ContractFactory.deploy("0xYourFTSORegistryAddress");

    await contract.deployed();

    console.log("UnifiedResourcePriceOracle deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
