import { expect } from "chai";
import { ethers } from "hardhat";

describe("GPUPriceProvider", function () {
    it("Should update and retrieve GPU price", async function () {
        const [owner] = await ethers.getSigners();
        const GPUPriceProvider = await ethers.getContractFactory("GPUPriceProvider");
        const gpuPriceProvider = await GPUPriceProvider.deploy(owner.address);
        await gpuPriceProvider.deployed();

        const newPrice = 500;
        await gpuPriceProvider.updateGPUPrice(newPrice);
        const retrievedPrice = await gpuPriceProvider.getGPUPrice();

        expect(retrievedPrice).to.equal(newPrice);
    });
});
