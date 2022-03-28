const { expect } = require("chai");
const { ethers } = require("hardhat");

function bn(x) {
  return ethers.BigNumber.from(x);
}

async function increaseTime (t) {
  await ethers.provider.send("evm_increaseTime", [t]);
  await ethers.provider.send("evm_mine", []);
}

describe("Savingotchi Unit Tests", function () {
  let deployer, alice;
  let sav, LINK, weth, router;
  const fee = ethers.utils.parseEther("0.1");
  const basePrice = ethers.utils.parseEther("1");
  const referralCode = "0xffff";

  const EGG = 0;
  const BABY = 1;
  const PUPPY = 2;
  const ADOLESCENCE = 3;
  const ADULT = 4;

  async function getId(tx) {
    const logs = (await ethers.provider.getTransactionReceipt(tx.hash)).logs;
    const transferHash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("Transfer(address,address,uint256)"));
    const mintLog = logs.find(l =>
      l.address == sav.address &&
      l.topics[0] == transferHash &&
      l.topics[1] == ethers.constants.HashZero
    );
    return bn(mintLog.topics[3]);
  }

  before(async function () {
    [deployer, alice] = await ethers.getSigners();

    // Chaos
    const MockVRFCoordinator = await ethers.getContractFactory("MockVRFCoordinator");
    const vrfCoordinator = await MockVRFCoordinator.deploy();

    // LINK
    const TestToken = await ethers.getContractFactory("TestToken");
    LINK = await TestToken.deploy();

    // aMATIC
    const aMATIC = await TestToken.deploy();

    // wMATIC
    const WETH = await ethers.getContractFactory("WETH");
    weth = await WETH.deploy();

    // MockWETHGateway
    const MockWETHGateway = await ethers.getContractFactory("MockWETHGateway");
    const wETHGateway = await MockWETHGateway.deploy(weth.address, aMATIC.address);
    await aMATIC.mint(wETHGateway.address, ethers.utils.parseEther("1000000000"));

    // MockLendingPoolAddressesProviderAddress
    const MockLPAPA = await ethers.getContractFactory("MockLPAPA");
    const LPAPA = await MockLPAPA.deploy();

    // Uniswap
    const UniswapV2Factory = await ethers.getContractFactory("UniswapV2Factory");
    const factory = await UniswapV2Factory.deploy(deployer.address);

    const UniswapV2Router02 = await ethers.getContractFactory("UniswapV2Router02");
    router = await UniswapV2Router02.deploy(factory.address, weth.address);

    // Add liquidity
    const linkAmount = ethers.utils.parseEther("1000000000");
    const ethAmount = ethers.utils.parseEther("10");
    await LINK.mint(deployer.address, linkAmount);
    await LINK.approve(router.address, linkAmount);

    await router.addLiquidityETH(
      LINK.address,
      linkAmount,
      1,
      1,
      deployer.address,
      ethers.constants.MaxUint256,
      { value: ethAmount }
    );

    // Savingotchi
    const MockSavingotchi = await ethers.getContractFactory("MockSavingotchi");
    sav = await MockSavingotchi.deploy(
      basePrice,
      router.address,
      wETHGateway.address,
      LPAPA.address,
      aMATIC.address,
      referralCode,
      vrfCoordinator.address,
      LINK.address,
      ethers.constants.HashZero, // keyhash
      fee,
    );
  });

  describe.skip("Function withdrawLink", function () {
    it.skip("Withdraw link", async () => {
      //TODO
      await LINK.mint(deployer.address, linkAmount);

      await cookieToken.withdrawLink();

      expect(await cookieToken.balanceOf(alice.address)).to.equal(
        initialSupply
      );
    });

    it("Try withdraw link without ownership(onlyOwner)", async () => {
      await expect(
        sav.connect(alice).withdrawLink()
      ).to.be.revertedWith("Ownable: caller is not the owner");
    });
  });

  describe.only("Function mint", function () {
    it("Mint a savingotchi", async () => {
      const prevTotalSupply = await sav.totalSupply();
      const prevBIPrice = await sav.baseIncreasePrice();
      const buyPrice = await sav.getBuyPrice();
      const spendOnLink = (await router.getAmountsIn(
        await sav.MAX_LINK_SPEND(),
        [weth.address, LINK.address]
      )) [0];

      const tx = await sav.connect(alice).mint({ value: buyPrice });

      const txTimestamp = (await ethers.provider.getBlock(tx.blockNumber)).timestamp;
      const id = await getId(tx);
      const Vault = await ethers.getContractFactory("Vault");
      const vault = await Vault.attach(await sav.vaultAddress(id));

      expect(await LINK.balanceOf(sav.address)).to.equal(await sav.MAX_LINK_SPEND());
      expect(await vault.aMATICbalance()).to.equal(buyPrice.sub(spendOnLink));

      expect(await sav.baseIncreasePrice()).to.equal(prevBIPrice.add(bn(1)));
      expect(await sav.lastBuy()).to.equal(txTimestamp);
      expect(await sav.lastEvolve(id)).to.equal(txTimestamp);
      expect(await sav.savingotchiType(id)).to.equal(EGG);
      expect(await sav.totalSupply()).to.equal(prevTotalSupply.add(bn(1)));
      expect(await sav.ownerOf(id)).to.equal(alice.address);
    });

    it("Mint a savingotchi with more value", async () => {
      const buyPrice = await sav.getBuyPrice();
      const surplus = bn("1000000001651651");

      const prevBal = await ethers.provider.getBalance(deployer.address);

      const tx = await sav.mint({ value: buyPrice.add(surplus) });

      const receipt = await ethers.provider.getTransactionReceipt(tx.hash);

      expect(await ethers.provider.getBalance(deployer.address)).to.equal(
        prevBal.sub(buyPrice).sub(tx.gasPrice.mul(receipt.cumulativeGasUsed))
      );
    });

    it("Check baseIncreasePrice", async () => {
      // reset the lastBuy
      await sav.mint({ value: await sav.getBuyPrice() });
      // increment the baseIncreasePrice
      await sav.mint({ value: await sav.getBuyPrice() });
      await sav.mint({ value: await sav.getBuyPrice() });
      await sav.mint({ value: await sav.getBuyPrice() });

      const prevBIPrice = await sav.baseIncreasePrice();

      await increaseTime(60 * 60 * 24); // 1 Day
      await sav.mint({ value: await sav.getBuyPrice() });

      expect(await sav.baseIncreasePrice()).to.equal(prevBIPrice.sub(bn(1)));

      await increaseTime(60 * 60 * 24 * 30); // 30 Days
      await sav.mint({ value: await sav.getBuyPrice() });

      expect(await sav.baseIncreasePrice()).to.equal(0);
    });

    it("Check baseIncreasePrice", async () => {
      const prevTotalSupply = await sav.totalSupply();
      await sav.setTotalSupply(bn(10000));

      await expect(
        sav.mint({ value: await sav.getBuyPrice() })
      ).to.be.revertedWith('Too many Savingotchis');

      await sav.setTotalSupply(prevTotalSupply);
    });
  });
});
