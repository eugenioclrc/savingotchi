pragma solidity ^0.8.4;

import "./AAVEVault.sol";


contract SavingotchiVaultManager {
  mapping(uint256 => Vault) public tokenVaults;

  IAToken aMATIC = IAToken(0x8dF3aad3a84da6b69A4DA8aeC3eA40d9091B2Ac4);

  address public vault;

  address public immutable WETHGateway;
  address public immutable LendingPoolAddressesProviderAddress;
  address public immutable aMATIC;

  constructor(
      address _WETHGateway,
      address _LendingPoolAddressesProviderAddress,
      address _aMATIC
  ) {
      wETHGateway = _WETHGateway;
      lendingPoolAddressesProviderAddress = _LendingPoolAddressesProviderAddress;
      aMATIC = _aMATIC;
  }

  function _createVault(uint256 _tokenId) internal {
    //FooContract foo = payable(new FooContract{ salt: salt}());

    tokenVaults[_tokenId] = new Vault(
      _WETHGateway,
      _LendingPoolAddressesProviderAddress,
      aMATIC
    );
  }

  function _depositVault(uint256 _tokenId) internal {
      tokenVaults[_tokenId].depositAAVE{value: msg.value}();
  }
}