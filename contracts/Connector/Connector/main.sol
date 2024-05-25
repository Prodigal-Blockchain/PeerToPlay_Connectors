//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Authority.
 * @dev Manage Authorities to DSA.
 */
 
import { AccountInterface } from "../Common/interfaces.sol";
import { Helpers } from "./helpers.sol";
import { Events } from "./events.sol";

abstract contract Resolver is Events, Helpers{
    
   function registerPlayer(string memory playerName) external returns(string memory _eventName, bytes memory _eventParam) {
        
    
        peerToPlayContract.registerPlayer(playerName);

        _eventName = "LogRegisterPlayer(address,string)";
        _eventParam = abi.encode(msg.sender,playerName);

    }

    function createTeam(
        string memory teamName,
        uint256[] memory playerIds
    ) external returns(string memory _eventName, bytes memory _eventParam) {
        peerToPlayContract.createTeam(teamName, playerIds);
    
        _eventName = "LogCreateTeam(string)";
        _eventParam = abi.encode(teamName);
    }


    function scheduleMatch(
        uint256 teamId,
        string memory location,
        uint256 fee,
        uint256 startTime,
        uint256 matchType
    ) external returns(string memory _eventName, bytes memory _eventParam){
        peerToPlayContract.scheduleMatch(
            teamId,
            location,
            fee,
            startTime,
            matchType
        );

        _eventName = "LogScheduleMatch(uint256,string,uint256,uint256,uint256)";
        _eventParam = abi.encode(teamId,location,fee,startTime,matchType);
        
    }

    function payMatchFee(uint256 matchId) external payable returns(string memory _eventName, bytes memory _eventParam) {
        peerToPlayContract.payMatchFee{value: msg.value}(matchId);
        _eventName = "LogpayMatchFee(uint256,uint256,address)";
        _eventParam = abi.encode(matchId,msg.value,msg.sender);
    }


    function playMatch(uint256 matchId) external  returns(string memory _eventName, bytes memory _eventParam) {
        peerToPlayContract.playMatch(matchId);
         _eventName = "LogplayMatch(uint256)";
        _eventParam = abi.encode(matchId);
    }
   
}

contract CricketConnector is Resolver  {
    string public constant name = "CricketConnector-v1";
}