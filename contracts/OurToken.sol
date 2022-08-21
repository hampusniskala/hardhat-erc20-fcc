// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20 {
    address immutable i_owner;

    mapping(address => bool) internal allowedMinters;

    modifier onlyAllowed() {
        require(allowedMinters[msg.sender], "OurToken: Sender is not allowed");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "OurToken: Sender must be owner");
        _;
    }

    constructor(uint256 initialSupply) ERC20("OurToken", "OT") {
        _mint(msg.sender, initialSupply * 10**18);
        i_owner = msg.sender;
        allowedMinters[msg.sender] = true;
    }

    // Test to override all transfers and give the reciever one less unit. Making the supply slightly deflationary.

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(amount > 0, "ERC20: value can't be zero");

        ERC20._transfer(from, to, amount);
        ERC20._burn(to, 1);
    }

    // Mint function
    function mint(address account, uint256 amount) public onlyAllowed {
        _mint(account, amount);
    }

    // Add accounts that can mint
    function addAllowed(address account) public onlyOwner {
        allowedMinters[account] = true;
    }

    //Remove accounts that can mint
    function removeAllowed(address account) public onlyOwner {
        allowedMinters[account] = false;
    }
}
