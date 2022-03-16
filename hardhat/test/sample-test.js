const { expect } = require("chai");

describe("Greeter", function() {
  it("Should return the new greeting once it's changed", async function() {
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
    const savingotchi = await Savingotchi.deploy();
    await savingotchi.deployed();

    await savingotchi.setEvolver(chaos.address);
/*
    expect(await savingotchi.greet()).to.equal("Hello, world!");

    const setGreetingTx = await savingotchi.setGreeting("Hola, mundo!");
    
    // wait until the transaction is mined
    await setGreetingTx.wait();

    expect(await greeter.greet()).to.equal("Hola, mundo!");
  */
  });
});
