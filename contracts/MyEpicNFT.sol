// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
	// Keeps track of tokenIds.
	using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;

	// baseSvg variable for all NFTs to use
	string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

	// Random words for NFTszzy
	string[] firstWords = ["Serendipity", "Gobbledygook", "Scrumptious", "Agastopia", "Halfpace", "Impignorate"];
  string[] secondWords = ["Jentacular", "Nudiustertian", "Quire", "Yarborough", "Tittynope", "Ywinklepicker"];
  string[] thirdWords = ["Ulotrichous", "Kakorrhaphiophobia", "Xertz", "Ephemeral", "Kerfuffle", "Skullduggery"];

	// Passes name of NFTs token and it's symbol.
	constructor() ERC721 ("SquareNFT", "SQUARE") {
		console.log("This is my NFT contract. Woah!");
	}

	// Functions to pick random word from each array
	function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
		uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));

		rand = rand % firstWords.length;
		return firstWords[rand];
	}

	function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
		uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
		rand = rand % secondWords.length;
		return secondWords[rand];
	}

	function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
		uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
		rand = rand % thirdWords.length;
		return thirdWords[rand];
	}

	function random(string memory input) internal pure returns (uint256) {
		return uint256(keccak256(abi.encodePacked(input)));
	}

	// Function the will allow users to get their NFT.
	function makeAnEpicNFT() public {
		// Gets the current tokenId. Starts at 0..
		uint256 newItemId = _tokenIds.current();

		// Gets one word from each of the three arrays.
		string memory first = pickRandomFirstWord(newItemId);
		string memory second = pickRandomSecondWord(newItemId);
		string memory third = pickRandomThirdWord(newItemId);
		string memory combinedWord = string(abi.encodePacked(first, second, third));

		// Concatenate all words together to create final Svg
		string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

		// Get all the JSON metadata in place and base64 encode it.
		string memory json = Base64.encode(
			bytes(
				string(
					abi.encodePacked(
						'{"name": "',
							// Set title of NFT to generated word.
							combinedWord,
							'", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
							// Adds data:image/svg+html;base64 and then append base64 encode to svg.
							Base64.encode(bytes(finalSvg)),
						'"}'
					)
				)
			)
		);

		// Prepends data:application/json;base64 to data
		string memory finalTokenUri = string(
			abi.encodePacked("data:application/json;base64,", json)
		);

		console.log("\n--------------------");
		console.log(finalTokenUri);
		console.log("--------------------\n");

		// Mint the NFT to the sender using msg.sender.
		_safeMint(msg.sender, newItemId);

		// Set the NFTs data.
		_setTokenURI(newItemId, "blah");
		
		// Increment the counter for when the next NFT is minted.
		_tokenIds.increment();
		console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
	}
}