pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Create2.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "./AAVEVault.sol";
import "./ChaosVRFV1.sol";


abstract contract SavVaultManager is ChaosVRFV1 {
    IUniswapV2Router02 private immutable router;
    address[] private path = new address[](2);

    uint256 private immutable MAX_LINK_SPEND;
    uint256 private constant EVOLUTION_LEVELS = 4;

    bytes private VaultCreatioCode;
    bytes32 private immutable VaultBytecodeHash;

    constructor(
        IUniswapV2Router02 _router,
        address _wETHGateway,
        address _lendingPoolAddress,
        IAToken _aMATIC,
        uint16 _referralCode,
        address _vrfCoordinator,
        address _LINK,
        bytes32 _keyhash,
        uint256 _fee
    ) ChaosVRFV1(_vrfCoordinator, _LINK, _keyhash, _fee) {
        router = _router;
        path[0] = _router.WETH();
        path[1] = _LINK;

        MAX_LINK_SPEND = EVOLUTION_LEVELS * _fee;

        VaultCreatioCode = abi.encodePacked(
            type(Vault).creationCode,
            bytes32(uint256(uint160(_wETHGateway))),
            bytes32(uint256(uint160(_lendingPoolAddress))),
            bytes32(uint256(uint160(address(_aMATIC)))),
            uint256(_referralCode)
        );
        VaultBytecodeHash = keccak256(VaultCreatioCode);
    }

    function createVault(uint256 _tokenId, uint256 _price) internal {
        uint256 ethRet = router.swapETHForExactTokens{
            value: msg.value
        }(
            MAX_LINK_SPEND,
            path,
            address(this),
            type(uint256).max
        ) [0];

        Create2.deploy(ethRet, bytes32(_tokenId), VaultCreatioCode);

        if (msg.value > _price) {
            payable(msg.sender).transfer(msg.value - _price);
        }
    }

    function vaultAddress(uint256 _tokenId) public view returns (Vault) {
        return Vault(payable(Create2.computeAddress(bytes32(_tokenId), VaultBytecodeHash)));
    }

    function gotchiValue(uint256 _tokenId) public view returns (uint256) {
        return vaultAddress(_tokenId).aMATICbalance();
    }

    function fulfillRandomness(bytes32 _requestId, uint256 _rnd) internal override virtual;

    // for swapETHForExactTokens
    receive() external payable { }
}
