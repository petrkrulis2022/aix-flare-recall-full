import { expect } from "chai";
import { ethers } from "hardhat";

describe("MockContracts", function () {
    let mockFTSORegistry: any;

    before(async function () {
        const MockFTSORegistry = await ethers.getContractFactory("MockFTSORegistry");
        mockFTSORegistry = await MockFTSORegistry.deploy();
        await mockFTSORegistry.deployed();
    });

    it("should return correct price for TAO", async function () {
        const [price, timestamp, decimals] = await mockFTSORegistry.getCurrentPrice("TAO");

        expect(price).to.equal(1500000000);
        expect(decimals).to.equal(8);
        expect(timestamp).to.be.a("number");
    });

    it("should return default price for unknown symbol", async function () {
        const [price, timestamp, decimals] = await mockFTSORegistry.getCurrentPrice("UNKNOWN");

        expect(price).to.equal(100000000);
        expect(decimals).to.equal(8);
        expect(timestamp).to.be.a("number");
    });
});
