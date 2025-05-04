import { ethers } from "hardhat";

async function main() {
    const CPUPriceProvider = await ethers.getContractFactory("CPUPriceProvider");
    const contract = await CPUPriceProvider.deploy();

    await contract.deployed();
    console.log("CPUPriceProvider deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
