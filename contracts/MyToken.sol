//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract KSAToken is ERC20 {
    uint constant _initial_supply = 100 * (10**18);

    /* ERC 20 constructor takes in two strings:
     1. The name of your token name
     2. A symbol for your token
    */
    constructor() ERC20("KSA Token", "KSAT") {
        _mint(msg.sender, _initial_supply);
    }
}