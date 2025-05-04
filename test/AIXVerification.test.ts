import { expect } from "chai";
import { ethers } from "hardhat";

describe("AIXVerification", function () {
    let aixVerification: any;
    let mockFDCRegistry: any;
    let signerAddress: string;

    before(async function () {
        const [signer] = await ethers.getSigners();
        signerAddress = await signer.getAddress();

        const MockFDCRegistry = await ethers.getContractFactory("MockFDCClient");
        mockFDCRegistry = await MockFDCRegistry.deploy();
        await mockFDCRegistry.deployed();

        const AIXVerification = await ethers.getContractFactory("AIXVerification");
        aixVerification = await AIXVerification.deploy(mockFDCRegistry.address);
        await aixVerification.deployed();
    });

    it("should submit a task and emit TaskSubmitted event", async function () {
        const taskId = ethers.utils.formatBytes32String("task1");
        const workProof = ethers.utils.toUtf8Bytes("proof");

        await expect(aixVerification.submitTask(taskId, workProof))
            .to.emit(aixVerification, "TaskSubmitted")
            .withArgs(taskId, signerAddress);
    });

    it("should verify a task and emit TaskVerified event", async function () {
        const taskId = ethers.utils.formatBytes32String("task1");
        const workProof = ethers.utils.toUtf8Bytes("proof");

        await aixVerification.submitTask(taskId, workProof);
        await expect(aixVerification.verifyTask(taskId))
            .to.emit(aixVerification, "TaskVerified")
            .withArgs(taskId, true);
    });

    it("should pay for a verified task and emit TaskPaid event", async function () {
        const taskId = ethers.utils.formatBytes32String("task1");
        const workProof = ethers.utils.toUtf8Bytes("proof");

        await aixVerification.submitTask(taskId, workProof);
        await aixVerification.verifyTask(taskId);
        await expect(aixVerification.payForTask(taskId))
            .to.emit(aixVerification, "TaskPaid")
            .withArgs(taskId, signerAddress, 100);
    });
});
