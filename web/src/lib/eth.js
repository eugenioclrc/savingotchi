/*
// eslint-disable-next-line @typescript-eslint/no-explicit-any
declare let window: any;
*/


import { derived, writable, get } from "svelte/store";

// import ABIS from "./abi";

import { BigNumber } from "@ethersproject/bignumber";
import { Web3Provider } from "@ethersproject/providers";
import { Contract } from "@ethersproject/contracts";

import ABI from './savingotchi.abi.json';

const CHAIN_ID = 80001; // 31337
// const CHAIN_ID = 31337;
const HEXCHAIN_ID = "0x"+CHAIN_ID.toString(16);

const savingotchiAddress = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";
let savingotchi;

export const contract = writable(null);
export const connected = writable(false);
export const wallet = writable(null);
export const provider = writable(null);
export const signer = writable(null);
export const networkDetails = writable({});
export const wrongNetwork = writable(false);
export const gotchiFloor = writable(0);
export const balance = writable(0);
export const totalSupply = writable(0);


let _provider;


let eventHooks = false;

export default async function init() {
  // const { ethereum } = window;
  // await window.ethereum.enable()
  if (!_provider) {
    _provider = new Web3Provider(window.ethereum, "any");
    provider.set(_provider);
    _provider.on("network", (newNetwork, oldNetwork) => {
      if (oldNetwork) {
        setTimeout(() => {
          init();
        }, 0);
      }
    });

    window.ethereum.on("accountsChanged", () => {
      setTimeout(() => {
        document.location.reload();
        // init();
      }, 0);
    });
  }
  
  const _signer = await _provider.getSigner();
  const _wallet = await _signer.getAddress();
  wallet.set(_wallet);
  signer.set(_signer);
  
  const _networkDetails = await _provider.getNetwork();
  networkDetails.set(_networkDetails);
  // if (_networkDetails.name !== "bnbt") {
  // if (_networkDetails.chainId !== 31337) {
  // console.log(_networkDetails);
  if (_networkDetails.chainId !== CHAIN_ID) {
    wrongNetwork.set(true);
    await changeNetwork();
    return;
  } else {
    wrongNetwork.set(false);
  }

  if (_wallet) {
    savingotchi = savingotchi ? savingotchi.connect(_signer) : new Contract(savingotchiAddress, ABI, _signer);
    contract.set(savingotchi);
    totalSupply.set(await savingotchi.totalSupply());
    balance.set(await savingotchi.balanceOf(_wallet));
    savingotchi.getBuyPrice().then(p => {
      gotchiFloor.set(p);
    })
  }
  if (!savingotchi) {
    return;
  }

  /*  
  const BN = (el) => BigNumber.from(el);
  const eCpM = await Promise.all([
    gameContract.effectiveCPB(BN("0"), BN("1000")),
    gameContract.effectiveCPB(BN("1"), BN("1")),
    gameContract.effectiveCPB(BN("2"), BN("1")),
    gameContract.effectiveCPB(BN("3"), BN("1")),
    gameContract.effectiveCPB(BN("4"), BN("1")),
    gameContract.effectiveCPB(BN("5"), BN("1")),
  ]);
  console.log(eCpM);
  */
  

  loadContractHooks();
}

const reloadPrice = debounce(async() =>{
  try {
    const p = await savingotchi.getBuyPrice();
    gotchiFloor.set(p);

  } catch(err) {}
}, 5000);

function loadContractHooks() {
  if (eventHooks) {
    return;
  }

  savingotchi.on("Transfer", async (from, to /*, amount, event */) => {
    const $wallet = await get(wallet);
    if(to == $wallet || from ==$wallet) {
      savingotchi.balanceOf($wallet).then(b => {
        balance.set(b);
      });
    }
    totalSupply.set(await savingotchi.totalSupply());
    reloadPrice();
  });
  
  /*
  achvContract.on("AchievementMint", async (_wallet, _achvId, _achvType) => {
    const $wallet = await get(wallet);
    if (_wallet === $wallet) {
      const url = await achvContract.tokenURI(_achvId);
      const item = JSON.parse(window.atob(url.split(",")[1]));
      // <img src="${item.image.replace('ipfs://', 'https://cloudflare-ipfs.com/ipfs/')}" />
      toast.push(
        `
      <div class="inline-block">
        <img src="/achievements/${dataAchievements[_achvType].image}" />
      </div>
      <div class="text">
        <h3 class="text-sm">Achievement unlocked</h3>
        <div class="line"></div>
        <h5><div class="title" style="font-size:18px;margin-top:-2px;">${item.name}</div></h5>
      </div>
    `,
        { target: "new", initial: 0, dismissable: true, intro: { y: 10 } }
      );
    }
  });
  
  // seteo contratos hooks
  gameContract.on("WarehouseChange", async (_wallet /*, amount, event * /) => {
    const $wallet = await get(wallet);
    if (_wallet === $wallet) {
 
export const pendingRewards = derived(
  [CpM, currentTime, lastRefreshTime, rewards, storageSize, isApprove],
  ([$CpM, $currentTime, $lastRefreshTime, $rewards, $storageSize, $isApprove]) => {
    if (typeof window === "undefined") {
      return BigNumber.from(0);
    }
    if(!$isApprove) {
      return BigNumber.from(0);
    }

    if ($CpM) {
      /*
      const deltaSegs = Math.max(
        0,
        Math.floor(($currentTime - $lastRefreshTime))
      );
      const _pendingRewards = 
        BigNumber.from($rewards).add($CpM.mul(deltaSegs).div(60*1000));
        if ($storageSize.lt(_pendingRewards)) {
          return $storageSize;
        }
        return _pendingRewards;
        * /
      if ($storageSize.lt($rewards)) {
        return $storageSize;
      }
      return $rewards;
    } else if ($rewards) {
      if ($storageSize.lt($rewards)) {
        return $storageSize;
      }
      return $rewards;
    }
    return 0;
  }
);

export const storageSizePct = derived(
  [storageSize, pendingRewards],
  ([$storageSize, $pendingRewards]) => {
    if (typeof window === "undefined") {
      return 0;
    }
    if($pendingRewards === 0) {
      return 0;
    }
    if($pendingRewards.eq("0")) {
      return 0;
    }

    return BigNumber.from($pendingRewards).gt(0)
      ? Math.ceil(($pendingRewards * 1000) / $storageSize) / 10
      : 0;
  }
);


function debounce(func, wait) {
  var timeout;

  return function executedFunction() {
    var context = this;
    var args = arguments;
	
    const later = async function(resolve) {
      timeout = null;
      await func.apply(context, args);
      resolve();
    };

    clearTimeout(timeout);

    return new Promise(function(resolve, reject) {  
      timeout = setTimeout(() => later(resolve), wait);
    });
  };
}

  items1155.on("TransferSingle", async (operator, from, to, id, value) => {
    const $wallet = await get(wallet);
    if(from === $wallet || to === $wallet) {
      fullGameUpdate();
    }
  });

  items1155.on("TransferBatch", async (operator, from, to, ids, values) => {
    const $wallet = await get(wallet);
    if (from === $wallet || to === $wallet) {
      fullGameUpdate();
    }
  });

  items1155.on("Upgrade", async (account, itemId, upgradeNumber) => {
    const $wallet = await get(wallet);
    if (account === $wallet) {
      fullGameUpdate();
    }
  });

  cookieToken.on("Approval", async (owner, spender, val) => {
    const $wallet = await get(wallet);
    if (owner === $wallet) {
      const allowance = await cookieToken.allowance($wallet, gameAddress);
      isApprove.set(allowance.gt(1e9));
    }
  });

  cookieToken.on("Transfer", async (from, to /*, amount, event * /) => {
    const $wallet = await get(wallet);
    if (from === $wallet || to === $wallet) {
      cookieBalance.set(await cookieToken.balanceOf($wallet));
    }
  });
  */
  
}




export async function login() {
  try {
    await window.ethereum.enable();
  } catch(err) {
  }
  await init();
}

export async function changeNetwork() {
  // await window.ethereum.request({ method: "wallet_switchEthereumChain", params:[{chainId: "0x7A69"}]});  
  // await window.ethereum.request({ method: "wallet_switchEthereumChain", params:[{chainId: HEXCHAIN_ID}]});
  await window.ethereum.request({
    method: "wallet_addEthereumChain",
    params: [
      {
        chainId: HEXCHAIN_ID,
        chainName: "Mumbai polygon testnet",
        nativeCurrency: {
          name: "Matic",
          symbol: "MATIC",
          decimals: 18,
        },
        rpcUrls: ["https://matic-mumbai.chainstacklabs.com"],
        blockExplorerUrls: ["https://mumbai.polygonscan.com/"],
      }]
  });
  // document.location.reload();
  
  /*
  await window.ethereum.request({
    method: "wallet_addEthereumChain",
    params: [
      {
        chainId: `0x${(97).toString(16)}`,
        chainName: "TEST Binance Smart Chain",
        nativeCurrency: {
          name: "BNB",
          symbol: "bnb",
          decimals: 18,
        },
        rpcUrls: ["https://data-seed-prebsc-1-s1.binance.org:8545/"],
        blockExplorerUrls: ["https://testnet.bscscan.com/"],
        // rpcUrls: ['https://bsc-dataseed.binance.org/'],
        // blockExplorerUrls: ['https://bscscan.com/'],
      },
    ],
  });
  */
}

function debounce(func, wait) {
  var timeout;

  return function executedFunction() {
    var context = this;
    var args = arguments;
	
    const later = async function(resolve) {
      timeout = null;
      await func.apply(context, args);
      resolve();
    };

    clearTimeout(timeout);

    return new Promise(function(resolve, reject) {  
      timeout = setTimeout(() => later(resolve), wait);
    });
  };
}
