import { ethers } from "hardhat";

async function main() {
    const [deployer] = await ethers.getSigners();
    const ElectricityPriceProvider = await ethers.getContractFactory("ElectricityPriceProvider");
    const contract = await ElectricityPriceProvider.deploy(deployer.address);

    await contract.deployed();
    console.log("ElectricityPriceProvider deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
