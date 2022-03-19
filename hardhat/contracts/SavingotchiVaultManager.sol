pragma solidity ^0.8.4;

import "./AAVEVault.sol";

contract SavingotchiVaultManager {
  mapping(uint256 => Vault) public tokenVaults;
  
  IAToken aMATIC = IAToken(0xF45444171435d0aCB08a8af493837eF18e86EE27);

  // address public vault;

  constructor(/* address _vault */) public {
    // vault = _vault;
  }
   // _WETHGateway 0xee9eE614Ad26963bEc1Bec0D2c92879ae1F209fA
  // lendingPool 0x178113104fEcbcD7fF8669a0150721e231F0FD4B
  // aMATIC 0xF45444171435d0aCB08a8af493837eF18e86EE27
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