import { ethers } from "hardhat";

async function main() {
    const UnifiedResourcePriceOracle = await ethers.getContractFactory("UnifiedResourcePriceOracle");
    const contract = await UnifiedResourcePriceOracle.deploy("0x60BAedb47d444d431fF8B2e9Ab685ab33e4E620f");

    await contract.deployed();
    console.log("UnifiedResourcePriceOracle deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
