require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const { PRIVATE_KEY, ALCHEMY_API_URL } = process.env;

module.exports = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: ALCHEMY_API_URL || "",
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [],
    },
  },
  etherscan: {
    apiKey: "your_etherscan_api_key_if_needed",
  },
};
