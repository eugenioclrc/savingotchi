pragma solidity ^0.8.4;

import "./AAVEVault.sol";

contract SavingotchiVaultManager {
  mapping(uint256 => Vault) public tokenVaults;
  
  IAToken aMATIC = IAToken(0x8dF3aad3a84da6b69A4DA8aeC3eA40d9091B2Ac4);

  // address public vault;

  constructor(/* address _vault */) public {
    // vault = _vault;
  }
  
  function createVault(uint256 tokenId) internal {
    tokenVaults[tokenId] = new Vault(
      address(0xee9eE614Ad26963bEc1Bec0D2c92879ae1F209fA),
      address(0x178113104fEcbcD7fF8669a0150721e231F0FD4B),
      address(aMATIC)
    );
    
    tokenVaults[tokenId].depositAAVE{value: msg.value}();
  }

  function gotchiValue(uint256 tokenId) public view returns (uint256) {
    return tokenVaults[tokenId].aMATICbalance();
  }

  
}