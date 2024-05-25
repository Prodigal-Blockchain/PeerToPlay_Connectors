// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract Cricket is ERC721, Ownable {
    using EnumerableSet for EnumerableSet.UintSet;

    uint256 public nextPlayerId = 1;
    uint256 public nextMatchId = 1;
    uint256 public nextTeamId = 1;
    uint256 public platformFeePercent = 5;
    uint256 public variable = 5;

    struct Player {
        string name;
        address playerAddress;
        uint256 pointsEarned;
        uint256 gamesPlayed;
    }

    struct Team {
        string name;
        EnumerableSet.UintSet playerIds;
    }

    struct Match {
        uint256[] playerIds;
        string location;
        uint256 fee;
        uint256 startTime;
        bool isCompleted;
        bool isStarted; // Indicates if the match has started
        uint256 winnerId;
        uint256 matchType;
        mapping(uint256 => bool) feePaid; // Tracks fee payment for each player
    }

    mapping(uint256 => Player) public players;
    mapping(uint256 => Match) public matches;
    mapping(uint256 => Team) private teams;
    mapping(address => uint256) public userPoints;
    mapping(uint256 => uint256) public matchFeesCollected;
    mapping(address => uint256) private addressToPlayerId;
    mapping(uint256 => bool) private tokenExists;

    event PlayerRegistered(
        uint256 indexed playerId,
        address indexed playerAddress
    );
    event TeamCreated(uint256 indexed teamId, string name);
    event MatchScheduled(
        uint256 indexed matchId,
        string location,
        uint256 fee,
        uint256 startTime
    );
    event MatchStarted(uint256 indexed matchId);
    event MatchCompleted(uint256 indexed matchId, uint256 winnerId);

    event DebugLog(string message, address sender, uint256 playerId);

    constructor() ERC721("Cricket", "CKT") {}

    function registerPlayer(string memory playerName) external {
        require(
            addressToPlayerId[msg.sender] == 0,
            "Address already registered"
        );
        uint256 playerId = nextPlayerId++;
        _mint(msg.sender, playerId);
        tokenExists[playerId] = true;
        players[playerId] = Player(playerName, msg.sender, 0, 0);
        addressToPlayerId[msg.sender] = playerId;
        userPoints[msg.sender] += 10; // Award points for player registration.
        emit PlayerRegistered(playerId, msg.sender);
    }

    function createTeam(
        string memory teamName,
        uint256[] memory playerIds
    ) external {
        uint256 teamId = nextTeamId++;
        Team storage team = teams[teamId];
        team.name = teamName;

        bool senderIsPlayer = false;
        for (uint256 i = 0; i < playerIds.length; i++) {
            require(tokenExists[playerIds[i]], "Player NFT does not exist.");
            if (ownerOf(playerIds[i]) == msg.sender) {
                senderIsPlayer = true;
                emit DebugLog("Sender is player", msg.sender, playerIds[i]);
            }
            team.playerIds.add(playerIds[i]);
        }

        require(
            senderIsPlayer,
            "Sender must be one of the players in the team."
        );

        emit TeamCreated(teamId, teamName);
        variable = 2;
    }

    function scheduleMatch(
        uint256 teamId,
        string memory location,
        uint256 fee,
        uint256 startTime,
        uint256 matchType
    ) external {
        require(teams[teamId].playerIds.length() > 0, "Team has no players.");
        uint256[] memory playerIds = teams[teamId].playerIds.values();
        Match storage newMatch = matches[nextMatchId];
        newMatch.playerIds = playerIds;
        newMatch.location = location;
        newMatch.fee = fee;
        newMatch.startTime = startTime;
        newMatch.matchType = matchType;
        newMatch.isCompleted = false;
        newMatch.isStarted = false;
        emit MatchScheduled(nextMatchId, location, fee, startTime);
        nextMatchId++;
    }

    function payMatchFee(uint256 matchId) external payable {
        require(!matches[matchId].isCompleted, "Match is already completed.");
        require(msg.value >= matches[matchId].fee, "Incorrect fee amount.");

        uint256 playerId = tokenIdOf(msg.sender);
        require(
            isPlayerInMatch(playerId, matchId),
            "Player is not in this match."
        );

        Match storage matchInfo = matches[matchId];
        require(!matchInfo.feePaid[playerId], "Fee already paid.");

        matchInfo.feePaid[playerId] = true;
        matchFeesCollected[matchId] += msg.value;
    }

    function playMatch(uint256 matchId) external {
        Match storage matchData = matches[matchId];
        require(!matchData.isStarted, "Match has already started.");
        require(
            matchData.startTime <= block.timestamp,
            "Match start time is not yet reached."
        );

        for (uint256 i = 0; i < matchData.playerIds.length; i++) {
            require(
                matchData.feePaid[matchData.playerIds[i]],
                "Not all fees are paid."
            );
        }

        matchData.isStarted = true;
        emit MatchStarted(matchId);
    }

    function completeMatch(
        uint256 matchId,
        uint256 winnerId
    ) external onlyOwner {
        Match storage matchData = matches[matchId];
        require(matchData.isStarted, "Match has not started.");
        require(!matchData.isCompleted, "Match already completed.");

        matchData.isCompleted = true;
        matchData.winnerId = winnerId;

        uint256 totalFee = matchFeesCollected[matchId];
        uint256 platformFee = (totalFee * platformFeePercent) / 100;
        uint256 reward = totalFee - platformFee;

        address winnerAddress = ownerOf(winnerId);
        payable(winnerAddress).transfer(reward);
        payable(owner()).transfer(platformFee);

        Player storage winner = players[winnerId];
        winner.pointsEarned += reward;
        winner.gamesPlayed++;

        emit MatchCompleted(matchId, matchData.winnerId);
    }

    function setPlatformFeePercent(uint256 newFeePercent) external onlyOwner {
        platformFeePercent = newFeePercent;
    }

    receive() external payable {}

    // Helper function to check if a player is part of the match
    function isPlayerInMatch(
        uint256 playerId,
        uint256 matchId
    ) private view returns (bool) {
        uint256[] memory playerIds = matches[matchId].playerIds;
        for (uint i = 0; i < playerIds.length; i++) {
            if (playerIds[i] == playerId) {
                return true;
            }
        }
        return false;
    }

    function tokenIdOf(address owner) public view returns (uint256) {
        require(
            addressToPlayerId[owner] != 0,
            "No player associated with this address."
        );
        return addressToPlayerId[owner];
    }

    // New function to get all player IDs of a team
    function getPlayerIdsOfTeam(
        uint256 teamId
    ) external view returns (uint256[] memory) {
        require(
            teams[teamId].playerIds.length() > 0,
            "Team does not exist or has no players."
        );
        uint256 length = teams[teamId].playerIds.length();
        uint256[] memory playerIds = new uint256[](length);

        for (uint256 i = 0; i < length; i++) {
            playerIds[i] = teams[teamId].playerIds.at(i);
        }

        return playerIds;
    }
}
