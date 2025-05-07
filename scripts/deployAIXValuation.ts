import { ethers } from "hardhat";

async function main() {
    const AIXValuation = await ethers.getContractFactory("AIXValuation");
    const contract = await AIXValuation.deploy("0x60BAedb47d444d431fF8B2e9Ab685ab33e4E620f");

    await contract.deployed();
    console.log("AIXValuation deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
