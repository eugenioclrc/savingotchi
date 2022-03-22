//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "./AAVEInterfaces.sol";

contract Vault is Ownable {
  IWETHGateway WETHGateway;
  address LendingPoolAddressesProviderAddress;
  IAToken aMATIC;
  IWMATIC wMATIC;

  // mumbai
  // _WETHGateway 0xee9eE614Ad26963bEc1Bec0D2c92879ae1F209fA
  // lendingPool 0x178113104fEcbcD7fF8669a0150721e231F0FD4B
  // aMATIC 0xF45444171435d0aCB08a8af493837eF18e86EE27

  // main net;
  // WETHGATEWAY 0xbEadf48d62aCC944a06EEaE0A9054A90E5A7dc97
  // lendingPool 0xd05e3E715d945B59290df0ae8eF85c1BdB684744
  // aMATIC 0x8dF3aad3a84da6b69A4DA8aeC3eA40d9091B2Ac4
  constructor(
    address _WETHGateway,
    address _LendingPoolAddressesProviderAddress,
    IAToken _aMATIC
  ) payable {
    WETHGateway = IWETHGateway(_WETHGateway);
    LendingPoolAddressesProviderAddress = _LendingPoolAddressesProviderAddress;
    aMATIC = _aMATIC;
    wMATIC = IWMATIC(WETHGateway.getWETHAddress());
    _aMATIC.approve(_WETHGateway, type(uint).max);
    _aMATIC.approve(address(this), type(uint).max);
    wMATIC.approve(address(this), type(uint).max);

    //depositAAVE();
    WETHGateway.depositETH{ value: msg.value }(
      seeLendingPool(), // pool
      address(this), // onBehalfOf
      0 // referralCode
    );
  }

  function exit() public onlyOwner {
    uint256 _amount = aMATIC.balanceOf(address(this));
    IAToken(aMATIC).approve(address(WETHGateway), _amount);

    // 0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889 WMATIC address
    ILendingPool(seeLendingPool()).withdraw(
        address(wMATIC),
        _amount,
        address(this)
      );

    wMATIC.withdraw(_amount);
    // Address.sendValue(payable(_user), _amount);

    // aave incentives = 0xd41ae58e803edf4304334acce4dc4ec34a63c644
    // 0xd41ae58e803edf4304334acce4dc4ec34a63c644
    // IIncentivesController(incentivesController).claimRewards(assets, type(uint).max, address(this));

    // TODO selfdestruct y claim withdraws
    // see https://github.com/beefyfinance/beefy-contracts/blob/master/contracts/archive/strategies/Aave/StrategyAaveMatic.sol

    selfdestruct(payable(owner()));
  }

  function withdrawAAVE(address _user, uint _amount) public onlyOwner {
    IAToken(aMATIC).approve(address(WETHGateway), _amount);

    // 0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889 WMATIC address
    ILendingPool(seeLendingPool()).withdraw(
        address(wMATIC),
        _amount,
        address(this)
      );

    wMATIC.withdraw(_amount);
    Address.sendValue(payable(_user), _amount);
  }

  function depositAAVE() public payable {
    WETHGateway.depositETH{ value: msg.value }(
      seeLendingPool(), // pool
      address(this), // onBehalfOf
      0 // referralCode
    );
  }

  function aMATICbalance() public view returns(uint256){
    return aMATIC.balanceOf(address(this));
  }

  function seeLendingPool() public view returns (address){
    return ILendingPoolAddressesProvider(LendingPoolAddressesProviderAddress).getLendingPool();
  }

  receive() external payable { }
}