pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract TestToken is ERC20("Test Token", "TEST") {
    function mint(address _to, uint256 _value) external {
        _mint(_to, _value);
    }

    function burn(address _account, uint256 _value) external {
        _burn(_account, _value);
    }

    function setBalance(address _account, uint256 _value) external {
        uint256 balance = balanceOf(_account);

        if (balance == _value) {
            return;
        }

        if (_value > balance) {
            _mint(_account, _value - balance);
        } else {
            _burn(_account, balance - _value);
        }
    }
}