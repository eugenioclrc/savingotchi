<script context="module" lang="ts">
	export const prerender = true;
</script>

<script lang="ts">
	import { login, wallet, contract, gotchiFloor, totalSupply } from '$lib/eth.js';
	import { formatEther } from "@ethersproject/units";
	import { onMount } from 'svelte';

	$: typeof window !== 'undefined' ? (window.c = $contract) : null;

	let minting = false;

	
	async function mint() {
		try {
			minting= true;
			const tx = await $contract.mint({ value: $gotchiFloor })
			await tx.wait(0)
			const p = await $contract.getBuyPrice();
			$gotchiFloor = p;
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
			<div style="filter: blur({$gotchiFloor ? 0 : 10}px); text-align: center">
				<div class="price">
					{$gotchiFloor ? formatEther($gotchiFloor) : 'wait...'} MATIC
				</div>
					
				</div>
			<div style="display: flex; justify-content: center; align-items: center;">
				<div style="width: 10px;"></div>
				{#if $wallet}
					<button disabled={minting} class="button" style="font-weight:bold; font-size:18px; color:#fff" on:click={mint}>
						{minting? 'Minting' : 'Mint'}
					</button>
				{/if}
				<div style="width: 10px;"></div>
			</div>
			<p class="statusText" style="text-align: center;">
				Mint your Savingotchi<br/>
				Current supply: {$totalSupply} of 10000 
			</p>
					

		</div>
		<div class="card_footer" style="background-color: #55143e">
			{#if !$wallet}
				<button class="button" style="background-color: #ca5824;" on:click={login}>Connect Wallet</button>
			{:else}
				<span style="color:#fff">{$wallet.slice(0, 6)}...{$wallet.slice(-4)}</span>
			{/if}
		</div>
		<a class="_90" target="_blank" href="https://polygonscan.com/address/0x0" style="position: absolute; bottom: 55px; left: -75px; color: rgb(255, 255, 255);">View Contract</a>
	</div>
	
</section>

<style>

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
