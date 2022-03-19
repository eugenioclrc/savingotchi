// We require the Hardhat Runtime Environment explicitly here. This is optional 
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  const { expect } = require("chai");
  const { ethers, network } = require("hardhat");
  
  let savingotchi;
  
      const [signer] = await ethers.getSigners();
      
  
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
  
      console.log("chaos", chaos.address);
      console.log("savingotchi", savingotchi.address);
  //      const basePrice = await savingotchi.getBuyPrice();

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
