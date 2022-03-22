<script>
	import { login, wallet, contract, gotchiFloor, balance} from '$lib/eth.js';
	import { formatEther, parseEther } from "@ethersproject/units";

	let tokens=[];

	function loadTokens() {
		const items = Number($balance);
		const tokensP = [];
		for(let i = 0; i < items; i++) {
			tokensP.push($contract.tokenOfOwnerByIndex($wallet, i).then(id => {
				return $contract.tokenURI(id).then(uri => {
					return {
						id: id,
						uri: uri
					};
				});
			}));
		}
		Promise.all(tokensP).then(res => {
			res = res.map(data => {
				const ret = JSON.parse(atob(data.uri.replace('data:application/json;base64,', '')).toString());
				ret.id = Number(data.id);
				return ret;
			});
			tokens = [...res];
		});
	}

	$: if($balance) {
		loadTokens();
	}

	let evolving = {};
	let releasing = {};

	async function evolve(tokenId) {
		try {
			evolving[tokenId] = true;
			evolving = {...evolving};
			let tx = await $contract.evolve(tokenId, {value: parseEther("3") });
			await tx.wait();
			loadTokens();
		} catch(err) {
			console.error(err);
		}
		evolving[tokenId] = false;
		evolving = {...evolving};
	}

	async function early(tokenId) {
		releasing[tokenId] = true;
		releasing = {...releasing};
		try {
			if(confirm('Early Access: You will get only a 90% of the total TVL')) {
				await $contract.earlyrelease(tokenId);
			}
		} catch(err) {}
		releasing[tokenId] = false;
		releasing = {...releasing};
	}

	async function release(tokenId) {
		releasing[tokenId] = true;
		releasing = {...releasing};
		try {
			if(confirm('release: You will get only all the TVL, but the Savingothi will be burned')) {
				await $contract.release(tokenId);
			}
		} catch(err) {}
		
		releasing[tokenId] = false;
		releasing = {...releasing};
		
	}
	

	async function addTVL(tokenId) {
		const n = prompt("How many MATICS you want to save?");
		await $contract.addTVL(tokenId, {value: parseEther(n)});

	}
</script>

<div style="display: flex;flex-wrap: wrap;" >
	{#each tokens as e}
		<div class="card" style="margin:10px;{releasing[e.id]?"opacity: 50%" : ''}">
			<div style="font-size: 26px; padding: 10px; text-align: center">
					{e.name}
				</div>
		<div class="card_header colorGradient " style="border-radius: 0; background: #{e.background_color || 'ddd'};">
			<img class="card_header_image ns {evolving[e.id] ? 'shake' : ''}" alt="Savingotchi" style="padding-left: 10px" src={e.image.replace('ipfs://', 'https://cloudflare-ipfs.com/ipfs/')}>
		</div>
		<div class="card_body" style="margin-top: 15px">
			<!--
				<div style="font-size: 20px; padding-bottom: 20px">
					{e.name}
				</div>
			-->
			<div style="display: flex; justify-content: center; align-items: center;">
				<div style="width: 10px;"></div>
					<button style="border-radius:3px; margin:2px; padding:6px 7px;  color:#fff; font-weight:bold" class="button" on:click={() => { addTVL(e.id) } }>
						Add TVL
					</button>
					{#if e.attributes[0].value !== 'ADULT'}
						<button style="border-radius:3px; margin: 2px; padding:6px 7px; background-color: #4b4baf;color: #fff;font-weight: bold;" 
						class="button" on:click={() => { evolve(e.id) }}>
							Evolve
						</button>
						<button style="border-radius:3px; margin: 2px; padding:6px 7px; background-color: #4b4baf;color: #fff;font-weight: bold;" 
						class="button" on:click={() => {early(e.id) }}>
							Early exit
						</button>
					{:else}
						<button style="border-radius:3px; margin: 2px; padding:6px 7px; background-color: #4b4baf;color: #fff;font-weight: bold;" 
						class="button" on:click={() => {release(e.id) }}>
							Release
						</button>
					{/if}
					
				<div style="width: 10px;"></div>
			</div>
			<p class="statusText">
				STAGE: <span style="font-weight: bold">{e.attributes[0].value}</span><br />
				Current TVL: <span style="font-weight: bold">
				{Number(parseFloat((formatEther(String(e.attributes[1].value)))).toFixed(4))} MATIC</span>
			</p>	
		</div>
		<div class="card_footer" style="background-color: #55143e">
			<a class="button" style="background-color: #ca5824;" href="https://testnets.opensea.io/assets/mumbai/0x660c6d095f6d786224d4609d279145038ae78f39/{String(e.id)}">Opensea</a>
			
		</div>
	</div>

	{/each}
</div>

<style>
	.content {
		width: 100%;
		max-width: var(--column-width);
		margin: var(--column-margin-top) auto 0 auto;
	}
</style>
