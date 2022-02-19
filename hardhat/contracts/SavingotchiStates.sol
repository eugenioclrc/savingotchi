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
  mapping(uint256 => uint256) birth;
  mapping(uint256 => uint256) gen;
  mapping(uint256 => uint256) lastEvolve;
  mapping(uint256 => SavingotchiType) savingotchiType;
  
  string[] internal images = [
    // 0
    '<path stroke="#000" d="M8 4h1M6 7h1M13 9h1M7 11h1" /><path stroke="#000" d="M9 4h1M10 6h1M7 7h1M10 7h1M12 7h1M5 8h1M14 9h1M8 11h1M9 15h1" /><path stroke="#000" d="M10 4h1M6 6h1M11 6h1M12 8h1M4 9h1M8 10h1M9 11h1M9 12h1M11 13h2M6 14h2M12 14h1M11 15h1" /><path stroke="#000" d="M7 5h1M11 5h1M13 8h1M7 9h1M7 10h1M14 10h1" /><path stroke="#000" d="M8 5h1M7 6h1M12 9h1M14 11h1M4 12h1M8 12h1M14 12h1M5 13h2M13 13h1M10 14h2" /><path stroke="#FFF" d="M9 5h1M8 8h1M10 8h1M9 9h1M11 11h2" /><path stroke="#FFF" d="M10 5h1M9 6h1M11 10h1M13 10h1M5 12h1" /><path stroke="#000" d="M8 6h1M5 7h1M11 8h1M4 10h1M4 11h1M12 12h1M8 15h1" /><path stroke="#000" d="M12 6h1M13 7h1" /><path stroke="#FFF" d="M8 7h1M9 8h1M5 10h1M11 12h1" /><path stroke="#FFF" d="M9 7h1M7 8h1M5 9h2M8 9h1M10 9h2M6 10h1M9 10h1M12 10h1M5 11h2M13 11h1M7 12h1M10 12h1M7 13h2M10 13h1M9 14h1" /><path stroke="#000" d="M11 7h1M7 15h1M10 15h1" /><path stroke="#FFF" d="M6 8h1M10 10h1M13 12h1" /><path stroke="#FFF" d="M10 11h1M8 14h1" /><path stroke="#FFF" d="M6 12h1M9 13h1" />',
    // 1. Bottamon  
    '<path stroke="#000" d="M8 8h1M8 9h1M11 9h1M12 10h1M7 12h1M12 12h2M7 13h2M10 13h2" /><path stroke="#000" d="M11 8h1M10 9h1M7 10h1M9 10h1M7 11h1M11 11h2M12 13h2" /><path stroke="#000" d="M7 9h1" /><path stroke="#000" d="M9 9h1M8 11h1M10 11h1" /><path stroke="#000" d="M12 9h1M9 11h1M6 13h1" /><path stroke="#FFF" d="M8 10h1" /><path stroke="#000" d="M10 10h1M6 12h1M9 13h1" /><path stroke="#FFF" d="M11 10h1" /><path stroke="#000" d="M8 12h1M11 12h1" /><path stroke="#FFF" d="M9 12h1" /><path stroke="#FFF" d="M10 12h1" />',
    // 2. koromon
    '<path stroke="#000" d="M6 7h1M10 14h1" /><path stroke="#000" d="M7 7h1M4 10h1M11 11h1" /><path stroke="#000" d="M11 7h1M12 8h1M7 10h1M7 11h1M14 12h1M4 13h1M14 13h1M7 14h1" /><path stroke="#000" d="M12 7h1M8 8h1M10 8h1M14 10h1" /><path stroke="#000" d="M6 8h1M9 8h1M5 9h1M11 10h1M4 11h1M9 12h1M6 14h1M8 14h1M11 14h3" /><path stroke="#FFF" d="M7 8h1M7 9h1M10 10h1M7 12h2" /><path stroke="#FFF" d="M11 8h1M10 9h1M6 11h1M9 11h1M13 11h1M12 12h1M10 13h1" /><path stroke="#FFF" d="M6 9h1M8 9h1M12 9h1M6 10h1M8 10h1M5 11h1M8 11h1M10 11h1M12 11h1M5 12h2M13 12h1M5 13h1M7 13h1M9 13h1M11 13h1" /><path stroke="#FFF" d="M9 9h1M8 13h1M12 13h2" /><path stroke="#FFF" d="M11 9h1M10 12h2" /><path stroke="#000" d="M13 9h1M14 11h1M4 12h1" /><path stroke="#FFF" d="M5 10h1M12 10h2" /><path stroke="#FFF" d="M9 10h1M6 13h1" /><path stroke="#000" d="M5 14h1M9 14h1" />',
    // 3. agumon 
    '<path stroke="#000" d="M7 3h1M9 3h2M4 12h1M10 13h1M9 15h1M4 17h1" /><path stroke="#000" d="M8 3h1M6 4h1M9 5h1M4 6h1M2 7h1M8 7h1M10 7h1M4 8h2M14 8h1M11 11h1M14 12h1M5 13h1M14 13h1M4 15h1M6 17h2M10 17h2" /><path stroke="#000" d="M11 3h1M13 5h1M5 10h1M5 11h1M12 13h1M12 14h1M8 15h1M5 16h1" /><path stroke="#FFF" d="M7 4h1M3 7h1M13 9h1M11 12h1" /><path stroke="#FFF" d="M8 4h1M11 5h1M10 8h1M4 9h1M9 12h1M6 16h1" /><path stroke="#FFF" d="M9 4h2M11 6h1M13 7h1M5 9h1M7 9h1M9 9h3M10 11h1M12 11h1" /><path stroke="#FFF" d="M11 4h1M10 5h1M6 6h1M8 6h1M4 7h1M6 7h1M12 7h1M6 8h2M11 8h3M6 9h1M5 12h1M12 12h1M9 13h1M13 13h1M9 14h2M14 14h1M6 15h1M12 15h3M11 16h1" /><path stroke="#000" d="M12 4h1M5 5h1M9 6h1M13 6h1M2 8h1M6 10h1M10 15h1M15 15h1M3 16h1" /><path stroke="#000" d="M6 5h1M3 6h1M3 9h1M7 10h1M13 11h1M6 12h1M4 13h1M8 17h1M13 17h1M15 17h1" /><path stroke="#FFF" d="M7 5h1M8 9h1" /><path stroke="#000" d="M8 5h1M10 6h1M9 7h1M14 7h1M3 8h1M14 9h1M4 10h1M13 10h1M10 12h1M6 13h1M11 13h1M15 14h1M5 15h1M10 16h1M12 16h1M14 16h1M16 16h1M5 17h1M12 17h1M14 17h1" /><path stroke="#FFF" d="M12 5h1M12 6h1M12 10h1M9 11h1M8 12h1M13 12h1M7 13h1M8 14h1M11 14h1M7 15h1M7 16h1M15 16h1" /><path stroke="#FFF" d="M5 6h1M7 6h1M7 7h1M11 7h1M9 8h1M9 10h1M7 11h2M7 12h1M13 14h1M13 16h1" /><path stroke="#FFF" d="M5 7h1M8 8h1M12 9h1M10 10h2M8 13h1M4 16h1" /><path stroke="#000" d="M8 10h1M6 11h1M6 14h1M11 15h1M3 17h1" /><path stroke="#000" d="M7 14h1M8 16h1M16 17h1" />',

    // 4. betamon
    '<path stroke="#000" d="M5 4h1M12 13h1M17 14h1" /><path stroke="#000" d="M6 4h1M5 5h1M10 5h1M6 7h1M8 7h1M5 8h1M11 9h1M17 9h1M8 11h1M2 14h1M3 15h2" /><path stroke="#000" d="M7 4h3M6 6h1M15 10h1M13 11h1M16 11h1M3 13h1M17 13h1M5 14h1M7 14h1M13 14h1M5 15h1M9 15h1M13 15h1" /><path stroke="#FFF" d="M6 5h1M9 6h1M11 6h1M10 8h1M9 10h1M11 10h1M13 10h1M4 11h1M6 12h1M8 12h1M6 13h1M13 13h1M16 13h1M3 14h1M9 14h1" /><path stroke="#FFF" d="M7 5h1M16 10h1M15 14h1" /><path stroke="#FFF" d="M8 5h1M7 7h1M12 7h1M6 8h1M9 9h1M13 9h1M6 11h2M10 11h1M12 11h1M10 12h1M12 12h1M15 12h1M8 13h1M10 14h1" /><path stroke="#FFF" d="M9 5h1M7 6h1M9 8h1M11 8h1M8 9h1M14 9h1M4 10h1M6 10h1M12 10h1M9 11h1M14 11h1M7 12h1M11 12h1M14 12h1M4 13h1M9 13h1M11 13h1M15 13h1M16 14h1" /><path stroke="#000" d="M11 5h1M8 10h1M14 15h1" /><path stroke="#FFF" d="M8 6h1M5 9h1M15 11h1M13 12h1M5 13h1M7 13h1M10 13h1M14 14h1" /><path stroke="#FFF" d="M10 6h1M8 8h1M6 9h2M7 10h1M11 11h1M4 12h1" /><path stroke="#000" d="M12 6h1M13 7h1M12 8h1M14 8h1M16 9h1M5 10h1M10 10h1M17 10h1M3 11h1M5 11h1M4 14h1M12 14h1" /><path stroke="#000" d="M9 7h1M11 7h1M7 8h1M13 8h1M12 9h1M15 9h1M17 11h1M14 13h1M11 14h1M10 15h1M15 15h1" /><path stroke="#000" d="M10 7h1M4 9h1M3 10h1M3 12h1M6 14h1M8 14h1M2 15h1M8 15h1M16 15h1" /><path stroke="#FFF" d="M10 9h1" /><path stroke="#000" d="M14 10h1M16 12h1M11 15h1" /><path stroke="#FFF" d="M5 12h1M9 12h1" />',
    // 5. greyon
    '<path stroke="#000" d="M7 2h1M14 2h1M2 4h1M2 5h1M9 5h1M2 6h1M13 6h1M3 7h1M7 7h1M15 11h1M9 13h1M17 13h1M5 14h1M12 14h1M17 14h1M12 15h1M3 17h2M16 17h1" /><path stroke="#000" d="M8 2h1M15 2h1M9 4h1M14 5h1M5 9h1M7 9h1M12 10h1M5 11h1M6 15h1M15 16h1M17 16h1" /><path stroke="#000" d="M9 2h1M11 2h1M13 3h1M2 7h1M6 7h1M13 7h1M3 13h1M2 16h1M4 16h1M8 16h1M6 17h1M12 17h1M15 17h1" /><path stroke="#000" d="M10 2h1M15 10h1M10 11h2M3 12h1M16 12h2M4 15h1M13 16h1M13 17h1M17 17h1" /><path stroke="#000" d="M16 2h1M2 3h1M16 3h1M4 5h1M14 8h1M6 9h1M5 13h1M11 14h1M3 15h1M7 16h1M11 16h1M5 17h1" /><path stroke="#000" d="M3 3h1M6 3h1M5 4h1M15 4h1M13 5h1M4 11h1M5 12h1M10 14h1M2 17h1M14 17h1" /><path stroke="#FFF" d="M7 3h1M10 3h1M12 4h1M5 6h1M9 6h2M9 7h1M4 8h1M8 8h1M7 10h1M13 10h1M12 11h1M9 14h1M8 15h1M12 16h1M14 16h1" /><path stroke="#FFF" d="M8 3h1M15 3h1M7 4h2M8 7h1M9 8h1M14 10h1M7 11h1M4 12h1M7 12h1M14 12h1M8 13h1M10 13h1M13 15h1M6 16h1" /><path stroke="#FFF" d="M9 3h1M14 3h1M3 4h1M14 4h1M5 5h1M10 5h2M3 6h1M7 6h1M10 7h1M12 7h1M5 8h1M7 8h1M10 8h4M10 9h1M12 9h2M8 10h3M8 11h2M14 11h1M10 12h2M13 12h1M4 13h1M6 13h2M11 13h1M7 14h1M16 14h1M7 15h1M9 15h2M14 15h2M3 16h1M5 16h1M16 16h1" /><path stroke="#FFF" d="M11 3h1" /><path stroke="#000" d="M12 3h1M4 4h1M6 4h1M10 4h1M3 5h1M8 5h1M4 7h2M4 9h1M8 9h1M6 10h1M13 13h1M4 14h1M9 16h1" /><path stroke="#FFF" d="M11 4h1M13 4h1M12 6h1M11 10h1M13 11h1M12 12h1M12 13h1M6 14h1M8 14h1M14 14h1M11 15h1" /><path stroke="#FFF" d="M6 5h2M11 6h1M11 9h1M6 12h1M8 12h1M14 13h1M16 13h1M13 14h1" /><path stroke="#000" d="M12 5h1M6 6h1M3 8h1M14 9h1M9 12h1M15 12h1M15 13h1M15 14h1M16 15h1M10 16h1M7 17h1" /><path stroke="#FFF" d="M4 6h1M8 6h1M6 8h1M9 9h1M6 11h1M5 15h1" /><path stroke="#FFF" d="M11 7h1" />',
    // 6. tyranomon
    '<path stroke="#000" d="M7 2h1M12 6h1M15 8h1M7 9h1M14 11h1M3 12h1M15 12h1M12 14h1M15 17h1" /><path stroke="#000" d="M8 2h1M10 4h1M2 5h1M8 5h1M7 7h1M8 9h1M15 10h1M17 13h1M15 14h1M17 14h1M10 16h2M2 17h1M13 17h2" /><path stroke="#000" d="M9 2h3M9 4h1M10 5h1M13 5h1M6 6h1M3 7h1M6 7h1M11 7h1M13 7h1M3 8h1M14 8h1M5 12h1M9 13h1M5 14h1M11 14h1M13 14h1M12 15h1M7 16h1M6 17h3M12 17h1" /><path stroke="#000" d="M13 2h1M12 3h1M14 3h1M5 4h2M11 4h1M3 5h1M2 6h1M13 6h1M14 7h1M12 9h1M13 10h1M5 11h1M10 11h2M9 16h1M15 16h1M3 17h1M5 17h1" /><path stroke="#000" d="M14 2h1M15 5h1M2 7h1M5 7h1M10 7h1M12 7h1M14 10h1M16 12h1M3 13h1M4 14h1M2 16h1M17 16h1" /><path stroke="#000" d="M6 3h1M4 4h1M4 5h1M14 5h1M13 8h1M11 9h1M13 9h2M16 9h1M4 11h1M5 13h1M3 15h1M13 16h1M4 17h1M17 17h1" /><path stroke="#FFF" d="M7 3h2M10 3h1M13 3h1M8 4h1M3 6h1M7 6h1M9 6h2M15 9h1M7 10h2M11 10h1M7 11h1M9 11h1M12 11h1M4 12h1M12 12h1M4 13h1M11 13h1M16 13h1M8 14h1M14 14h1M5 15h1M15 15h1M3 16h1M6 16h1M14 16h1M16 16h1" /><path stroke="#FFF" d="M9 3h1M11 3h1M12 4h1M5 5h1M11 5h1M11 6h1M14 6h1M9 7h1M4 8h1M7 8h1M12 10h1M8 11h1M7 12h1M11 12h1M6 13h1M8 13h1M14 13h1M7 15h2M11 15h1" /><path stroke="#FFF" d="M7 4h1M9 9h1M14 12h1M9 14h1" /><path stroke="#000" d="M13 4h1M15 6h1M16 8h1M5 9h1M6 10h1M15 11h1M13 13h1M10 14h1M4 15h1M16 15h1M11 17h1" /><path stroke="#FFF" d="M6 5h1M12 5h1M5 6h1M8 7h1M9 8h1M10 10h1M10 12h1M13 15h1" /><path stroke="#FFF" d="M7 5h1M4 6h1M12 8h1M10 9h1M6 12h1M12 13h1" /><path stroke="#FFF" d="M9 5h1M8 6h1M5 8h2M8 8h1M11 8h1M8 12h1M13 12h1M7 13h1M10 13h1M6 14h2M10 15h1M5 16h1M12 16h1" /><path stroke="#000" d="M4 7h1M4 9h1M6 9h1M9 12h1M17 12h1M15 13h1M6 15h1M4 16h1M8 16h1M16 17h1" /><path stroke="#FFF" d="M10 8h1M13 11h1M16 14h1" /><path stroke="#FFF" d="M9 10h1M6 11h1M9 15h1M14 15h1" />',
    // 7. darkmon
    '<path stroke="#000" d="M2 2h1M7 2h1M10 2h2M16 2h2M6 3h1M9 3h2M14 3h4M6 4h1M4 5h3M15 5h1M6 6h1M9 6h1M16 7h1M3 8h1M8 8h1M10 8h1M15 8h2M2 9h1M4 9h1M17 9h1M2 10h1M8 10h2M11 10h1M17 10h1M2 11h1M3 13h1M5 13h2M13 13h2M13 14h1M5 15h1M14 15h1M9 16h2M7 17h1" /><path stroke="#000" d="M3 2h1M8 2h1M2 3h4M8 3h1M11 3h1M3 4h1M7 4h2M8 5h2M13 6h1M5 7h1M9 7h1M14 7h1M5 8h1M17 8h1M12 9h1M9 13h2M6 14h1M4 17h3M14 17h1" /><path stroke="#000" d="M9 2h1M12 3h2M5 4h1M14 5h1M2 8h1M9 8h1M8 13h1M11 13h1" /><path stroke="#000" d="M12 2h1M11 4h1M16 4h1M10 5h2M5 6h1M12 7h2M13 8h1M15 10h2M3 11h1M16 11h1M3 12h1M16 13h1M9 14h1M16 14h1M15 17h1" /><path stroke="#000" d="M7 3h1M4 4h1M13 4h1M13 5h1M7 7h1M10 7h1M4 8h1M6 8h2M11 8h1M7 9h1M3 14h1M4 16h1M11 16h1M12 17h2" /><path stroke="#000" d="M9 4h1M14 4h2M10 6h1M14 6h1M3 9h1M10 10h1" /><path stroke="#000" d="M10 4h1M6 7h1M14 8h1M15 9h1M17 11h1M10 14h1M15 16h1" /><path stroke="#000" d="M12 4h1M3 7h1M12 8h1M16 9h1M3 10h2M16 12h1M4 15h1M15 15h1M8 16h1" /><path stroke="#FFF" d="M7 5h1M12 5h1M12 6h1M8 7h1M9 9h2M13 9h1M5 10h1M12 10h3M4 11h1M6 11h2M9 11h1M11 11h1M15 11h1M4 12h1M6 12h1M8 12h1M11 12h1M14 12h1M7 13h1M12 13h1M12 14h1M15 14h1M8 15h1M12 15h1M5 16h3M12 16h1" /><path stroke="#FFF" d="M7 6h2M7 10h1M5 11h1M10 11h1M14 11h1M7 12h1M7 14h1M6 15h1M10 15h2M13 15h1M13 16h1" /><path stroke="#FFF" d="M11 6h1M6 9h1M11 9h1M12 11h1M4 14h1M8 14h1M7 15h1M14 16h1" /><path stroke="#FFF" d="M11 7h1M8 9h1M6 10h1M13 11h1M10 12h1M12 12h1M11 14h1M9 15h1" /><path stroke="#FFF" d="M5 9h1M5 12h1M13 12h1M14 14h1" /><path stroke="#FFF" d="M14 9h1M8 11h1M9 12h1M4 13h1" /><path stroke="#FFF" d="M15 12h1M15 13h1M5 14h1" />',

    // 9.airdramon
    '<path stroke="#000" d="M10 2h1M8 3h2M6 4h1M13 5h1M4 6h1M17 6h1M2 8h1M3 9h1M9 9h1M17 9h1M5 10h1M15 11h1M16 12h1M7 13h1M12 13h1M17 14h1M11 15h1M11 17h1M13 17h2" /><path stroke="#000" d="M11 2h1M7 3h1M14 3h1M8 5h2M6 6h1M13 6h1M17 8h1M13 9h1M15 9h1M6 10h2M7 11h1M6 14h1M15 14h1M9 15h1M17 15h1M10 16h1M16 16h1M15 17h1" /><path stroke="#000" d="M12 2h1M12 5h1M8 10h1M8 12h1M15 13h1M12 17h1" /><path stroke="#000" d="M14 2h1M6 13h1M10 17h1" /><path stroke="#000" d="M15 2h1M2 7h1M12 7h1M17 7h1M17 10h1M9 11h1M17 11h1M8 14h1" /><path stroke="#FFF" d="M10 3h1M7 6h1M9 6h2M12 6h1M3 7h1M6 7h2M15 7h1M12 8h1M16 8h1M7 9h1M10 10h1M15 12h1M8 13h1M16 14h1" /><path stroke="#FFF" d="M11 3h1M15 3h1M7 4h1M9 4h1M15 4h1M6 5h1M5 6h1M5 7h1M8 7h1M10 7h1M11 8h1M13 8h1M15 8h1M8 9h1M10 9h2M14 9h1M16 9h1M12 10h1M10 11h1M12 11h1M9 12h1M14 12h1M14 13h1M7 14h1M9 14h2M12 14h1M8 15h1M12 15h1M15 15h1M11 16h1" /><path stroke="#000" d="M12 3h1M16 3h1M14 4h1M16 4h1M8 6h1M4 10h1M15 10h1M13 11h1M6 12h1M17 13h1M8 16h1M9 17h1" /><path stroke="#FFF" d="M8 4h1M14 5h1M14 6h1M16 6h1M4 7h1M9 7h1M14 7h1M7 8h1M14 8h1M12 9h1M9 10h1M8 11h1M13 12h1M9 13h1M10 15h1M9 16h1M15 16h1" /><path stroke="#FFF" d="M10 4h1M10 5h1M16 5h1M15 6h1M11 7h1M8 8h3M5 9h1M13 10h1M11 12h1M14 15h1" /><path stroke="#000" d="M11 4h1M17 5h1M3 6h1M4 8h2M12 12h1M13 14h2M7 15h1M12 16h1M14 16h1" /><path stroke="#000" d="M5 5h1M7 5h1M3 8h1M14 10h1" /><path stroke="#FFF" d="M11 5h1M11 6h1M6 8h1M4 9h1M11 10h1M11 11h1M7 12h1M10 12h1M10 13h1M13 13h1M13 15h1M16 15h1" /><path stroke="#FFF" d="M15 5h1M13 7h1M14 11h1M16 13h1" /><path stroke="#FFF" d="M16 7h1M6 9h1M16 10h1M11 13h1M11 14h1M13 16h1" /><path stroke="#FFF" d="M16 11h1" />',
    // 10.seadramon
    '<path stroke="#000" d="M7 2h1M9 2h1M11 2h1M5 3h1M13 3h1M8 4h1M3 5h1M7 5h2M12 5h1M14 6h1M2 7h1M6 7h1M8 7h1M13 7h1M10 8h1M14 8h1M9 9h1M8 10h1M14 11h1M12 13h1M6 14h1M13 14h2M17 14h1M17 15h1M7 16h1M8 17h1M11 17h1M13 17h1" /><path stroke="#000" d="M8 2h1M12 3h1M14 5h2M7 7h1M15 7h1M7 9h1M14 9h1M13 10h1M6 13h1M15 13h1M9 16h1" /><path stroke="#000" d="M10 2h1M15 4h1M11 7h2M9 10h1M8 13h1" /><path stroke="#000" d="M6 3h1M15 3h1M16 5h1M11 16h1M13 16h1M12 17h1" /><path stroke="#FFF" d="M7 3h1M12 4h2M5 5h1M4 6h1M13 6h1M9 7h1M15 12h1M11 15h1M15 15h1" /><path stroke="#FFF" d="M8 3h1M10 3h2M5 4h3M11 4h1M10 5h1M11 6h1M6 8h1M11 9h1M13 9h1M10 10h1M9 11h2M12 11h1M7 13h1M9 13h3M14 13h1M12 14h1M16 14h1M14 15h1M16 15h1M8 16h1M14 16h1" /><path stroke="#FFF" d="M9 3h1M10 4h1M4 5h1M9 5h1M11 5h1M5 6h2M9 6h2M11 8h1M12 10h1M11 11h1M16 13h1M10 14h2M7 15h1M9 15h1" /><path stroke="#000" d="M14 3h1M4 4h1M3 7h3M8 11h1M9 12h1M14 12h1M16 12h1M7 14h1M15 14h1M14 17h1" /><path stroke="#000" d="M16 3h1M6 9h1M8 9h1M9 17h2" /><path stroke="#000" d="M9 4h1M14 7h1M3 8h1M4 9h1M7 11h1M13 11h1M15 11h1M7 12h1M12 12h1M9 14h1M8 15h1M16 16h1M15 17h1" /><path stroke="#FFF" d="M14 4h1M12 6h1M10 7h1M5 8h1M7 8h3M12 8h1M10 9h1M12 9h1M12 15h2M10 16h1" /><path stroke="#FFF" d="M6 5h1M13 8h1M8 12h1M8 14h1" /><path stroke="#000" d="M13 5h1M2 6h1M5 9h1M17 13h1M6 15h1M10 15h1" /><path stroke="#FFF" d="M3 6h1M11 10h1M11 12h1" /><path stroke="#FFF" d="M7 6h1M10 12h1M13 12h1M13 13h1M12 16h1M15 16h1" /><path stroke="#FFF" d="M8 6h1M4 8h1" />',
    // 11.numemon
    '<path stroke="#000" d="M3 2h1M5 3h1M7 3h1M6 6h1M6 8h1M5 10h1M11 16h1" /><path stroke="#000" d="M5 2h1M11 4h2M12 5h1M5 6h1M5 7h1M14 12h1M5 16h1M12 16h2" /><path stroke="#000" d="M7 2h1M14 2h1M12 6h2M11 8h1M12 10h1M15 12h1M8 13h1M10 13h1M7 16h1" /><path stroke="#000" d="M10 2h1M3 4h1M10 4h1M7 6h1M11 6h1M8 9h2M16 13h1M3 14h1M15 15h1" /><path stroke="#000" d="M12 2h1M10 3h1M12 3h1M14 3h1M6 4h1M5 5h1M14 6h1M12 7h1M5 9h1M10 9h1M8 10h2M5 11h1M13 11h1M5 12h1M4 13h1M7 13h1M17 14h1M4 15h1M14 15h1M16 15h1M6 16h1M9 16h1" /><path stroke="#000" d="M3 3h1M14 4h1M3 5h1M10 5h1M4 6h1M7 9h1M11 9h1M10 16h1" /><path stroke="#000" d="M4 4h1M7 4h1M13 4h1M7 5h1M3 6h1M10 6h1M9 13h1M8 16h1" /><path stroke="#000" d="M5 4h1M14 5h1" /><path stroke="#FFF" d="M4 5h1M11 5h1M13 5h1M7 11h4M6 12h1M8 12h1M11 13h1M15 13h1M4 14h3M8 14h1M11 14h2M14 14h2M5 15h1M8 15h1M11 15h1M13 15h1" /><path stroke="#FFF" d="M6 5h1M11 10h1M11 11h1M9 15h1" /><path stroke="#FFF" d="M6 9h1M6 13h1M14 13h1M7 14h1" /><path stroke="#FFF" d="M6 10h1M12 11h1M7 12h1M9 12h1M11 12h2M9 14h1M7 15h1" /><path stroke="#FFF" d="M7 10h1M10 10h1M6 11h1M13 12h1M13 14h1" /><path stroke="#FFF" d="M10 12h1M10 14h1M16 14h1M6 15h1M10 15h1M12 15h1" /><path stroke="#FFF" d="M5 13h1M12 13h1" /><path stroke="#FFF" d="M13 13h1" />',
    
    // 8. meramon
    '<path stroke="#000" d="M4 2h1M10 2h1M6 4h1M11 4h1M13 4h1M7 7h1M2 8h1M5 8h1M14 8h1M17 8h1M3 9h1M2 11h1M10 11h1M6 13h1M3 14h1M13 14h1M10 15h1M15 15h1M3 16h1M8 16h1M16 16h1M5 17h2" /><path stroke="#000" d="M7 2h1M15 2h1M6 3h1M4 4h1M15 4h1M8 7h1M15 7h1M8 8h1M11 8h1M5 9h1M17 9h1M7 11h1M9 11h1M17 11h1M3 13h1" /><path stroke="#000" d="M9 2h1M12 2h1M11 3h1M13 3h2M4 5h1M7 6h1M12 6h1M2 9h1M11 11h1M16 13h1M6 14h1M16 14h1M11 16h1M4 17h1M15 17h1" /><path stroke="#000" d="M4 3h1M15 6h1M16 9h1M16 12h1M3 17h1M7 17h1" /><path stroke="#000" d="M5 3h1M4 7h1M12 7h1M13 17h1M16 17h1" /><path stroke="#FFF" d="M7 3h1M12 4h1M14 4h1M9 5h1M14 5h1M8 6h2M13 8h1M7 9h1M9 10h2M10 14h1M8 15h1M6 16h1M15 16h1" /><path stroke="#000" d="M8 3h1M15 3h1M8 4h1M4 6h1M14 9h1M2 10h1M13 10h1M15 10h1M17 10h1M8 11h1M12 11h1M4 15h2M9 15h1" /><path stroke="#FFF" d="M9 3h1M9 7h1M14 7h1M10 8h1M6 9h1M8 10h1M12 10h1M12 12h1M7 14h1M6 15h1M12 16h1" /><path stroke="#FFF" d="M10 3h1M12 3h1M5 4h1M9 4h2M7 5h1M10 5h3M6 6h1M10 6h1M14 6h1M5 7h2M13 7h1M6 8h1M12 8h1M9 9h1M12 9h2M3 10h1M14 10h1M16 10h1M3 11h1M6 11h1M13 11h1M15 11h2M4 12h1M8 12h3M13 12h1M15 12h1M4 13h1M7 13h2M10 13h1M15 13h1M5 14h1M9 14h1M11 14h1M14 14h2M7 15h1M11 15h1M4 16h2M7 16h1" /><path stroke="#FFF" d="M7 4h1M5 5h1M8 5h1M13 5h1M11 6h1M10 7h1M10 9h1M5 10h1M7 10h1M11 10h1M5 11h1M14 12h1M9 13h1M12 13h1M4 14h1M12 14h1M13 16h2" /><path stroke="#FFF" d="M6 5h1M5 6h1M13 6h1M7 8h1M5 12h1M11 12h1M8 14h1" /><path stroke="#000" d="M15 5h1M11 7h1M4 10h1M6 10h1M3 12h1M14 13h1M12 17h1M14 17h1" /><path stroke="#FFF" d="M9 8h1M11 9h1M7 12h1M11 13h1M12 15h1" /><path stroke="#FFF" d="M8 9h1M14 11h1M13 15h1" /><path stroke="#FFF" d="M4 11h1M6 12h1" /><path stroke="#000" d="M5 13h1M13 13h1M14 15h1" />',
    
    // 12.metal_greymon
    '<path stroke="#000" d="M7 2h1M12 3h1M13 13h1M17 13h1M11 14h2M11 16h1M17 16h1M3 17h1" /><path stroke="#000" d="M8 2h1M14 2h2M2 3h1M13 3h1M16 3h1M5 4h2M10 4h1M2 5h2M2 6h1M12 6h1M14 6h1M2 7h2M12 7h1M3 8h1M6 9h2M17 9h1M13 10h1M15 10h1M9 11h1M17 11h1M3 13h1M14 13h2M6 15h1M4 16h1M9 16h2M15 16h1M7 17h2M12 17h1M15 17h1" /><path stroke="#000" d="M9 2h1M11 2h1M2 4h1M9 5h1M11 6h1M6 7h1M9 8h1M4 9h1M8 12h1M11 12h1M16 13h1M12 15h1M2 16h1M6 17h1" /><path stroke="#000" d="M10 2h1M16 2h1M8 4h1M5 9h1M17 12h1M16 15h1" /><path stroke="#000" d="M3 3h1M15 4h1M4 5h1M7 5h1M13 5h2M7 7h1M13 8h1M8 9h1M13 9h1M4 11h1M14 11h2M3 12h1M8 13h1M10 14h1M3 15h1M2 17h1M4 17h1M13 17h1M17 17h1" /><path stroke="#000" d="M6 3h1M9 4h1M16 5h1M5 7h1M8 8h1M17 8h1M6 10h1M11 10h1M14 12h1M5 13h1M11 13h1M4 14h2M9 14h1M8 16h1M5 17h1" /><path stroke="#FFF" d="M7 3h1M13 4h1M11 5h1M8 7h1M9 10h1M8 11h1M11 11h2M4 12h1M7 13h1M14 15h1" /><path stroke="#FFF" d="M8 3h1M10 3h1M11 4h1M5 6h1M7 6h1M15 6h1M15 7h1M12 9h1M12 10h1M6 11h1M16 12h1M9 13h1M15 14h1M8 15h2M11 15h1M16 16h1" /><path stroke="#FFF" d="M9 3h1M11 3h1M14 3h1M7 4h1M5 5h1M10 5h1M12 5h1M3 6h2M6 6h1M9 6h2M13 6h1M11 7h1M13 7h1M4 8h2M7 8h1M10 8h1M12 8h1M14 8h3M9 9h1M14 9h2M14 10h1M16 10h1M13 11h1M16 11h1M6 12h1M9 12h2M12 12h1M6 13h1M7 14h1M16 14h1M5 15h1M13 15h1M3 16h1M5 16h2M14 16h1" /><path stroke="#FFF" d="M15 3h1M3 4h1M15 5h1M9 7h1M16 9h1M7 10h1M13 12h1M4 13h1M10 13h1M6 14h1M8 14h1M10 15h1M15 15h1M12 16h1" /><path stroke="#000" d="M4 4h1M10 7h1M17 10h1M15 12h1M14 17h1" /><path stroke="#FFF" d="M12 4h1M8 5h1M11 8h1M10 10h1M13 14h1M7 15h1" /><path stroke="#FFF" d="M14 4h1" /><path stroke="#FFF" d="M6 5h1M8 6h1M6 8h1M11 9h1M12 13h1" /><path stroke="#000" d="M16 6h1M4 7h1M14 7h1M16 7h1M5 11h1M10 11h1M5 12h1M14 14h1M17 14h1M4 15h1M7 16h1M13 16h1M16 17h1" /><path stroke="#FFF" d="M10 9h1M8 10h1M7 11h1M7 12h1" />',
    // 13.mamemon
    '<path stroke="#000" d="M9 7h2M12 10h1M7 12h1M8 13h2M13 14h1" /><path stroke="#000" d="M6 8h1M7 9h1M11 10h1M9 12h1" /><path stroke="#000" d="M8 8h1M13 8h1M10 9h1M9 10h1M7 11h1M11 11h1M12 12h1M10 13h1M12 14h1" /><path stroke="#000" d="M9 8h1M7 10h1" /><path stroke="#000" d="M10 8h1M12 11h1M11 13h1" /><path stroke="#000" d="M11 8h1M8 10h1M10 10h1M8 11h1M10 12h1M6 14h2" /><path stroke="#FFF" d="M8 9h1" /><path stroke="#000" d="M9 9h1M12 9h1M8 12h1M11 12h1" /><path stroke="#FFF" d="M11 9h1" /><path stroke="#FFF" d="M9 11h2" />',
    // 14. Teddymon
    '<path stroke="#000" d="M4 2h1M14 2h1M5 4h1M13 5h1M14 9h1M5 10h1M12 10h1M2 14h1M15 16h1M4 17h1M14 17h1" /><path stroke="#000" d="M5 2h1M16 4h1M14 6h1M3 10h1M15 10h1M3 14h1M10 16h1M2 17h1M6 17h1M10 17h1" /><path stroke="#000" d="M7 2h1M10 2h2M3 4h1M4 7h1M9 8h1M4 11h1M8 12h1M3 13h1M12 14h1M15 15h1M9 17h1M12 17h1" /><path stroke="#000" d="M8 2h1M15 2h1M16 3h1M10 5h1M14 7h1M14 8h1M16 11h1M13 12h1M14 13h1M6 14h1M8 14h1M3 17h1" /><path stroke="#000" d="M9 2h1M13 2h1M3 3h1M12 3h1M8 7h1M13 9h1M10 10h1M2 11h1M16 12h1M15 13h1M4 14h1M11 14h1M1 15h1M5 15h1" /><path stroke="#FFF" d="M4 3h1M10 3h2M15 3h1M9 4h1M14 4h1M7 5h1M14 5h1M6 6h1M10 6h1M5 8h1M12 9h1M5 11h1M13 11h1M9 12h1M9 13h1M11 13h1M7 14h1M7 15h1M11 15h1M3 16h1M14 16h1" /><path stroke="#FFF" d="M5 3h1M4 4h1M8 5h1M11 8h1M11 9h1M13 10h1M8 11h3M4 12h1M7 12h1M15 12h1M5 13h1M13 13h1M9 14h2M3 15h1M8 15h1M13 15h1M13 16h1" /><path stroke="#000" d="M6 3h1M4 5h1M4 6h1M9 6h1M5 9h1M6 10h1M2 12h1M6 12h1M10 15h1" /><path stroke="#FFF" d="M7 3h1M9 3h1M13 3h2M15 4h1M12 5h1M10 8h1M12 8h1M10 9h1M7 10h1M14 10h1M12 11h1M14 11h1M14 12h1M9 15h1M9 16h1M12 16h1" /><path stroke="#FFF" d="M8 3h1M6 4h3M10 4h1M12 4h2M9 5h1M5 6h1M11 6h3M5 7h1M10 7h2M13 7h1M6 8h1M6 9h4M4 10h1M9 10h1M3 11h1M6 11h2M11 11h1M15 11h1M10 12h1M12 12h1M4 13h1M8 13h1M10 13h1M12 13h1M12 15h1M4 16h1M6 16h3M11 16h1" /><path stroke="#FFF" d="M11 4h1" /><path stroke="#000" d="M5 5h1M11 5h1M15 6h1M7 8h1M4 9h1M11 10h1M3 12h1M7 13h1M13 14h1M15 14h1M14 15h1M1 16h1M5 16h1M7 17h1M11 17h1" /><path stroke="#000" d="M6 5h1M16 5h1M7 6h2M4 8h1M8 17h1M13 17h1" /><path stroke="#FFF" d="M15 5h1M9 7h1M8 8h1M13 8h1M8 10h1M11 12h1M6 15h1" /><path stroke="#FFF" d="M6 7h2M14 14h1M2 15h1" /><path stroke="#FFF" d="M12 7h1M5 12h1M6 13h1M5 14h1M4 15h1M2 16h1" />'
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

  function getRandom() internal view returns (uint256) {
    return uint256(keccak256(abi.encodePacked(block.timestamp)));
  }

  function _evolve(uint256 tokenId) internal {
    require(stage(tokenId) != SavingotchiStage.ADULT, "Cannot evolve an adult Savingotchi");
    uint256 rnd;
    if (savingotchiType[tokenId] == SavingotchiType.EGG) {
      savingotchiType[tokenId] = SavingotchiType.BOTAMON;
    } else if(savingotchiType[tokenId] == SavingotchiType.BOTAMON) {
      savingotchiType[tokenId] = SavingotchiType.KOROMON;
    } else if(savingotchiType[tokenId] == SavingotchiType.KOROMON) {
      rnd = getRandom();
      if ((rnd % 2) == 0) {
        savingotchiType[tokenId] = SavingotchiType.AGUMON;
      } else {
        savingotchiType[tokenId] = SavingotchiType.BETAMON;
      }
    } else if(savingotchiType[tokenId] == SavingotchiType.AGUMON) {
      rnd = getRandom() % 4;
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
      rnd = getRandom() % 4;
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
      rnd = getRandom() % 3;
      if(rnd == 0) {
        savingotchiType[tokenId] = SavingotchiType.METAL_GREYMON;
      } else if(rnd == 1) {
        savingotchiType[tokenId] = SavingotchiType.MAMEMON;
      } else {
        savingotchiType[tokenId] = SavingotchiType.TEDDYMON;
      }
    }
  }
}