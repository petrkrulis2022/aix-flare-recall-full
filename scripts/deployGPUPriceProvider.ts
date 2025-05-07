import { ethers } from "hardhat";

async function main() {
    const GPUPriceProvider = await ethers.getContractFactory("GPUPriceProvider");
    const contract = await GPUPriceProvider.deploy("0x6ef27E391c7eac228c26300aA92187382cc7fF8a");

    await contract.deployed();
    console.log("GPUPriceProvider deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
