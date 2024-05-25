//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ICricket {
    function registerPlayer(string memory playerName) external;
    function createTeam(
        string memory teamName,
        uint256[] memory playerIds
    ) external;
    function scheduleMatch(
        uint256 teamId,
        string memory location,
        uint256 fee,
        uint256 startTime,
        uint256 matchType
    ) external;
    function payMatchFee(uint256 matchId) external payable;
    function playMatch(uint256 matchId) external;
    
}