import { ethers } from "hardhat";

async function main() {
    const JsonApi = await ethers.getContractFactory("our-contracts/JsonApi.sol:JsonApi");
    const contract = await JsonApi.deploy();

    await contract.deployed();
    console.log("JsonApi deployed to:", contract.address);
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
