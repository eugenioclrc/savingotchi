pragma solidity ^0.8.4;

import "./AAVEVault.sol";
import "@openzeppelin/contracts/utils/Create2.sol";

contract SavingotchiVaultManager {
  // _WETHGateway 0xee9eE614Ad26963bEc1Bec0D2c92879ae1F209fA
  // lendingPool 0x178113104fEcbcD7fF8669a0150721e231F0FD4B
  // aMATIC 0xF45444171435d0aCB08a8af493837eF18e86EE27

  address internal immutable wETHGateway;
  address internal immutable lendingPoolAddressesProviderAddress;
  IAToken internal immutable aMATIC;

  bytes private VaultCreatioCode;
  bytes32 private immutable VaultBytecodeHash;

  constructor(
    address _wETHGateway,
    address _lendingPoolAddressesProviderAddress,
    IAToken _aMATIC
  ) {
    VaultCreatioCode = abi.encodePacked(
      type(Vault).creationCode,
      bytes32(uint256(uint160(_wETHGateway))),
      bytes32(uint256(uint160(_lendingPoolAddressesProviderAddress))),
      bytes32(uint256(uint160(address(_aMATIC))))
    );
    VaultBytecodeHash = keccak256(VaultCreatioCode);

    wETHGateway = _wETHGateway;
    lendingPoolAddressesProviderAddress = _lendingPoolAddressesProviderAddress;
    aMATIC = _aMATIC;
  }

  function createVault(uint256 _tokenId, uint256 _price) internal {
    Create2.deploy(_price, bytes32(_tokenId), VaultCreatioCode);

    if (msg.value > _price) {
      Address.sendValue(payable(msg.sender), msg.value - _price);
    }
  }

  function vaultAddress(uint256 _tokenId) public view returns (Vault) {
    return Vault(payable(Create2.computeAddress(bytes32(_tokenId), VaultBytecodeHash)));
  }

  function gotchiValue(uint256 _tokenId) public view returns (uint256) {
    return vaultAddress(_tokenId).aMATICbalance();
  }
}
