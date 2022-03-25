const { expect } = require("chai");
const { ethers } = require("hardhat");

function bn(x) {
  return ethers.BigNumber.from(x);
}

describe("AAVEVault Unit Tests", function () {
  let deployer, alice;
  let wETHGateway, LPAPA, aMATIC;
  const referralCode = bn("0xffff");

  before(async function () {
    [deployer, alice] = await ethers.getSigners();

    // wMATIC
    const WETH = await ethers.getContractFactory("WETH");
    const weth = await WETH.deploy();

    // aMATIC
    const TestToken = await ethers.getContractFactory("TestToken");
    aMATIC = await TestToken.deploy();

    // MockWETHGateway
    const MockWETHGateway = await ethers.getContractFactory("MockWETHGateway");
    wETHGateway = await MockWETHGateway.deploy(weth.address, aMATIC.address);

    // MockLendingPoolAddresses
    const MockLPAPA = await ethers.getContractFactory("MockLPAPA");
    LPAPA = await MockLPAPA.deploy();

    await aMATIC.mint(wETHGateway.address, ethers.utils.parseEther("1000000000"));
  });

  it("Constructor", async () => {
    const Vault = await ethers.getContractFactory("Vault");
    const depositAmount = ethers.utils.parseEther("0.1");

    const vault = await Vault.deploy(
      wETHGateway.address,
      LPAPA.address,
      aMATIC.address,
      referralCode,
      { value: depositAmount }
    );

    expect(await vault.WETHGateway()).to.equal(wETHGateway.address);
    expect(await vault.wMATIC()).to.equal(await wETHGateway.getWETHAddress());
    expect(await vault.lendingPoolAddress()).to.equal(LPAPA.address);
    expect(await vault.aMATIC()).to.equal(aMATIC.address);
    expect(await aMATIC.allowance(vault.address, wETHGateway.address)).to.equal(ethers.constants.MaxUint256);
    expect(await vault.referralCode()).to.equal(referralCode);

    expect(await aMATIC.balanceOf(vault.address)).to.equal(depositAmount);
  });
});
