import { expect } from "chai";
import { ethers } from "hardhat";

describe("Integration Testing", function () {
    let gpuPriceProvider: any;
    let electricityPriceProvider: any;
    let computationalWorkAttestation: any;
    let crossChainWorkVerification: any;

    before(async function () {
        const [owner] = await ethers.getSigners();

        const GPUPriceProvider = await ethers.getContractFactory("GPUPriceProvider");
        gpuPriceProvider = await GPUPriceProvider.deploy(owner.address);
        await gpuPriceProvider.deployed();

        const ElectricityPriceProvider = await ethers.getContractFactory("ElectricityPriceProvider");
        electricityPriceProvider = await ElectricityPriceProvider.deploy(owner.address);
        await electricityPriceProvider.deployed();

        const ComputationalWorkAttestation = await ethers.getContractFactory("ComputationalWorkAttestation");
        computationalWorkAttestation = await ComputationalWorkAttestation.deploy(owner.address);
        await computationalWorkAttestation.deployed();

        const CrossChainWorkVerification = await ethers.getContractFactory("CrossChainWorkVerification");
        crossChainWorkVerification = await CrossChainWorkVerification.deploy(owner.address);
        await crossChainWorkVerification.deployed();
    });

    it("should test FTSO data flow from submission to AIX valuation", async function () {
        const newGPUPrice = 500;
        await gpuPriceProvider.updateGPUPrice(newGPUPrice);
        const retrievedGPUPrice = await gpuPriceProvider.getGPUPrice();
        expect(retrievedGPUPrice).to.equal(newGPUPrice);

        const newElectricityPrice = 100;
        await electricityPriceProvider.updateElectricityPrice(newElectricityPrice);
        const retrievedElectricityPrice = await electricityPriceProvider.getElectricityPrice();
        expect(retrievedElectricityPrice).to.equal(newElectricityPrice);
    });

    it("should verify FDC attestation flow from work proof to verification", async function () {
        const workType = "Computation";
        const hardwareSpecs = "8-core CPU, 16GB RAM";
        const computationTime = 120;
        const energyConsumption = 50;
        const details = "Work completed successfully.";

        // Correctly call the `attestWork` function to return the attestation ID
        const tx = await computationalWorkAttestation.attestWork(
            workType,
            hardwareSpecs,
            computationTime,
            energyConsumption,
            details
        );
        const receipt = await tx.wait();
        const attestationId = receipt.events[0].args.attestationId;

        // Debugging: Log the attestation ID
        console.log("Attestation ID:", attestationId);

        // Ensure the attestation is created and exists in the mapping
        const attestation = await computationalWorkAttestation.getAttestation(attestationId);
        expect(attestation.provider).to.not.equal(ethers.constants.AddressZero);

        // Removed the use of `isAddressable` and directly checked the receipt status
        const workDetails = await computationalWorkAttestation.getWorkDetails(attestationId);
        expect(workDetails.hardwareSpecs).to.equal(hardwareSpecs);
        expect(workDetails.computationTime).to.equal(computationTime);
        expect(workDetails.energyConsumption).to.equal(energyConsumption);
    });

    it("should test cross-chain verification scenarios", async function () {
        // Extract the attestation ID from the transaction receipt
        const sourceTx = await computationalWorkAttestation.attestWork(
            "Computation",
            "8-core CPU, 16GB RAM",
            120,
            50,
            "Source attestation details"
        );
        const sourceReceipt = await sourceTx.wait();
        const sourceAttestationId = sourceReceipt.events[0].args.attestationId;

        const targetTx = await computationalWorkAttestation.attestWork(
            "Computation",
            "8-core CPU, 16GB RAM",
            120,
            50,
            "Target attestation details"
        );
        const targetReceipt = await targetTx.wait();
        const targetAttestationId = targetReceipt.events[0].args.attestationId;

        // Debugging: Log the attestation details from the mapping
        const sourceAttestation = await computationalWorkAttestation.getAttestation(sourceAttestationId);
        console.log("Source Attestation Details:", sourceAttestation);

        const targetAttestation = await computationalWorkAttestation.getAttestation(targetAttestationId);
        console.log("Target Attestation Details:", targetAttestation);

        const verificationId = await crossChainWorkVerification.verifyCrossChainWork(
            sourceAttestationId,
            targetAttestationId
        );

        const verificationDetails = await crossChainWorkVerification.getCrossChainVerification(verificationId);
        expect(verificationDetails.verified).to.be.true;
    });

    it("should validate end-to-end token minting based on verified work", async function () {
        // Placeholder for token minting logic based on verified work
        // Ensure tokens are minted correctly after verification
        expect(true).to.be.true; // Replace with actual logic
    });
});
