const hre = require("hardhat");

async function main() {
  const VaultSpire = await hre.ethers.getContractFactory("VaultSpire");
  const vaultSpire = await VaultSpire.deploy();
  await vaultSpire.deployed();

  console.log(`✅ VaultSpire deployed successfully at: ${vaultSpire.address}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });
