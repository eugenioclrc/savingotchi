pragma solidity ^0.8.4;

// source https://docs.chain.link/docs/get-a-random-number/
import "./IChaos.sol";
/*
  EGG,
  BOTAMON
  KOROMON
    AGUMON
      GREYMON
      TYRANOMON
      DARMKON
      MERAMON
    BETAMON
      // MERAMON
      AIRDRAMON
      SEADRAMON
      NUMEMON

      MERAMON
        METAL_GREYMON
        MAMEMON
        TEDDYMON
*/

abstract contract SavingotchiState {
  mapping(uint256 => uint256) internal gen;
  mapping(uint256 => uint256) internal lastEvolve;
  mapping(uint256 => uint256) internal tvl;
  mapping(uint256 => SavingotchiType) internal savingotchiType;

  IChaos public evolver;
//   <svg width="200" height="200"
//   xmlns="http://www.w3.org/2000/svg">
//   <image href="mdn_logo_only_color.png" height="200" width="200"/>
// </svg>
  string[] internal _stages = [
    'EGG',
    'BABY',
    'PUPPY',
    'ADOLESCENCE',// KID ?
    'ADULT'
  ];
  string[15] internal names = [
    'Egg', 'Bottamon', 'Koromon', 'Agumon', 
    'Betamon', 'Greymon', 'Tyranomon', 'Darkmon',
    'Airdramon', 'Seadramon', 'Numemon', 'Meramon',
    'Metal Greymon', 'Mamemon', 'Teddymon'
  ];

  string[15] internal images = [
    // 0
    'https://gateway.pinata.cloud/ipfs/QmTZ4MDs6LZQU1QsnHmRCrz1t1RneXbYnzTG9DuFKRZgtC/0.png',

    // 1. Bottamon  
    'https://gateway.pinata.cloud/ipfs/QmTZ4MDs6LZQU1QsnHmRCrz1t1RneXbYnzTG9DuFKRZgtC/1.botamon.png',

    // 2. koromon
    'https://gateway.pinata.cloud/ipfs/QmTZ4MDs6LZQU1QsnHmRCrz1t1RneXbYnzTG9DuFKRZgtC/2.koromon.png',

    // 3. agumon 
    'https://gateway.pinata.cloud/ipfs/QmTZ4MDs6LZQU1QsnHmRCrz1t1RneXbYnzTG9DuFKRZgtC/3.agumon.png',
    
    // 4. betamon
    'https://gateway.pinata.cloud/ipfs/QmTZ4MDs6LZQU1QsnHmRCrz1t1RneXbYnzTG9DuFKRZgtC/4.betamon.png',
    
    // 5. greyon
    'https://gateway.pinata.cloud/ipfs/QmTZ4MDs6LZQU1QsnHmRCrz1t1RneXbYnzTG9DuFKRZgtC/5.greymon.png',

    // 6. tyranomon
    'https://gateway.pinata.cloud/ipfs/QmTZ4MDs6LZQU1QsnHmRCrz1t1RneXbYnzTG9DuFKRZgtC/6.tyranomon.png',

    // 7. darkmon
    'https://gateway.pinata.cloud/ipfs/QmTZ4MDs6LZQU1QsnHmRCrz1t1RneXbYnzTG9DuFKRZgtC/7.darkmon.png',

    // 9.airdramon
    'https://gateway.pinata.cloud/ipfs/QmTZ4MDs6LZQU1QsnHmRCrz1t1RneXbYnzTG9DuFKRZgtC/9.airdramon.png',

    // 10.seadramon
    'https://gateway.pinata.cloud/ipfs/QmTZ4MDs6LZQU1QsnHmRCrz1t1RneXbYnzTG9DuFKRZgtC/10.seadramon.png',
    
    // 11.numemon
    'https://gateway.pinata.cloud/ipfs/QmTZ4MDs6LZQU1QsnHmRCrz1t1RneXbYnzTG9DuFKRZgtC/11.numemon.png',
    
    // 8. meramon
    'https://gateway.pinata.cloud/ipfs/QmTZ4MDs6LZQU1QsnHmRCrz1t1RneXbYnzTG9DuFKRZgtC/8.meramon.png',
    
    // 12.metal_greymon
    'https://gateway.pinata.cloud/ipfs/QmTZ4MDs6LZQU1QsnHmRCrz1t1RneXbYnzTG9DuFKRZgtC/13.metal_greymon.png',
    
    // 13.mamemon
    'https://gateway.pinata.cloud/ipfs/QmTZ4MDs6LZQU1QsnHmRCrz1t1RneXbYnzTG9DuFKRZgtC/14.mamemon.png',

    // 14. Teddymon
    'https://gateway.pinata.cloud/ipfs/QmTZ4MDs6LZQU1QsnHmRCrz1t1RneXbYnzTG9DuFKRZgtC/15.teddymon.png'
  ];

  enum SavingotchiStage {
    EGG,
    BABY,
    PUPPY,
    ADOLESCENCE,// KID ?
    ADULT
  }

  enum SavingotchiType {
    EGG,
    BOTAMON,
    KOROMON, // KOROMON can evolve into AGUMON, BETAMON
      AGUMON,
        GREYMON,
        TYRANOMON,
        DARMKON,
      BETAMON,
        AIRDRAMON,
        SEADRAMON,
        NUMEMON,
        MERAMON,
          METAL_GREYMON,
          MAMEMON,
          TEDDYMON
  }

  function stage(uint256 tokenId) public view returns (SavingotchiStage) {
    if (savingotchiType[tokenId] == SavingotchiType.EGG) {
      return SavingotchiStage.EGG;
    } else if (savingotchiType[tokenId] == SavingotchiType.BOTAMON) {
      return SavingotchiStage.BABY;
    } else if (savingotchiType[tokenId] == SavingotchiType.KOROMON) {
      return SavingotchiStage.PUPPY;
    } else if (savingotchiType[tokenId] == SavingotchiType.MERAMON || savingotchiType[tokenId] == SavingotchiType.BETAMON || savingotchiType[tokenId] == SavingotchiType.AGUMON) {
      return SavingotchiStage.ADOLESCENCE;
    }

    return SavingotchiStage.ADULT;
  }

  /*
  function getRandom() internal view returns (uint256) {
    return uint256(keccak256(abi.encodePacked(block.timestamp)));
  }
  */

  function evolveStep2(uint256 tokenId, uint256 rnd) external {
    require(msg.sender == address(evolver), "only chaos can evolve a savingotchi");
    if (savingotchiType[tokenId] == SavingotchiType.EGG) {
      savingotchiType[tokenId] = SavingotchiType.BOTAMON;
    } else if(savingotchiType[tokenId] == SavingotchiType.BOTAMON) {
      savingotchiType[tokenId] = SavingotchiType.KOROMON;
    } else if(savingotchiType[tokenId] == SavingotchiType.KOROMON) {
      if ((rnd % 2) == 0) {
        savingotchiType[tokenId] = SavingotchiType.AGUMON;
      } else {
        savingotchiType[tokenId] = SavingotchiType.BETAMON;
      }
    } else if(savingotchiType[tokenId] == SavingotchiType.AGUMON) {
      rnd = rnd % 4;
      if (rnd == 0) {
        savingotchiType[tokenId] = SavingotchiType.GREYMON;
      } else if (rnd == 1) {
        savingotchiType[tokenId] = SavingotchiType.TYRANOMON;
      } else if (rnd == 2) {
        savingotchiType[tokenId] = SavingotchiType.DARMKON;
      } else {
        savingotchiType[tokenId] = SavingotchiType.MERAMON;
      }
    } else if(savingotchiType[tokenId] == SavingotchiType.BETAMON) {
      rnd = rnd % 4;
      if (rnd == 0) {
        savingotchiType[tokenId] = SavingotchiType.AIRDRAMON;
      } else if (rnd == 1) {
        savingotchiType[tokenId] = SavingotchiType.SEADRAMON;
      } else if (rnd == 2) {
        savingotchiType[tokenId] = SavingotchiType.NUMEMON;
      } else {
        savingotchiType[tokenId] = SavingotchiType.MERAMON;
      }
    } else {
      rnd = rnd % 3;
      if(rnd == 0) {
        savingotchiType[tokenId] = SavingotchiType.METAL_GREYMON;
      } else if(rnd == 1) {
        savingotchiType[tokenId] = SavingotchiType.MAMEMON;
      } else {
        savingotchiType[tokenId] = SavingotchiType.TEDDYMON;
      }
    }
  }
    
  function _evolve(uint256 tokenId) internal {
    require(stage(tokenId) != SavingotchiStage.ADULT, "Cannot evolve an adult Savingotchi");
    evolver.requestRandomWords(tokenId);

    /*
    _evolveStep2(getRandom());
    */
  }
}