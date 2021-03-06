require("dotenv").config();
require("@nomiclabs/hardhat-waffle");
require('hardhat-contract-sizer');
require('hardhat-abi-exporter');


// npx hardhart node --fork https://speedy-nodes-nyc.moralis.io/APIKEY/polygon/mumbai


// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  networks: {
    localhost: {
      accounts: process.env.MUMBAI_KEY ? [process.env.MUMBAI_KEY] : undefined
  },
},
solidity: {
  compilers: [
  {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  }
  ]}
};

