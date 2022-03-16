const { expect } = require("chai");
const { ethers, network } = require("hardhat");

let savingotchi;

describe("Savingotchi", function() {
  it("Should deploy", async function() {
    // await network.provider.request({
    //   method: "hardhat_reset",
    //   params: [
    //     {
    //       forking: {
    //         jsonRpcUrl: "https://speedy-nodes-nyc.moralis.io/APIKEY/polygon/mumbai",
    //         blockNumber: 25542728,
    //       },
    //     },
    //   ],
    // });
    const [signer] = await ethers.getSigners();

    // const vrfCoordFactory = await ethers.getContractFactory(
    //   "MockVRFCoordinator"
    // );

    // const CHAINLINK_SUBSCRIPTION_ID = 4;

    // const mockVrfCoordinator = await vrfCoordFactory.deploy();
    // await mockVrfCoordinator.deployed();

    // const Chaos = await ethers.getContractFactory("ChaosV2");
    // const chaos = await Chaos.deploy(CHAINLINK_SUBSCRIPTION_ID, mockVrfCoordinator.address);
    // await chaos.deployed();
    

    const Chaos = await ethers.getContractFactory("Chaos");
    const chaos = await Chaos.deploy();
    await chaos.deployed();

    const Savingotchi = await ethers.getContractFactory("Savingotchi");
    savingotchi = await Savingotchi.deploy();
    await savingotchi.deployed();

    await savingotchi.setEvolver(chaos.address);

    await chaos.transferOwnership(savingotchi.address);

    const TOKEN_ABI = [
      'function transfer(address to, uint amount)',
    ];
    const tokenLink = new ethers.Contract('0x326C977E6efc84E512bB9C30f76E30c160eD06FB', TOKEN_ABI);

    // fund chaos with link;
    await tokenLink.connect(signer).transfer(chaos.address, ethers.utils.parseEther('1'));



  });

  it("Should buy", async function() {
    const basePrice = await savingotchi.getBuyPrice();
    expect(basePrice).to.equal(ethers.utils.parseEther("1"));
    await savingotchi.mint({ value: ethers.utils.parseEther("1") });
  })
});
