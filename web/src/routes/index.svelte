<script context="module" lang="ts">
	export const prerender = true;
</script>

<script lang="ts">
	//import { login } from '$lib/eth.ts';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
declare let window: any;

const ADDRESS = "0x10a27aD13Ed8662B2845E7c329FE14B8f7647f8D";

import ABI from "$lib/savingotchi.abi";

let contract;
let minting = false;

let value = 0;

	import { ethers, utils } from 'ethers';
import { formatEther } from "ethers/lib/utils";
	import { onMount } from 'svelte';
	let hasMetamask = false;
	let connected = false;
	let address;
	let balance;
	let chain;
	let blockNumber;
	onMount(async () => {
		if (window.ethereum) {
			hasMetamask = true;
			chain = new ethers.providers.Web3Provider(window.ethereum);
			blockNumber = await chain.getBlockNumber();
			connected = true;
			await requestAccounts();
			window.ethereum.on('accountsChanged', onAccountsChanged);
		}
	});


	async function onAccountsChanged(accounts) {
		address = accounts[0];
		balance = await chain.getBalance(address);
		const signer = await chain.getSigner();

		contract = new ethers.Contract(ADDRESS, ABI, signer);

		value = await contract.getBuyPrice();
		value = value.mul('120').div('100');
	}
	async function requestAccounts() {
		if (hasMetamask) {
			const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
			if (accounts) {
				await onAccountsChanged(accounts);
			}
		}
	}

	async function mint() {
		try {
			minting= true;
			await contract.mint({ value })
		} catch (err) {
			console.error(err);
		}
		minting = false;
	}
</script>

<svelte:head>
	<title>Home</title>
</svelte:head>

<section>
	<div class="card">
		<div class="card_header colorGradient " style="border-radius: 0; background: #ddd">
			<img class="card_header_image ns {minting ? 'shake' : ''}" alt="Savingotchi" style="padding-left: 10px" src="/images/0.png">
		</div>
		<div class="card_body">
				<div class="price" style="filter: blur({value ? 0 : 10}px)">
					{value ? ethers.utils.formatEther(value) : 'wait...'} MATIC
				</div>
			<div style="display: flex; justify-content: center; align-items: center;">
				<div style="width: 10px;"></div>
				{#if address}
					<button enabled={!minting} class="button" on:click={mint}>
						{minting? 'Minting' : 'Mint'}
					</button>
				{/if}
				<div style="width: 10px;"></div>
			</div>
			<p class="statusText">Mint your Savingotchi</p>
		</div>
		<div class="card_footer" style="background-color: #55143e">
			{#if !address}
				<button class="button" style="background-color: #ca5824;" on:click={() => login}>Connect Wallet</button>
			{:else}
				<span style="color:#fff">{address.slice(0, 6)}...{address.slice(-4)}</span>
			{/if}
		</div>
		<a class="_90" target="_blank" href="https://polygonscan.com/address/0x0" style="position: absolute; bottom: 55px; left: -75px; color: rgb(255, 255, 255);">View Contract</a>
	</div>
	
</section>

<style>

img.shake {
  /* Start the shake animation and make the animation last for 0.5 seconds */
  animation: shake 0.5s;

  /* When the animation is finished, start again */
  animation-iteration-count: infinite;
}

@keyframes shake {
  0% { transform: translate(1px, 1px) rotate(0deg); }
  10% { transform: translate(-1px, -2px) rotate(-1deg); }
  20% { transform: translate(-3px, 0px) rotate(1deg); }
  30% { transform: translate(3px, 2px) rotate(0deg); }
  40% { transform: translate(1px, -1px) rotate(1deg); }
  50% { transform: translate(-1px, 2px) rotate(-1deg); }
  60% { transform: translate(-3px, 1px) rotate(0deg); }
  70% { transform: translate(3px, 1px) rotate(-1deg); }
  80% { transform: translate(-1px, -1px) rotate(1deg); }
  90% { transform: translate(1px, 2px) rotate(0deg); }
  100% { transform: translate(1px, -2px) rotate(-1deg); }
}
	.price {
				display: flex;
				width: 100%;
				height: 100%;
				font-weight: 400;
				color: var(--accent-color);
				font-size: 2rem;
				align-items: center;
				justify-content: center;
	}
._90 {
	position: absolute; bottom: 55px; left: -75px; color: rgb(255, 255, 255);
	transform: rotate(-90deg);

}
/* .colorGradient {
		background: linear-gradient(to bottom right,#9fcfff,#fdafab,#ffc49f,#ffe3b0,#a5ffcd,#b3eeff,#c2b1ff,#ffcfca);
    background-repeat: no-repeat;
    background-size: 800% 800%;
    animation: gradient 12s ease infinite;
	} */

	.button {
		display: inline-block;
    padding: 7px 14px;
    font-size: 14px;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    outline: none;
    color: #fff;
    color: var(--button-text);
    background-color: #2fc422;
    border: none;
    border-radius: 15px;
    margin-top: 30px;
    margin-bottom: 2px;
	}
.card {
  background-color:#fff;
  display: flex;
  flex-direction: column;
  box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
  border-radius: 15px;
  width: 300px;
  transition: 0.3s;
  margin: 30px;
  margin-top: 100px;
  position: relative;
}

.card:hover {
  box-shadow: 0 8px 16px 0 rgba(0, 0, 0, 0.2);
}

.card_header {
  height: 250px;
  width: 300px;
  border-radius: 25px;
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
  border-top-left-radius: 15px;
  border-top-right-radius: 15px;
  position: relative;
}

.card_header_image {
  position: absolute;
  width: 100%;
  image-rendering: auto;
  image-rendering: crisp-edges;
  image-rendering: pixelated;
}

.card_body {
  padding: 15px;
  margin-top: 30px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.card_body_view_contract {
  padding-right: 15px;
  padding-left: 15px;
}

.card_footer {
  border-bottom-left-radius: 15px;
  border-bottom-right-radius: 15px;
  padding: 15px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

	section {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		flex: 1;
	}

	h1 {
		width: 100%;
	}

	.welcome {
		position: relative;
		width: 100%;
		height: 0;
		padding: 0 0 calc(100% * 495 / 2048) 0;
	}

	.welcome img {
		position: absolute;
		width: 100%;
		height: 100%;
		top: 0;
		display: block;
	}
</style>
