//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./AAVEInterfaces.sol";


contract Vault is Ownable {
    IWETHGateway public immutable WETHGateway;
    ILendingPoolAddressesProvider public immutable lendingPoolAddress;
    IAToken public immutable aMATIC;
    IWMATIC public immutable wMATIC;
    uint16 public immutable referralCode;

    constructor(
        IWETHGateway _WETHGateway,
        ILendingPoolAddressesProvider _lendingPoolAddress,
        IAToken _aMATIC,
        uint16 _referralCode
    ) payable {
        WETHGateway = _WETHGateway;
        wMATIC = IWMATIC(_WETHGateway.getWETHAddress());

        lendingPoolAddress = _lendingPoolAddress;

        aMATIC = _aMATIC;
        _aMATIC.approve(address(_WETHGateway), type(uint).max);

        referralCode = _referralCode;

        // depositAAVE()
        _WETHGateway.depositETH{
            value: msg.value
        }(
            _lendingPoolAddress.getLendingPool(), // pool
            address(this), // address whom will receive the aWETH
            _referralCode // referralCode
        );
    }

    function depositAAVE() external payable {
        WETHGateway.depositETH{
            value: msg.value
        }(
            seeLendingPool(), // pool
            address(this), // address whom will receive the aWETH
            referralCode // referralCode
        );
    }

    function exit(address _to) external onlyOwner {
        uint256 _amount = aMATIC.balanceOf(address(this));

        // return to erc721 owner
        ILendingPool(seeLendingPool()).withdraw(
            address(wMATIC),
            _amount,
            _to
        );



        // aave incentives = 0xd41ae58e803edf4304334acce4dc4ec34a63c644
        // 0xd41ae58e803edf4304334acce4dc4ec34a63c644
        // IIncentivesController(incentivesController).claimRewards(assets, type(uint).max, address(this));

        // TODO selfdestruct y claim withdraws
        // see https://github.com/beefyfinance/beefy-contracts/blob/master/contracts/archive/strategies/Aave/StrategyAaveMatic.sol


        selfdestruct(payable(msg.sender));

        //wMATIC.withdraw(_amount);
    }

    function aMATICbalance() external view returns(uint256){
        return aMATIC.balanceOf(address(this));
    }

    function seeLendingPool() public view returns (address){
        return lendingPoolAddress.getLendingPool();
    }

    receive() external payable { }
}