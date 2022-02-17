// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "./SavingotchiStates.sol";

contract Savingotchi is SavingotchiState, ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;

    uint256 public totalSupply;
    uint256 public lastBuy;
    uint256 public BASE_PRICE = 1 ether;
    uint256 private _baseIncreasePrice = 0;

    mapping(uint256 => uint256) public savingotchiValue;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("Savingotchi", "GMI") {}

    function getBuyPrice() public view returns(uint256) {
        uint256 dec = (block.timestamp - lastBuy) / (1 days);
        if (_baseIncreasePrice <= dec) {
            return BASE_PRICE;
        }

        return BASE_PRICE * (11500 ** (_baseIncreasePrice-dec)) / 10000;
    }

    function mint(address to, string memory uri) public payable {
        require(totalSupply < 10000, "Too many Savingotchis");
        uint256 price = getBuyPrice();
        require(msg.value >= price, "Not enought matic");
        // update base increase
        uint256 dec = (block.timestamp - lastBuy) / (1 days);
        if (_baseIncreasePrice <= dec) {
            _baseIncreasePrice = 0;
        } else if (dec > 0) {
            _baseIncreasePrice -= dec;
        }
        _baseIncreasePrice++;
        
        lastBuy = block.timestamp;
        
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        totalSupply++;
        
        savingotchiValue[tokenId] = price;
        lastEvolve[tokenId] = block.timestamp;
        savingotchiType[tokenId] = SavingotchiType.EGG;

        // todo send price to aave
    
        if (msg.value > price) {
            Address.sendValue(payable(msg.sender), msg.value - price);
        }
    }

    function release(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Only owner can release a Savingotchi");
        require(stage(tokenId) == SavingotchiStage.ADULT, "Only adult Savingotchi can be released");
        super._burn(tokenId);
        
        // TODO withdraw eanings from aave and transfer to owner
    }

    function evolve(uint256 tokenId)  external payable {
        require(ownerOf(tokenId) == msg.sender, "Only owner can evolve a Savingotchi");
        require(lastEvolve[tokenId] > (block.timestamp + 7 days), "Can't evolve yet");
        // free evolve
        if (lastEvolve[tokenId] > (block.timestamp + 14 days)) {
            _evolve(tokenId);
        } else {
            uint256 evolvePrice = savingotchiValue[tokenId] * 10 / 100;
            require(msg.value >= evolvePrice, "Not enought matic");
            // TODO this is not safe, must recalculate rewards for all users
            savingotchiValue[tokenId] += evolvePrice;
            
            _evolve(tokenId);

            if (msg.value > evolvePrice) {
                Address.sendValue(payable(msg.sender), msg.value - evolvePrice);
            }
        }
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        totalSupply--;
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}