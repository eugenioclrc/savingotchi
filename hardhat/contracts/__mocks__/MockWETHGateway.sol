pragma solidity ^0.8.4;

import "./WETH9.sol";
import "../AAVEInterfaces.sol";


contract MockWETHGateway is IWETHGateway {
  WETH internal wMATIC;

  constructor(WETH _wMATIC) {
    wMATIC = _wMATIC;
  }

  function depositETH(address, address ,uint16) external payable override {

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