//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Events {
    event LogRegisterPlayer(address,string);
    event LogCreateTeam(string);
    event LogScheduleMatch(uint256,string,uint256,uint256,uint256);
    event LogpayMatchFee(uint256,uint256,address);
    event LogplayMatch(uint256);
}