import { ethers } from "hardhat";

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    const AIXSystemRegistry = await ethers.getContractFactory("AIXSystemRegistry");
    const registry = await AIXSystemRegistry.deploy();
    await registry.deployed();

    console.log("AIXSystemRegistry deployed to:", registry.address);

    const AIXToken = await ethers.getContractFactory("AIXToken");
    const aixToken = await AIXToken.deploy(registry.address);
    await aixToken.deployed();

    console.log("AIXToken deployed to:", aixToken.address);

    // Example setup: Add an authorized minter
    const minterAddress = deployer.address; // Replace with actual minter address if needed
    await aixToken.addMinter(minterAddress);
    console.log("Added authorized minter:", minterAddress);

    // Example setup: Update resource pricing
    const newCpuPrice = ethers.utils.parseUnits("0.01", "ether"); // 0.01 AIX per CPU unit
    const newGpuPrice = ethers.utils.parseUnits("0.05", "ether"); // 0.05 AIX per GPU unit
    await aixToken.updateResourcePricing(newCpuPrice, newGpuPrice);
    console.log("Updated resource pricing: CPU =", newCpuPrice.toString(), "GPU =", newGpuPrice.toString());
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
