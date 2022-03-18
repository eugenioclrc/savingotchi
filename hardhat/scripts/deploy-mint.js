const { ethers } = require("ethers");

const NODE = "https://speedy-nodes-nyc.moralis.io/908aa8e46d6e11cc21a370c7/polygon/mumbai";
// 0xC9414fC811e95d37D68DC5227402F5648aB27948
const PK = "0x7f5105dc03b3dbdb6db46ff174defb6f0ecd37178cebb96d1c5c7f0e17c7f995";

const WETHGatewayAddress = "0xee9eE614Ad26963bEc1Bec0D2c92879ae1F209fA";
const lendingPoolAddress = "0x178113104fEcbcD7fF8669a0150721e231F0FD4B";
const aMATICAddress = "0xF45444171435d0aCB08a8af493837eF18e86EE27";

const vrfCoordinatorAddress = "0x8C7382F9D8f56b33781fE506E897a4F1e2d17255";
const LINKAddress = "0x326C977E6efc84E512bB9C30f76E30c160eD06FB";
const keyhash = "0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4";
const fee = ethers.utils.parseEther("0.1");

let provider;

async function main() {
  provider = new ethers.providers.JsonRpcProvider(NODE);
  const owner = (new ethers.Wallet(PK)).connect(provider);

  // Deploy
  const SavingotchiArt = require("../artifacts/contracts/Savingotchi.sol/Savingotchi.json");
  const Savingotchi = new ethers.ContractFactory(
    SavingotchiArt.abi,
    SavingotchiArt.bytecode,
    owner
  );
  const sav = await Savingotchi.deploy(
    WETHGatewayAddress,
    lendingPoolAddress,
    aMATICAddress,
    vrfCoordinatorAddress,
    LINKAddress,
    keyhash,
    fee
  );
  await sav.deployed();
  console.log("Deploy savingotchi at", sav.address);

  const LINK = new ethers.Contract(
    LINKAddress,
    require("../artifacts/contracts/__mocks__/TestToken.sol/TestToken.json").abi,
    owner
  );
  await LINK.transfer(sav.address, ethers.utils.parseEther("1"));

  // Mint

  const id = await sav.totalSupply();
  const buyPrice = await sav.getBuyPrice();
  await sav.mint({ value: buyPrice });
  console.log("mint:", id.toString(), ", Type:", await sav.savingotchiType(id));

  // Send to evolve

  await increaseTime(7 * 24 * 60 * 60);

  const evolvePrice = await sav.evolvePrice(id);
  console.log(evolvePrice.toString());
  await sav.sendToEvolve(id, { value: evolvePrice.mul(bn(2)) });
  console.log("sendToEvolve:", id.toString(), ", Type:", await sav.savingotchiType(id));

  let rndOnProcess = await sav.rndOnProcess(id);
  // Wait the evolve
  while (rndOnProcess) {
    console.log("Wait 5 seg...");
    await sleep(5000);
    rndOnProcess = await sav.rndOnProcess(id);
  }
  console.log("Evolved:", id.toString(), ", Type:", await sav.savingotchiType(id));
}

main();

async function increaseTime (t) {
  await provider.send("evm_increaseTime", [t]);
  await provider.send("evm_mine", []);
}

function bn(x) {
  return ethers.BigNumber.from(x);
}

async function sleep (ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
};