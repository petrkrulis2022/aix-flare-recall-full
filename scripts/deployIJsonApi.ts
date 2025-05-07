import { ethers } from "hardhat";

async function main() {
    const IJsonApi = await ethers.getContractFactory("our-contracts/IJsonApi.sol:IJsonApi");
    const contract = await IJsonApi.deploy();

    await contract.deployed();
    console.log("IJsonApi deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
