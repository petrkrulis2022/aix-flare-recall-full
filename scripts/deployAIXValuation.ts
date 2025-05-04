import { ethers } from "hardhat";

async function main() {
    const AIXValuation = await ethers.getContractFactory("AIXValuation");
    const contract = await AIXValuation.deploy();

    await contract.deployed();
    console.log("AIXValuation deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
