import { ethers } from "hardhat";

async function main() {
    const AIXSystemRegistry = await ethers.getContractFactory("AIXSystemRegistry");
    const aixSystemRegistry = await AIXSystemRegistry.deploy("0xFtsoregistryAddress", "0xFdcRegistryAddress");

    await aixSystemRegistry.deployed();
    console.log("AIXSystemRegistry deployed to:", aixSystemRegistry.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
