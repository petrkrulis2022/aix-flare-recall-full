import { ethers } from "hardhat";

async function main() {
    const GPUPriceProvider = await ethers.getContractFactory("GPUPriceProvider");
    const contract = await GPUPriceProvider.deploy();

    await contract.deployed();
    console.log("GPUPriceProvider deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
