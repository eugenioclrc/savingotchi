pragma solidity ^0.8.4;

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
  mapping(uint256 => uint256) internal lastEvolve;
  mapping(uint256 => SavingotchiType) internal savingotchiType;

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
        // MERAMON,
      BETAMON,
        // MERAMON
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

  function _evolve(uint256 tokenId) internal {
    require(stage(tokenId) != SavingotchiStage.ADULT, "Cannot evolve an adult Savingotchi");
    uint256 rnd;
    if (savingotchiType[tokenId] == SavingotchiType.EGG) {
      savingotchiType[tokenId] = SavingotchiType.BOTAMON;
    } else if(savingotchiType[tokenId] == SavingotchiType.BOTAMON) {
      savingotchiType[tokenId] = SavingotchiType.KOROMON;
    } else if(savingotchiType[tokenId] == SavingotchiType.KOROMON) {
      rnd = _getRandom();
      if ((rnd % 2) == 0) {
        savingotchiType[tokenId] = SavingotchiType.AGUMON;
      } else {
        savingotchiType[tokenId] = SavingotchiType.BETAMON;
      }
    } else if(savingotchiType[tokenId] == SavingotchiType.AGUMON) {
      rnd = _getRandom() % 4;
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
      rnd = _getRandom() % 4;
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
      rnd = _getRandom() % 3;
      if(rnd == 0) {
        savingotchiType[tokenId] = SavingotchiType.METAL_GREYMON;
      } else if(rnd == 1) {
        savingotchiType[tokenId] = SavingotchiType.MAMEMON;
      } else {
        savingotchiType[tokenId] = SavingotchiType.TEDDYMON;
      }
    }
  }

  function _getRandom() internal view returns (uint256) {
    return uint256(keccak256(abi.encodePacked(block.timestamp)));
  }
}