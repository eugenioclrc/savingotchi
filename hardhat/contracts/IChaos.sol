// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface IChaos {
  function requestRandomWords(uint256 tokenId) external;
}