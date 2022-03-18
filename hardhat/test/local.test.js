const { expect } = require("chai");
const { ethers } = require("hardhat");

async function increaseTime (t) {
  await ethers.provider.send("evm_increaseTime", [t]);
  await ethers.provider.send("evm_mine", []);
}

let savingotchi, LINK;
let deployer;
const keyhash = "0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4"
const fee = ethers.utils.parseEther("0.1")

describe("Savingotchi", function() {
  it("Should deploy", async function() {
    [deployer] = await ethers.getSigners();

    // Chaos
    const MockVRFCoordinator = await ethers.getContractFactory("MockVRFCoordinator");
    const vrfCoordinator = await MockVRFCoordinator.deploy();
    await vrfCoordinator.deployed();

    // LINK
    const TestToken = await ethers.getContractFactory("TestToken");
    LINK = await TestToken.deploy();
    await LINK.deployed();

    // aMATIC
    const aMATIC = await TestToken.deploy();
    await aMATIC.deployed();

    // wMATIC
    const WETH = await ethers.getContractFactory("WETH");
    const weth = await WETH.deploy();
    await weth.deployed();

    // MockWETHGateway
    const MockWETHGateway = await ethers.getContractFactory("MockWETHGateway");
    const wETHGateway = await MockWETHGateway.deploy(weth.address);
    await wETHGateway.deployed();

    // MockLendingPoolAddressesProviderAddress
    const MockLPAPA = await ethers.getContractFactory("MockLPAPA");
    const LPAPA = await MockLPAPA.deploy();
    await LPAPA.deployed();

    // Savingotchi
    const Savingotchi = await ethers.getContractFactory("Savingotchi");
    savingotchi = await Savingotchi.deploy(
      wETHGateway.address,
      LPAPA.address,
      aMATIC.address,
      vrfCoordinator.address,
      LINK.address,
      keyhash,
      fee
    );
    await savingotchi.deployed();
  });

  it("Should buy", async function() {
    await LINK.mint(savingotchi.address, ethers.utils.parseEther("10"));

    const basePrice = await savingotchi.getBuyPrice();
    expect(basePrice).to.equal(ethers.utils.parseEther("1"));

    const id = await savingotchi.totalSupply();
    await savingotchi.mint({ value: ethers.utils.parseEther("1") });

    await increaseTime(7 * 24 * 60 * 60);

    await savingotchi.sendToEvolve(
      id,
      { value: await savingotchi.evolvePrice(id) },
    );
  })
});
