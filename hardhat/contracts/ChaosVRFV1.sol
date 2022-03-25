// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";


abstract contract ChaosVRFV1 is VRFConsumerBase {
    mapping(uint256 => bool) public rndOnProcess;
    mapping(bytes32 => uint256) public requestIdToToken;

    bytes32 internal immutable keyHash;
    uint256 internal immutable fee;

    constructor(
        address _vrfCoordinator,
        address _LINK,
        bytes32 _keyhash,
        uint256 _fee
    ) VRFConsumerBase(_vrfCoordinator, _LINK) {
        keyHash = _keyhash;
        fee = _fee;
    }

    // Assumes the subscription is funded sufficiently.
    function _requestRandom(uint256 _tokenId) internal {
        require(!rndOnProcess[_tokenId], "A random process is running");

        bytes32 requestId = requestRandomness(keyHash, fee);
        requestIdToToken[requestId] = _tokenId;

        rndOnProcess[_tokenId] = true;
    }

    // Callback function used by VRF Coordinator
    function fulfillRandomness(bytes32 _requestId, uint256 _rnd) internal override virtual;
}