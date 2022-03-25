// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./SavState.sol";
import "./SavVaultManager.sol";


contract Savingotchi is SavState, SavVaultManager, ERC721, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;
    using Address for address;

    uint256 public totalSupply;
    uint256 public lastBuy;
    uint256 public baseIncreasePrice;
    uint256 public ownerLinkBal;

    uint256 public immutable BASE_PRICE;

    Counters.Counter private _tokenIdCounter;

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
    ) ERC721("Savingotchi", "GMI") SavVaultManager(
        _router,
        _wETHGateway,
        _lendingPoolAddress,
        _aMATIC,
        _referralCode,
        _vrfCoordinator,
        _LINK,
        _keyhash,
        _fee
    ) {
        BASE_PRICE = _basePrice;
    }

    function withdrawLink() onlyOwner external {
        LINK.transfer(owner(), ownerLinkBal);
        delete ownerLinkBal;
    }

    function withdrawETH() onlyOwner external {
        payable(owner()).transfer(address(this).balance);
    }

    function mint() public payable {
        require(totalSupply < 10000, "Too many Savingotchis");

        uint256 tokenId = _tokenIdCounter.current();
        createVault(tokenId, getBuyPrice());

        // update base increase
        uint256 dec = (block.timestamp - lastBuy) / (1 days);
        if (baseIncreasePrice <= dec) {
            baseIncreasePrice = 0;
        } else if (dec > 0) {
            baseIncreasePrice -= dec;
        }
        baseIncreasePrice++;

        lastBuy = block.timestamp;

        lastEvolve[tokenId] = block.timestamp;
        savingotchiType[tokenId] = SavingotchiType.EGG;

        _tokenIdCounter.increment();
        totalSupply++;

        _safeMint(msg.sender, tokenId);
    }

    function sendToEvolve(uint256 _tokenId) external payable {
        require(ownerOf(_tokenId) == msg.sender, "Only owner can evolve a Savingotchi");

        uint256 _evolvePrice = evolvePrice(_tokenId);

        if(_evolvePrice != 0) {
            // comprar link para tirar el random
            vaultAddress(_tokenId).depositAAVE{ value: _evolvePrice }();
        }

        _requestRandom(_tokenId);

        if (msg.value > _evolvePrice) {
            payable(msg.sender).transfer(msg.value - _evolvePrice);
        }
    }

    // Evolve
    function fulfillRandomness(bytes32 _requestId, uint256 _rnd) internal override {
        uint256 tokenId = requestIdToToken[_requestId];
        if(_evolve(tokenId, _rnd)) {
            ownerLinkBal += fee;
        }

        delete rndOnProcess[tokenId];
        delete requestIdToToken[_requestId];
    }

    function release(uint256 _tokenId) external {
        require(ownerOf(_tokenId) == msg.sender, "Only owner can release a Savingotchi");
        require(stage(_tokenId) == SavingotchiStage.ADULT, "Only adult Savingotchi can be released");

        totalSupply--;
        super._burn(_tokenId);

        vaultAddress(_tokenId).exit(msg.sender);

        delete lastEvolve[_tokenId];
        delete savingotchiType[_tokenId];
    }

    function getBuyPrice() public view returns(uint256) {
        uint256 dec = (block.timestamp - lastBuy) / (1 days);
        if (baseIncreasePrice <= dec) {
            return BASE_PRICE;
        }

        return (BASE_PRICE * (11500 ** (baseIncreasePrice - dec))) / 10000;
    }

    function evolvePrice(uint256 tokenId) public view returns(uint256) {
        require(stage(tokenId) != SavingotchiStage.ADULT, "Cannot evolve an adult Savingotchi");
        require(block.timestamp >= (lastEvolve[tokenId] + 7 days), "Can't evolve yet");

        if (block.timestamp >= (lastEvolve[tokenId] + 14 days)) { // free evolve
            return 0;
        }

        return (gotchiValue(tokenId) * 10) / 100;
    }
}