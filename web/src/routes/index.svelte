<script context="module" lang="ts">
	export const prerender = true;
</script>

<script lang="ts">
</script>

<svelte:head>
	<title>Home</title>
</svelte:head>

<section>
	<div class="card">
		<div class="card_header colorGradient " style="border-radius: 0; background: #ddd">
			<img class="card_header_image ns" alt="Savingotchi" style="padding-left: 10px" src="/images/0.png">
		</div>
		<div class="card_body">
				<div class="price">
					4324 MATIC
				</div>
			<div style="display: flex; justify-content: center; align-items: center;">
				<div style="width: 10px;"></div>
				<button disabled="" class="button">Mint</button>
				<div style="width: 10px;"></div>
			</div>
			<p class="statusText">Mint your Savingotchi</p>
		</div>
		<div class="card_footer" style="background-color: #55143e">
			<button class="button" style="background-color: #ca5824;">Connect Wallet</button>
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
