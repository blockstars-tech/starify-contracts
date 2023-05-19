// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const { ethers, upgrades } = hre;
const { getImplementationAddress } = require("@openzeppelin/upgrades-core");

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));



const verifyContract = async (
  contractAddress,
  constructorArguments,
) => {
  try {
    const tx = await hre.run("verify:verify", {
      address: contractAddress,
      constructorArguments,
    });
    console.log(tx);

    await sleep(16000);
  } catch (error) {
    console.log("error is ->");
    console.log(error);
    console.log("cannot verify contract", contractAddress);
    await sleep(16000);
  }
  console.log("contract", contractAddress, "verified successfully");
};

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // const charity = "0x1442C8571274c7b75b698E9B69bf90453211aEd9";
  // const minter = "0xeAB9DDcD948292288cAb5373F83F8350958ccc2a";

  // We get the contract to deploy
  const Starify = await ethers.getContractFactory("Starify");
  const starify = await upgrades.deployProxy(Starify, [1000, 1000]);

  await starify.deployed();

  const starifyImpl = await getImplementationAddress(ethers.provider, starify.address);
  await verifyContract(starifyImpl, []);


  console.log("Starify deployed to:", starify.address);
  console.log("StarifyImpl deployed to:", starifyImpl);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
