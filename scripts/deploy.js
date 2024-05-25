const { ethers, run, network } = require("hardhat");

async function main() {
  const PeerToPlayConnector = await ethers.getContractFactory("Cricket");
  console.log("Deploying contract...");
  const peerToPlayConnector = await PeerToPlayConnector.deploy();
  const peerToPlayConnectoraddress = await peerToPlayConnector.getAddress();
  console.log(`Deployed contract to : ${peerToPlayConnectoraddress}`);

  if (network.config.chainId === 11155111 && process.env.ETHERSCAN_API) {
    await peerToPlayConnector.deploymentTransaction(6);
    await customVerify(peerToPlayConnectoraddress, []);
  }
}

async function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function customVerify(peerToPlayConnectoraddress, args) {
  console.log("Verifying...");
  await sleep(120 * 1000);
  try {
    await run("verify:verify", {
      address: peerToPlayConnectoraddress,
      constructorArguments: args,
    });
  } catch (e) {
    if (e.message.toLowerCase().includes("already verified")) {
      console.log("Already verified");
    } else {
      console.log(e);
    }
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
