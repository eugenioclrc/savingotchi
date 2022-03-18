// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

/*
LINK Token	0x326C977E6efc84E512bB9C30f76E30c160eD06FB
VRF Coordinator	0x8C7382F9D8f56b33781fE506E897a4F1e2d17255
Key Hash	0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4
Fee	0.0001 LINK
*/
/**
 * Request testnet LINK and ETH here: https://faucets.chain.link/
 * Find information on LINK Token Contracts and get the latest ETH and LINK faucets here: https://docs.chain.link/docs/link-token-contracts/
 */

abstract contract ChaosVRFV1 is VRFConsumerBase {
    mapping(uint256 => bool) internal onRndProcess;
    mapping(bytes32 => uint256) internal requestIdToToken;

    bytes32 internal keyHash;
    uint256 internal fee;

    /**
     * Constructor inherits VRFConsumerBase
     *
     * Network: Kovan
     * Chainlink VRF Coordinator address: 0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9
     * 0x8C7382F9D8f56b33781fE506E897a4F1e2d17255
     * LINK token address:                0xa36085F69e2889c224210F603D836748e7dC0088
     * 0x326C977E6efc84E512bB9C30f76E30c160eD06FB
     * Key Hash: 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4
     * 0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4
     * 0.1 * 10 ** 18; // 0.1 LINK (Varies by network)
     */
    constructor(address _vrfCoordinator, address _LINK, bytes32 _keyhash, uint256 _fee) VRFConsumerBase(_vrfCoordinator, _LINK) {
        keyHash = _keyhash;
        fee = _fee;
    }

    // Assumes the subscription is funded sufficiently.
    function _requestRandom(uint256 _tokenId) internal {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        require(!onRndProcess[_tokenId], "A random process is running");
        // Will revert if subscription is not set and funded.
        bytes32 requestId = requestRandomness(keyHash, fee);
        requestIdToToken[requestId] = _tokenId;
        onRndProcess[_tokenId] = true;
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 _requestId, uint256 _rnd) internal override virtual;

    // function withdrawLink() external {} - Implement a withdraw function to avoid locking your LINK in the contract
}
