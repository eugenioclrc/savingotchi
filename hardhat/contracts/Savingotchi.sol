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
    uint256 public constant BASE_PRICE = 1 ether;
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

    function mint() public payable nonReentrant {
        require(totalSupply < 10000, "Too many Savingotchis");

        uint256 tokenId = _tokenIdCounter.current();
        createVault(tokenId, getBuyPrice());
        // update base increase
        uint256 dec = (block.timestamp - lastBuy) / (1 days);
        if (_baseIncreasePrice <= dec) {
            _baseIncreasePrice = 0;
        } else if (dec > 0) {
            _baseIncreasePrice -= dec;
        }
        _baseIncreasePrice++;

        lastBuy = block.timestamp;

        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        totalSupply++;

        lastEvolve[tokenId] = block.timestamp;
        savingotchiType[tokenId] = SavingotchiType.EGG;
    }

    function sendToEvolve(uint256 _tokenId) external payable {
        require(ownerOf(_tokenId) == msg.sender, "Only owner can evolve a Savingotchi");

        uint256 _evolvePrice = evolvePrice(_tokenId);

        if(_evolvePrice != 0) {
            // comprar link para tirar el random
            vaultAddress(_tokenId).depositAAVE{ value: _evolvePrice }();
        }

        if (msg.value > _evolvePrice) {
            Address.sendValue(payable(msg.sender), msg.value - _evolvePrice);
        }

        _requestRandom(_tokenId);
    }

    // Evolve
    function fulfillRandomness(bytes32 _requestId, uint256 _rnd) internal override {
        uint256 tokenId = requestIdToToken[_requestId];
        _evolve(tokenId, _rnd);
        delete rndOnProcess[tokenId];
        delete requestIdToToken[_requestId];
    }

    function release(uint256 _tokenId) external {
        require(ownerOf(_tokenId) == msg.sender, "Only owner can release a Savingotchi");
        require(stage(_tokenId) == SavingotchiStage.ADULT, "Only adult Savingotchi can be released");
        super._burn(_tokenId);

        vaultAddress(_tokenId).exit();
        delete lastEvolve[_tokenId];
        delete savingotchiType[_tokenId];
    }

    function getBuyPrice() public view returns(uint256) {
        uint256 dec = (block.timestamp - lastBuy) / (1 days);
        if (_baseIncreasePrice <= dec) {
            return BASE_PRICE;
        }

        return (BASE_PRICE * (11500 ** (_baseIncreasePrice - dec))) / 10000;
    }

    function evolvePrice(uint256 tokenId) public view returns(uint256) {
        require(stage(tokenId) != SavingotchiStage.ADULT, "Cannot evolve an adult Savingotchi");
        require(block.timestamp >= (lastEvolve[tokenId] + 7 days), "Can't evolve yet");

        if (block.timestamp >= (lastEvolve[tokenId] + 14 days)) { // free evolve
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