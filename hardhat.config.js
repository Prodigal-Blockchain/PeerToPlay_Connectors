require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("hardhat-gas-reporter");
require("solidity-coverage");

const url = process.env.RPC_URL;
const wallet = process.env.PRIVATE_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    sepolia: {
      url: url,
      accounts: [wallet],
      chainId: 11155111,
      maxFeePerGas: 100000000,
    },
    localhost: {
      url: "http://127.0.0.1:8545/",
      chainId: 31337,
    },
  },
  solidity: {
    compilers: [
      {
        version: "0.8.20",
        settings: {
          optimizer: { enabled: true },
        },
      },

      {
        version: "0.7.6",
        settings: {
          optimizer: { enabled: true },
        },
      },
      {
        version: "0.8.20",
        settings: {
          optimizer: { enabled: true },
        },
      },
      {
        version: "0.8.0",
        settings: {
          optimizer: { enabled: true },
        },
      },
    ],
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API,
  },
};
