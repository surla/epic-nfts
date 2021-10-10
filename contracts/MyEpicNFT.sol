// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract MyEpicNFT is ERC721URIStorage {
	// Keeps track of tokenIds.
	using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;

	// Passes name of NFTs token and it's symbol.
	constructor() ERC721 ("SquareNFT", "SQUARE") {
		console.log("This is my NFT contract. Woah!");
	}

	// Function the will allow users to get their NFT.
	function makeAnEpicNFT() public {
		// Gets the current tokenId. Starts at 0..
		uint256 newItemId = _tokenIds.current();

		// Mint the NFT to the sender using msg.sender.
		_safeMint(msg.sender, newItemId);

		// Set the NFTs data.
		_setTokenURI(newItemId, "https://jsonkeeper.com/b/4XWC");
		console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

		// Increment the counter for when the next NFT is minted.
		_tokenIds.increment();
	}
}