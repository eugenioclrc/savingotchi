/*
  EGG,
  BOTAMON
  KOROMON
    AGUMON
      GREYMON
      TYRANOMON
      DARMKON
      MEARAMON
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
  mapping(uint256 => uint256) lastEvolve;
  mapping(uint256 => SavingotchiType) savingotchiType;
  
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
        // MEARAMON,
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
    // TODO
  }
}