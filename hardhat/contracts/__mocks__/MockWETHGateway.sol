pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./WETH9.sol";
import "../AAVEInterfaces.sol";


contract MockWETHGateway is IWETHGateway {
  WETH internal wMATIC;
  IERC20 internal aMATIC;

  constructor(WETH _wMATIC, IERC20 _aMATIC) {
    wMATIC = _wMATIC;
    aMATIC = _aMATIC;
  }

  function depositETH(address, address ,uint16) external payable override {
    wMATIC.deposit{ value: msg.value }();

    aMATIC.transfer(msg.sender, msg.value);
  }

  function withdrawETH(
    address lendingPool,
    uint256 amount,
    address onBehalfOf
  ) external override {
    revert("NOT IMPLEMENTED");
  }

  function repayETH(
    address lendingPool,
    uint256 amount,
    uint256 rateMode,
    address onBehalfOf
  ) external payable override {
    revert("NOT IMPLEMENTED");
  }

  function borrowETH(
    address lendingPool,
    uint256 amount,
    uint256 interesRateMode,
    uint16 referralCode
  ) external override {
    revert("NOT IMPLEMENTED");
  }

  function getWETHAddress() external override view returns(address) {
    return address(wMATIC);
  }
}