// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "./SavingotchiStates.sol";
import "./SavingotchiVaultManager.sol";
import "./ChaosVRFV1.sol";

contract Savingotchi is SavingotchiState, SavingotchiVaultManager, ERC721, ERC721Burnable, Ownable, ReentrancyGuard, ChaosVRFV1 {
    using Counters for Counters.Counter;

    uint256 public totalSupply;
    uint256 public lastBuy;
    uint256 public BASE_PRICE = 1 ether;
    uint256 private _baseIncreasePrice = 0;

    Counters.Counter private _tokenIdCounter;

    constructor(
        address _wETHGateway,
        address _lendingPoolAddressesProviderAddress,
        IAToken _aMATIC,
        address _vrfCoordinator,
        address _LINK,
        bytes32 _keyhash,
        uint256 _fee
    )
    SavingotchiVaultManager(_wETHGateway, _lendingPoolAddressesProviderAddress, _aMATIC)
    ERC721("Savingotchi", "GMI")
    ChaosVRFV1(_vrfCoordinator, _LINK, _keyhash, _fee) { }

    function setEvolver(IChaos _evolver) onlyOwner external {
        evolver = _evolver;
    }

    function getBuyPrice() public view returns(uint256) {
        uint256 dec = (block.timestamp - lastBuy) / (1 days);
        if (_baseIncreasePrice <= dec) {
            return BASE_PRICE;
        }

        return (BASE_PRICE * (11500 ** (_baseIncreasePrice - dec))) / 10000;
    }

    function mint() public payable nonReentrant {
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
        _safeMint(msg.sender, tokenId);
        totalSupply++;

        lastEvolve[tokenId] = block.timestamp;
        savingotchiType[tokenId] = SavingotchiType.EGG;
        gen[tokenId] = uint256(blockhash(block.number - 1));

        createVault(tokenId);

        if (msg.value > price) {
            Address.sendValue(payable(msg.sender), msg.value - price);
        }
    }

    function release(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Only owner can release a Savingotchi");
        require(stage(tokenId) == SavingotchiStage.ADULT, "Only adult Savingotchi can be released");
        super._burn(tokenId);

        vaultAddress(tokenId).exit();
        delete lastEvolve[tokenId];
        delete gen[tokenId];
        delete savingotchiType[tokenId];
    }

    function sendToEvolve(uint256 tokenId) external payable {
        require(stage(tokenId) != SavingotchiStage.ADULT, "Cannot evolve an adult Savingotchi");
        require(ownerOf(tokenId) == msg.sender, "Only owner can evolve a Savingotchi");
        require(block.timestamp >= (lastEvolve[tokenId] + 7 days), "Can't evolve yet");

        if (block.timestamp >= (lastEvolve[tokenId] + 14 days)) {// free evolve
            _requestRandom(tokenId);
        } else {
            uint256 _evolvePrice = evolvePrice(tokenId);
            require(msg.value >= _evolvePrice, "Not enought matic");
            // comprar link para tirar el random
            vaultAddress(tokenId).depositAAVE{value: msg.value}();

            _requestRandom(tokenId);

            if (msg.value > _evolvePrice) {
                Address.sendValue(payable(msg.sender), msg.value - _evolvePrice);
            }
        }
    }

    // Evolve
    function fulfillRandomness(bytes32 _requestId, uint256 _rnd) internal override {
        uint256 tokenId = requestIdToToken[_requestId];
        _evolve(tokenId, _rnd);
        delete onRndProcess[tokenId];
        delete requestIdToToken[_requestId];
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
        totalSupply--;
        super._burn(tokenId);
    }
}