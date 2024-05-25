//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { MemoryInterface, PeerToPlayMapping, ListInterface, PeerToPlayConnectors } from "./interfaces.sol";


abstract contract Stores {

  /**
   * @dev Return ethereum address
   */
  address constant internal ethAddr = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

  /**
   * @dev Return Wrapped ETH address
   */
  address constant internal wethAddr = 0xfFf9976782d46CC05630D1f6eBAb18b2324d6B14;

  /**
   * @dev Return memory variable address
   */
  MemoryInterface constant internal PeerToPlayMemory = MemoryInterface(0xd709F2996CEf36DA01b3C33f59C37540D3e18c33);

  /**
   * @dev Return PeerToPlayList address
   */
  ListInterface internal constant PeerToPlayList = ListInterface(0x5e78867e35107824C5Ece4E8A5bf095f8442f83E);

  /**
   * @dev Return connectors registry address
   */
  PeerToPlayConnectors internal constant peerToPlayConnectors = PeerToPlayConnectors(0x7f3BCcC45f8B6486024D97754788CEB857b8d608);

  /**
   * @dev Get Uint value from PeerToPlayMemory Contract.
   */
  function getUint(uint getId, uint val) internal returns (uint returnVal) {
    returnVal = getId == 0 ? val : PeerToPlayMemory.getUint(getId);
  }

  /**
  * @dev Set Uint value in PeerToPlayMemory Contract.
  */
  function setUint(uint setId, uint val) virtual internal {
    if (setId != 0) PeerToPlayMemory.setUint(setId, val);
  }

}