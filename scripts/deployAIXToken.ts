import { ethers } from "hardhat";

async function main() {
    const AIXToken = await ethers.getContractFactory("AIXToken");
    const aixToken = await AIXToken.deploy("0xRegistryAddress");

    await aixToken.deployed();
    console.log("AIXToken deployed to:", aixToken.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
