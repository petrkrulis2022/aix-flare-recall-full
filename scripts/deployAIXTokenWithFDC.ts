import { ethers } from "hardhat";

async function main() {
    const AIXTokenWithFDC = await ethers.getContractFactory("AIXTokenWithFDC");
    const contract = await AIXTokenWithFDC.deploy();

    await contract.deployed();
    console.log("AIXTokenWithFDC deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
