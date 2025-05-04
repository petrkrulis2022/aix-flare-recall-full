import * as fs from "fs";
import * as path from "path";

// Function to estimate CPU/GPU usage based on chain of thought complexity
function estimateResourceUsage(logContent: string): { cpuUsage: number; gpuUsage: number } {
    // Count tokens as a simple metric for computational complexity
    const tokenCount = logContent.split(/\s+/).length;

    // Simple heuristic: longer reasoning chains use more resources
    // This is a simplified model - in a real system, you'd use more sophisticated metrics
    const cpuUsage = Math.min(100, tokenCount * 0.5); // 0.5 CPU units per token, max 100
    const gpuUsage = Math.min(100, tokenCount * 0.3); // 0.3 GPU units per token, max 100

    return { cpuUsage, gpuUsage };
}

// Convert JSONL to JSON with resource estimates
function convertJsonlToJson(inputPath: string, outputPath: string): void {
    const jsonlContent = fs.readFileSync(inputPath, "utf8");
    const lines = jsonlContent.trim().split("\n");

    const jsonEntries = lines.map(line => {
        const entry = JSON.parse(line);
        const { cpuUsage, gpuUsage } = estimateResourceUsage(entry.log);

        // Add CPU and GPU usage fields
        return {
            ...entry,
            CPU: cpuUsage.toFixed(2),
            GPU: gpuUsage.toFixed(2),
        };
    });

    // Write to JSON file
    fs.writeFileSync(outputPath, JSON.stringify(jsonEntries, null, 2));
    console.log(`Converted ${inputPath} to ${outputPath} with resource estimates`);
}

// Example usage
const inputFile = process.argv[2];
if (!inputFile) {
    console.error("Please provide the input JSONL file path as an argument.");
    process.exit(1);
}
const outputFile = inputFile.replace(".jsonl", ".json");
convertJsonlToJson(inputFile, outputFile);
