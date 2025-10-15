NFT Scavenger Hunt Smart Contract
Overview
This project is a fully on-chain Scavenger Hunt game built with Solidity. Players are presented with a series of riddles. By solving all of them in order, a participant can win a unique, non-fungible token (NFT) as a reward.

The smart contract is designed to be simple, efficient, and self-contained. It features a custom, ERC721-like implementation for the NFT reward and initializes the game's state on the first player interaction, a unique approach that works around the absence of a constructor.

Features
Decentralized Gameplay: The entire game logic, including clues and progress tracking, is managed by the smart contract on the blockchain.

NFT Rewards: Successful players are rewarded with a unique "Scavenger Hunt Champion" (SHC) token.

Secure Answer Verification: Answers to the riddles are stored as keccak256 hashes, preventing them from being easily read from the contract's storage.

Singleton Winner: Each address can only complete the scavenger hunt and claim an NFT once.

Constructor-less Design: The game clues are initialized on the first valid submitAnswer call, making the contract setup seamless upon first use.

How to Play
Deploy the Contract: Deploy the NFTScavengerHunt.sol contract to any Ethereum-compatible blockchain.

Get the First Clue: Call the getCurrentClue() function to retrieve the question for your current stage. Initially, this will be the first riddle.

Submit Your Answer: Once you've solved the riddle, call the submitAnswer(string memory _answer) function with your answer as the input. Note: Answers are case-sensitive.

Check Your Progress:

If your answer is correct, your progress will be saved, and the next time you call getCurrentClue(), you will receive the next riddle.

If your answer is incorrect, the transaction will revert with the message "That's not the right answer. Try again!".

Win the NFT: After correctly submitting the answer to the final clue, a unique NFT will be automatically minted and transferred to your wallet. You can verify your ownership by calling balanceOf(your_address) or ownerOf(tokenId).

Smart Contract Functions
Game Logic
getCurrentClue() public view returns (string memory): Returns the current riddle the player needs to solve. Reverts if the player has already completed the hunt.

submitAnswer(string memory _answer) public: Allows a player to submit a potential answer. If correct, it advances the player's progress or mints an NFT on the final clue.

NFT (ERC721-Like) Functions
name() public view returns (string): Returns the name of the NFT collection ("Scavenger Hunt Champion").

symbol() public view returns (string): Returns the symbol of the NFT collection ("SHC").

balanceOf(address owner) public view returns (uint256): Returns the number of NFTs a specific address owns.

ownerOf(uint256 tokenId) public view returns (address): Returns the owner of a specific NFT, queried by its token ID.

Events
Transfer(address indexed from, address indexed to, uint256 indexed tokenId): Emitted when an NFT is minted (from the zero address to the winner).

Technical Details
Solidity Version: pragma solidity ^0.8.20;

License: MIT

Happy hunting!
