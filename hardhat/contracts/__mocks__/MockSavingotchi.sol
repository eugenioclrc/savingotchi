// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../Savingotchi.sol";


contract MockSavingotchi is Savingotchi {
    constructor(
        uint256 _basePrice,
        IUniswapV2Router02 _router,
        address _wETHGateway,
        address _lendingPoolAddress,
        IAToken _aMATIC,
        uint16 _referralCode,
        address _vrfCoordinator,
        address _LINK,
        bytes32 _keyhash,
        uint256 _fee
    ) Savingotchi(
        _basePrice,
        _router,
        _wETHGateway,
        _lendingPoolAddress,
        _aMATIC,
        _referralCode,
        _vrfCoordinator,
        _LINK,
        _keyhash,
        _fee
    ) { }

    function setTotalSupply(uint256 _totalSupply) external {
        totalSupply = _totalSupply;
    }
}