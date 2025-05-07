import { ethers, network } from "hardhat";

async function main() {
    if (network.name !== "coston2") {
        throw new Error("This script can only be run on the coston2 network.");
    }

    const contracts = [
        { name: "AIXGovernance", args: [] },
        { name: "AIXStabilityModule", args: [] },
        { name: "AIXSystemRegistry", args: [] },
        { name: "AIXToken", args: [] },
        { name: "AIXTokenWithFDC", args: [] },
        { name: "AIXValuation", args: [] },
        { name: "AIXVerification", args: [] },
        { name: "AttestationProvider", args: [] },
        { name: "ComputationalWorkAttestation", args: ["0xYourAddressHere"] }, // Example address
        { name: "ComputationalWorkProvider", args: ["0xProviderAddress"] }, // Replace with actual address
        { name: "CPUPriceProvider", args: [] },
        { name: "CrossChainWorkVerification", args: [] },
        { name: "ElectricityPriceProvider", args: [] },
        { name: "GPUPriceProvider", args: ["0xPriceProviderAddress"] }, // Replace with actual address
        { name: "GuessingGame", args: [] },
        { name: "IJsonApi", args: [], fullyQualifiedName: "contracts/JsonApi.sol:IJsonApi" },
        {
            name: "IJsonApiVerification",
            args: [],
            fullyQualifiedName: "contracts/IJsonApiVerification.sol:IJsonApiVerification",
        },
        { name: "JsonApi", args: [] },
        { name: "MockContracts", args: [] },
        { name: "MockIFDCRegistry", args: [] },
        { name: "PriceAnalytics", args: [] },
        { name: "SimpleFtsoExample", args: [] },
        { name: "UnifiedResourcePriceOracle", args: ["0xOracleAddress"] }, // Replace with actual address
    ];

    for (const { name, args, fullyQualifiedName } of contracts) {
        try {
            const ContractFactory = fullyQualifiedName
                ? await ethers.getContractFactory(fullyQualifiedName)
                : await ethers.getContractFactory(name);
            const contract = await ContractFactory.deploy(...args);

            await contract.deployed();

            console.log(`${name} deployed to:`, contract.address);
        } catch (error) {
            console.error(`Failed to deploy ${name}:`, error);
        }
    }
}

main().catch(error => {
    console.error(error);
    process.exitCode = 1;
});
