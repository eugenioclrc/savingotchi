const { expect } = require("chai");
const { ethers } = require("hardhat");

let savingotchi;

describe("Savingotchi", function() {
  it("Should deploy", async function() {
    const vrfCoordFactory = await ethers.getContractFactory(
      "MockVRFCoordinator"
    );

    const CHAINLINK_SUBSCRIPTION_ID = 4;

    const mockVrfCoordinator = await vrfCoordFactory.deploy();
    await mockVrfCoordinator.deployed();

    const Chaos = await ethers.getContractFactory("Chaos");
    const chaos = await Chaos.deploy(CHAINLINK_SUBSCRIPTION_ID, mockVrfCoordinator.address);
    await chaos.deployed();
    
    const Savingotchi = await ethers.getContractFactory("Savingotchi");
    savingotchi = await Savingotchi.deploy();
    await savingotchi.deployed();

    await savingotchi.setEvolver(chaos.address);

    await chaos.transferOwnership(savingotchi.address);

    /*
    expect(await savingotchi.greet()).to.equal("Hello, world!");

    const setGreetingTx = await savingotchi.setGreeting("Hola, mundo!");
    
    // wait until the transaction is mined
    await setGreetingTx.wait();

    expect(await greeter.greet()).to.equal("Hola, mundo!");
  */
  });

  it("Should buy", async function() {
    const basePrice = await savingotchi.getBuyPrice();
    expect(basePrice).to.equal(ethers.utils.parseEther("1"));
    
  })
});
