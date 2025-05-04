import { expect } from "chai";
import { ethers } from "hardhat";

describe("ElectricityPriceProvider", function () {
    it("Should update and retrieve electricity price", async function () {
        const [owner] = await ethers.getSigners();
        const ElectricityPriceProvider = await ethers.getContractFactory("ElectricityPriceProvider");
        const electricityPriceProvider = await ElectricityPriceProvider.deploy(owner.address);
        await electricityPriceProvider.deployed();

        const newPrice = 100;
        await electricityPriceProvider.updateElectricityPrice(newPrice);
        const retrievedPrice = await electricityPriceProvider.getElectricityPrice();

        expect(retrievedPrice).to.equal(newPrice);
    });
});
