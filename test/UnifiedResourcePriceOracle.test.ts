import { expect } from "chai";
import { ethers } from "hardhat";

describe("UnifiedResourcePriceOracle", function () {
    let priceOracle: any;

    before(async function () {
        const UnifiedResourcePriceOracle = await ethers.getContractFactory("UnifiedResourcePriceOracle");
        priceOracle = await UnifiedResourcePriceOracle.deploy("0xMockFTSORegistryAddress");
        await priceOracle.deployed();
    });

    it("should return correct resource costs for AWS", async function () {
        const cpuUsage = 100;
        const gpuUsage = 50;

        const [totalCost, cpuCost, gpuCost] = await priceOracle.getResourceCost("AWS", cpuUsage, gpuUsage);

        expect(totalCost).to.be.a("number");
        expect(cpuCost).to.be.a("number");
        expect(gpuCost).to.be.a("number");
    });

    it("should return correct resource costs for Render", async function () {
        const cpuUsage = 200;
        const gpuUsage = 100;

        const [totalCost, cpuCost, gpuCost] = await priceOracle.getResourceCost("Render", cpuUsage, gpuUsage);

        expect(totalCost).to.be.a("number");
        expect(cpuCost).to.be.a("number");
        expect(gpuCost).to.be.a("number");
    });
});
