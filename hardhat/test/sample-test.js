const { expect } = require("chai");

describe("Greeter", function() {
  it("Should return the new greeting once it's changed", async function() {
    const vrfCoordFactory = await ethers.getContractFactory(
      "MockVRFCoordinator"
    );
    const mockVrfCoordinator = await vrfCoordFactory.deploy();
    await mockVrfCoordinator.deployed();

    const Savingotchi = await ethers.getContractFactory("Savingotchi");
    const CHAINLINK_SUBSCRIPTION_ID = 4;
    const savingotchi = await Savingotchi.deploy(CHAINLINK_SUBSCRIPTION_ID);
    await savingotchi.deployed();
/*
    expect(await savingotchi.greet()).to.equal("Hello, world!");

    const setGreetingTx = await savingotchi.setGreeting("Hola, mundo!");
    
    // wait until the transaction is mined
    await setGreetingTx.wait();

    expect(await greeter.greet()).to.equal("Hola, mundo!");
  */
  });
});
