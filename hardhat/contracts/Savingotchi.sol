// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "./SavingotchiStates.sol";
import "./SavingotchiVaultManager.sol";

contract Savingotchi is SavingotchiState, SavingotchiVaultManager, ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;

    uint256 public constant BASE_PRICE = 1 ether;
    uint256 public totalSupply;
    uint256 public lastBuy;
    uint256 private _baseIncreasePrice;
    mapping(uint256 => Vault) public tokenVaults;

    Counters.Counter private _tokenIdCounter;

    constructor(address _vault) SavingotchiVaultManager(_vault) ERC721("Savingotchi", "GMI") { }

    function getBuyPrice() public view returns(uint256) {
        uint256 dec = (block.timestamp - lastBuy) / (1 days);
        if (_baseIncreasePrice <= dec) {
            return BASE_PRICE;
        }

        return BASE_PRICE * (11500 ** (_baseIncreasePrice - dec)) / 10000;
    }

    function mint(address _to, string memory _uri) public payable {
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
        _mint(_to, tokenId);
        _setTokenURI(tokenId, _uri);
        totalSupply++;

        lastEvolve[tokenId] = block.timestamp;
        savingotchiType[tokenId] = SavingotchiType.EGG;

        createVault(tokenId);

        if (msg.value > price) {
            Address.sendValue(payable(msg.sender), msg.value - price);
        }
    }

    function release(uint256 _tokenId) external {
        require(_isApprovedOrOwner(msg.sender, _tokenId), "Only owner or approved can release a Savingotchi");
        require(stage(_tokenId) == SavingotchiStage.ADULT, "Only adult Savingotchi can be released");

        _burn(_tokenId);
        totalSupply--;

        // estos los borramos?
        _setTokenURI(_tokenId, '');
        delete lastEvolve[_tokenId];
        delete savingotchiType[_tokenId];

        tokenVaults[_tokenId].exit(ownerOf(_tokenId));
        delete tokenVaults[_tokenId];
    }

    function sendToEvolve(uint256 _tokenId) external {
        require(_isApprovedOrOwner(msg.sender, _tokenId), "Only owner or approved can send to evolve a Savingotchi");

        _callRandom();
    }

    function evolve(uint256 _tokenId) external payable {
        require(_isApprovedOrOwner(msg.sender, _tokenId), "Only owner or approved can evolve a Savingotchi");
        require(lastEvolve[_tokenId] > (block.timestamp + 7 days), "Can't evolve yet");
        // free evolve
        if (lastEvolve[_tokenId] > (block.timestamp + 14 days)) {
            _evolve(_tokenId);
        } else {
            uint256 _evolvePrice = evolvePrice(_tokenId);
            require(msg.value >= _evolvePrice, "Not enought matic");
            // comprar link para tirar el random
            _evolve(_tokenId);
            tokenVaults[_tokenId].depositAAVE{value: msg.value}();

            if (msg.value > _evolvePrice) {
                Address.sendValue(payable(msg.sender), msg.value - _evolvePrice);
            }
        }
    }

    function evolvePrice(uint256 _tokenId) public view returns(uint256) {
        if(stage(_tokenId) == SavingotchiStage.ADULT) {
            return 0;
        }
        // conseguir valor de link y sumarle 0.1link (en matic) al valor de la evolucion
        return gotchiValue(_tokenId) * 10 / 100;
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 _tokenId) internal override(ERC721, ERC721URIStorage) {
        totalSupply--;
        super._burn(_tokenId);
    }

    function tokenURI(uint256 _tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(_tokenId);
    }
}