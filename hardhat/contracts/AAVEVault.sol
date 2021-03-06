//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./AAVEInterfaces.sol";

contract Vault is Ownable {
  IWETHGateway WETHGateway;
  address LendingPoolAddressesProviderAddress;
  IAToken aMATIC;
  IWMATIC wMATIC;

  address constant DEV = 0xC0600976d468F654a91dDD8D861C6f74925D88F2;

  // mumbai
  // _WETHGateway 0xee9eE614Ad26963bEc1Bec0D2c92879ae1F209fA
  // lendingPool 0x178113104fEcbcD7fF8669a0150721e231F0FD4B
  // aMATIC 0xF45444171435d0aCB08a8af493837eF18e86EE27

  // main net;
  // WETHGATEWAY 0xbEadf48d62aCC944a06EEaE0A9054A90E5A7dc97
  // lendingPool 0xd05e3E715d945B59290df0ae8eF85c1BdB684744
  // aMATIC 0x8dF3aad3a84da6b69A4DA8aeC3eA40d9091B2Ac4
  constructor(address _WETHGateway, address _LendingPoolAddressesProviderAddress, address _aMATIC /*, address _wMATIC */) {
    WETHGateway = IWETHGateway(_WETHGateway);
    LendingPoolAddressesProviderAddress = _LendingPoolAddressesProviderAddress;
    aMATIC = IAToken(_aMATIC);
    wMATIC = IWMATIC(WETHGateway.getWETHAddress());
    aMATIC.approve(address(WETHGateway), type(uint).max);
    aMATIC.approve(address(this), type(uint).max);
    wMATIC.approve(address(this), type(uint).max);
  }

  /*
  //https://docs.aave.com/developers/v/2.0/the-core-protocol/protocol-data-provider
  function Info() public view returns(uint) {

    (
      ,//uint256 currentATokenBalance,
      ,//uint256 currentStableDebt,
      ,//uint256 currentVariableDebt,
      ,//uint256 principalStableDebt,
      ,//uint256 scaledVariableDebt,
      ,//uint256 stableBorrowRate,
      uint256 liquidityRate,
      ,//,uint40 stableRateLastUpdated,
      //,bool usageAsCollateralEnabled
    ) = IAAVEdataProvider(0xFA3bD19110d986c5e5E9DD5F69362d05035D045B).getUserReserveData(address(wMATIC), address(this));

    return liquidityRate;
  }
  */

  function earlyexit(address _account) public onlyOwner {
    uint256 _amount = aMATIC.balanceOf(address(this));
    IAToken(aMATIC).approve(address(WETHGateway), _amount);
    
    // 0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889 WMATIC address
    ILendingPool(seeLendingPool()).withdraw(
        address(wMATIC),
        _amount,
        address(this)
      );

    wMATIC.withdraw(_amount);
    // 10percent fee to admin
    Address.sendValue(payable(DEV), _amount * 100 / 10);
    
    // aave incentives = 0xd41ae58e803edf4304334acce4dc4ec34a63c644
    // 0xd41ae58e803edf4304334acce4dc4ec34a63c644
    // IIncentivesController(incentivesController).claimRewards(assets, type(uint).max, address(this));

    // TODO selfdestruct y claim withdraws
    // see https://github.com/beefyfinance/beefy-contracts/blob/master/contracts/archive/strategies/Aave/StrategyAaveMatic.sol

    selfdestruct(payable(_account));
  }


  function exit(address _account) public onlyOwner {
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

    selfdestruct(payable(_account));
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
    WETHGateway.depositETH{value: msg.value }(
        seeLendingPool(),
        address(this),
        0
    );
  }

  function aMATICbalance() public view returns(uint256){
      return aMATIC.balanceOf(address(this));
  }
  
  function seeLendingPool() public view returns (address){
      return ILendingPoolAddressesProvider(LendingPoolAddressesProviderAddress).getLendingPool();
  }

  receive() external payable {
    depositAAVE();
  }
}