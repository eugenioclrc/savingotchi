// SPDX-License-Identifier: MIT
// An example of a consumer contract that relies on a subscription for funding.
// Take it from https://docs.chain.link/docs/get-a-random-number/

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

interface ISavingotchi {
  function evolveStep2(uint256 tokenId, uint256 rnd) external;
}

contract Chaos is VRFConsumerBaseV2, Ownable {
  VRFCoordinatorV2Interface COORDINATOR;
  LinkTokenInterface LINKTOKEN;

  // Your subscription ID.
  uint64 s_subscriptionId;

  // Rinkeby coordinator. For other networks,
  // see https://docs.chain.link/docs/vrf-contracts/#configurations
  address vrfCoordinator = 0x6168499c0cFfCaCD319c818142124B7A15E857ab;

  // Rinkeby LINK token contract. For other networks,
  // see https://docs.chain.link/docs/vrf-contracts/#configurations
  address link = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;

  // The gas lane to use, which specifies the maximum gas price to bump to.
  // For a list of available gas lanes on each network,
  // see https://docs.chain.link/docs/vrf-contracts/#configurations
  bytes32 keyHash = 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc;

  // Depends on the number of requested values that you want sent to the
  // fulfillRandomWords() function. Storing each word costs about 20,000 gas,
  // so 100,000 is a safe default for this example contract. Test and adjust
  // this limit based on the network that you select, the size of the request,
  // and the processing of the callback request in the fulfillRandomWords()
  // function.
  uint32 callbackGasLimit = 100000;

  // The default is 3, but you can set this higher.
  uint16 requestConfirmations = 3;

  // For this example, retrieve 2 random values in one request.
  // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
  uint32 constant numWords =  1;

  mapping(uint256 => uint256) internal tokenTorequestId;
  mapping(uint256 => uint256) internal requestIdToToken;

  ISavingotchi public savingotchi;

  constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
    COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
    LINKTOKEN = LinkTokenInterface(link);
    s_subscriptionId = subscriptionId;
  }

  function setSavigotchi(ISavingotchi savingotchi_) onlyOwner external {
    savingotchi = savingotchi_;
  }


  // Assumes the subscription is funded sufficiently.
  function requestRandomWords(uint256 tokenId) external {
    require(msg.sender == address(savingotchi), "Only savingotchi can call this function");
    require(tokenTorequestId[tokenId] == 0, "A random process is running");
    // Will revert if subscription is not set and funded.
    tokenTorequestId[tokenId] = COORDINATOR.requestRandomWords(
      keyHash,
      s_subscriptionId,
      requestConfirmations,
      callbackGasLimit,
      numWords
    );

    requestIdToToken[tokenTorequestId[tokenId]] = tokenId;
  }
  
  function fulfillRandomWords(
    uint256 requestId,
    uint256[] memory randomWords
  ) internal override { 
    delete tokenTorequestId[requestIdToToken[requestId]];
    delete requestIdToToken[requestId];
    savingotchi.evolveStep2(requestIdToToken[requestId], randomWords[0]);
  }

}
