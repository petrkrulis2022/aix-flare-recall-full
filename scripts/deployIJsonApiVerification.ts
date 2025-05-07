import { ethers } from "hardhat";

async function main() {
    const IJsonApiVerification = await ethers.getContractFactory("our-contracts/IJsonApiVerification.sol:IJsonApiVerification");
    const contract = await IJsonApiVerification.deploy();

    await contract.deployed();
    console.log("IJsonApiVerification deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
