// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');
  const charity = "0xBF56DB380F397609f40a8BbDEF84BD431E78844B";
  const starify = "0x08d0872b989B79394bBf58Bb5BA51051DC30e682";
  //const signer = "0xAE492E3873945F9af9B6caD802e030e2935073cE";

  // We get the contract to deploy
  const MinterContract = await hre.ethers.getContractFactory("MinterContract");
  const minterContract = await MinterContract.deploy(charity, starify);

  await minterContract.deployed();

  console.log("MinterContract deployed to:", minterContract.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
