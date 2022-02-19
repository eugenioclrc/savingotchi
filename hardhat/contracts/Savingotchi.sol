// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "./SavingotchiStates.sol";
import "./SavingotchiVaultManager.sol";

contract Savingotchi is SavingotchiState, SavingotchiVaultManager, ERC721, ERC721URIStorage, ERC721Burnable, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;

    uint256 public totalSupply;
    uint256 public lastBuy;
    uint256 public BASE_PRICE = 1 ether;
    uint256 private _baseIncreasePrice = 0;

    Counters.Counter private _tokenIdCounter;

    constructor(address _vault) SavingotchiVaultManager(_vault) ERC721("Savingotchi", "GMI") {
    }

    function getBuyPrice() public view returns(uint256) {
        uint256 dec = (block.timestamp - lastBuy) / (1 days);
        if (_baseIncreasePrice <= dec) {
            return BASE_PRICE;
        }

        return BASE_PRICE * (11500 ** (_baseIncreasePrice-dec)) / 10000;
    }

    function mint(address to, string memory uri) nonReentrant() public payable {
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
        
        lastEvolve[tokenId] = block.timestamp;
        savingotchiType[tokenId] = SavingotchiType.EGG;
        gen[tokenId] = uint256(blockhash(block.number - 1));
  

        createVault(tokenId);
        
        if (msg.value > price) {
            Address.sendValue(payable(msg.sender), msg.value - price);
        }
    }

    function release(uint256 tokenId) nonReentrant() external {
        require(ownerOf(tokenId) == msg.sender, "Only owner can release a Savingotchi");
        require(stage(tokenId) == SavingotchiStage.ADULT, "Only adult Savingotchi can be released");
        super._burn(tokenId);
        
        tokenVaults[tokenId].exit();
        delete tokenVaults[tokenId];
        delete lastEvolve[tokenId];
        delete gen[tokenId];
        delete savingotchiType[tokenId];
    }

    function evolve(uint256 tokenId) nonReentrant() external payable {
        require(ownerOf(tokenId) == msg.sender, "Only owner can evolve a Savingotchi");
        require(lastEvolve[tokenId] > (block.timestamp + 7 days), "Can't evolve yet");
        // free evolve
        if (lastEvolve[tokenId] > (block.timestamp + 14 days)) {
            _evolve(tokenId);
        } else {
            uint256 _evolvePrice = evolvePrice(tokenId);
            require(msg.value >= _evolvePrice, "Not enought matic");
            // comprar link para tirar el random
            _evolve(tokenId);
            tokenVaults[tokenId].depositAAVE{value: msg.value}();

            if (msg.value > _evolvePrice) {
                Address.sendValue(payable(msg.sender), msg.value - _evolvePrice);
            }
        }
    }

    function evolvePrice(uint256 tokenId) public view returns(uint256) {
        if(stage(tokenId) == SavingotchiStage.ADULT) {
            return 0;
        }
        // conseguir valor de link y sumarle 0.1link (en matic) al valor de la evolucion
        return gotchiValue(tokenId) * 10 / 100;
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