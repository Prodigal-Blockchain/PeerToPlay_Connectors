//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Basic } from "../Common/basic.sol";
import { ICricket } from "./interface.sol";

abstract contract Helpers is Basic {
   
    ICricket internal constant peerToPlayContract=ICricket(0x8e34306579d69a1be524ddAE72B73D75Abdf5455);

}