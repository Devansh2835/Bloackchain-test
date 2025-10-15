// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title NFTScavengerHunt
 * @dev A simple scavenger hunt game on the blockchain.
 * Players solve a series of riddles to win a unique NFT reward.
 * This contract is self-contained, with no imports or constructor,
 * as per the requirements. The game clues are initialized on the first
 * interaction to set up the game state.
 */
contract NFTScavengerHunt {

    // --- NFT (ERC721-Like) State Variables & Events ---

    string public name = "Scavenger Hunt Champion";
    string public symbol = "SHC";
    uint256 private _tokenIdCounter;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Event emitted when a token is transferred
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);


    // --- Scavenger Hunt State Variables ---

    struct Clue {
        string question;
        bytes32 answerHash; // The keccak256 hash of the answer
    }

    // Array to store all the clues for the hunt
    Clue[] public clues;

    // Mapping from player address to their current clue index
    mapping(address => uint256) public playerProgress;

    // Mapping to track players who have already won an NFT
    mapping(address => bool) public hasWon;

    // Flag to ensure clues are initialized only once
    bool private areCluesInitialized;


    // --- Game Logic Functions ---

    /**
     * @dev Allows a player to view their current clue.
     * @return The text of the player's current clue question.
     */
    function getCurrentClue() public view returns (string memory) {
        // The hunt must be initialized to see a clue.
        require(areCluesInitialized, "The scavenger hunt has not started yet.");
        
        uint256 currentClueIndex = playerProgress[msg.sender];
        
        // Ensure the player has not already finished the hunt.
        require(currentClueIndex < clues.length, "Congratulations! You have already solved all the clues.");

        return clues[currentClueIndex].question;
    }

    /**
     * @dev Allows a player to submit an answer for their current clue.
     * If correct, their progress is advanced. If it's the final clue, an NFT is minted.
     * @param _answer The player's submitted answer string.
     * @notice Answers are case-sensitive.
     */
    function submitAnswer(string memory _answer) public {
        // Initialize the clues on the very first call to this function.
        // This is a workaround for the "no constructor" requirement.
        if (!areCluesInitialized) {
            _initializeClues();
            areCluesInitialized = true;
        }

        // A player can only win once.
        require(!hasWon[msg.sender], "You have already completed the hunt and claimed your prize.");

        uint256 currentClueIndex = playerProgress[msg.sender];

        // Check if the player has already finished.
        require(currentClueIndex < clues.length, "You have already solved all the clues.");

        // Hash the submitted answer to compare with the stored hash.
        bytes32 submittedAnswerHash = keccak256(abi.encodePacked(_answer));

        // Check if the submitted answer is correct.
        if (submittedAnswerHash == clues[currentClueIndex].answerHash) {
            // Correct answer! Advance the player's progress.
            playerProgress[msg.sender]++;

            // Check for win condition (player has solved the last clue).
            if (playerProgress[msg.sender] == clues.length) {
                hasWon[msg.sender] = true;
                _mint(msg.sender);
            }
        } else {
            // Revert the transaction if the answer is incorrect.
            revert("That's not the right answer. Try again!");
        }
    }


    // --- Internal & Helper Functions ---

    /**
     * @dev Internal function to set up the game's clues.
     * This is called only once when the first player starts the hunt.
     */
    function _initializeClues() private {
        // Clue 1: "I have cities, but no houses. I have mountains, but no trees. I have water, but no fish. What am I?"
        // Answer: "A map"
        clues.push(Clue(
            "I have cities, but no houses. I have mountains, but no trees. I have water, but no fish. What am I?",
            0x23a352012299a87d76a7e751239088f17942c75a4138a52882a89047915525c3
        ));

        // Clue 2: "What has an eye, but cannot see?"
        // Answer: "A needle"
        clues.push(Clue(
            "What has an eye, but cannot see?",
            0x47752e582885c345b58ca0324b533e08f5c95b7745133d833355523991c0e39c
        ));

        // Clue 3: "What is always in front of you but can’t be seen?"
        // Answer: "The future"
        clues.push(Clue(
            "What is always in front of you but can't be seen?",
            0x85491a133486a34557731215b174775d8205f2420a887b46944062464734a713
        ));
    }

    /**
     * @dev Internal function to mint a new NFT and assign it to the winner.
     * @param _to The address of the player who won.
     */
    function _mint(address _to) private {
        require(_to != address(0), "Cannot mint to the zero address.");
        
        uint256 newTokenId = _tokenIdCounter;
        _owners[newTokenId] = _to;
        _balances[_to]++;
        
        emit Transfer(address(0), _to, newTokenId);
        
        _tokenIdCounter++;
    }


    // --- NFT (ERC721-Like) View Functions ---

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    /**
     * @dev Returns the owner of the `tokenId`.
     */
    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }
}
