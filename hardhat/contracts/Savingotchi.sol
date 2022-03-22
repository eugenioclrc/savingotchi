// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "./SavingotchiStates.sol";
import "./SavingotchiVaultManager.sol";

contract Savingotchi is SavingotchiState, SavingotchiVaultManager, ERC721, ERC721Enumerable, ERC721Burnable, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;

    uint256 public lastBuy;
    uint256 public BASE_PRICE = 1 ether;
    uint256 private _baseIncreasePrice = 0;

    Counters.Counter private _tokenIdCounter;

    constructor() SavingotchiState() SavingotchiVaultManager (/* _vault*/) ERC721("Savingotchi", "GMI") {
    }

    function setEvolver(address evolver_) onlyOwner external {
        evolver = IChaos(evolver_);
    }

    function getBuyPrice() public view returns(uint256) {
        uint256 dec = (block.timestamp - lastBuy) / (1 days);
        if (_baseIncreasePrice <= dec) {
            return BASE_PRICE;
        }

        return BASE_PRICE * (11500 ** (_baseIncreasePrice-dec)) / 10000;
    }

    function mint() nonReentrant public payable {
        require(totalSupply() < 10000, "Too many Savingotchis");
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
        _safeMint(msg.sender, tokenId);
        
        lastEvolve[tokenId] = block.timestamp;
        savingotchiType[tokenId] = SavingotchiType.EGG;
        gen[tokenId] = uint256(blockhash(block.number - 1));
  
        createVault(tokenId);
        
        // if (msg.value > price) {
        //     Address.sendValue(payable(msg.sender), msg.value - price);
        // }
    }

    function earlyrelease(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Only owner can release a Savingotchi");
        super._burn(tokenId);
        
        tokenVaults[tokenId].earlyexit(msg.sender);
        delete tokenVaults[tokenId];
        delete lastEvolve[tokenId];
        delete gen[tokenId];
        delete savingotchiType[tokenId];
    }

    function release(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Only owner can release a Savingotchi");
        require(stage(tokenId) == SavingotchiStage.ADULT, "Only adult Savingotchi can be released");
        super._burn(tokenId);
        
        tokenVaults[tokenId].exit(msg.sender);
        delete tokenVaults[tokenId];
        delete lastEvolve[tokenId];
        delete gen[tokenId];
        delete savingotchiType[tokenId];
    }

    function evolve(uint256 tokenId) external payable {
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

    function _burn(uint256 tokenId) internal override(ERC721) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721)
        returns (string memory)
    {
        
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                      abi.encodePacked(
                        "{\"name\":\"",
                        names[uint256(savingotchiType[tokenId])], // You can add whatever name here
                        "\", \"image\":\"",
                        genImage(tokenId),
                        "\",\"attributes\": [",
                        "{\"trait_type\": \"Stage\",\"value\":\"",
                        _stages[uint256(stage(tokenId))],"\"},",
                        "{\"trait_type\": \"number\",\"value\":",
                        Strings.toString(gotchiValue(tokenId)),"}",
                        "]}"
                      )
                    )
                )
            )
        );
    }

    function uint8ToHexCharCode(uint8 i) public pure returns (uint8) {
        return (i > 9) ?
            (i + 87) : // ascii a-f
            (i + 48); // ascii 0-9
    }


    function uint24ToHexStr(uint24 i) internal pure returns (string memory) {
        bytes memory o = new bytes(6);
        uint24 mask = 0x00000f; // hex 15
        uint k = 6;
        do {
            k--;
            o[k] = bytes1(uint8ToHexCharCode(uint8(i & mask)));
            i >>= 4;
        } while (k > 0);
        return string(o);
    }

    function genImage(uint256 tokenId) public view returns (string memory) {
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(
                    bytes(
                      abi.encodePacked(
                          "<svg width=\"500\" height=\"500\" xmlns=\"http://www.w3.org/2000/svg\" style=\"background-color:",
                          //uint24ToHexStr(uint24(gen[tokenId])),
                          "#ffffff",
                          "\"><image style=\"image-rendering:pixelated\" href=\"",
                          images[uint256(savingotchiType[tokenId])],"\" height=\"500\" width=\"500\"/></svg>"
                      )
                    )
                )
            )
        );
    }

     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
