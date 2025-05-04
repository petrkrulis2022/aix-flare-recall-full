import { ethers } from "hardhat";

async function main() {
    const AIXStabilityModule = await ethers.getContractFactory("AIXStabilityModule");
    const contract = await AIXStabilityModule.deploy();

    await contract.deployed();
    console.log("AIXStabilityModule deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
