// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Vault {
    address owner;
    uint unlockTime;
    mapping(address => mapping(address => uint)) depositVault;

    constructor() {
        owner = msg.sender;
    }
    
    function depositEther(address beneficiary, uint256 duration) external payable {
        require(msg.sender != address(0), "must not be address zero");
        require(msg.value > 0, "Must send non-zero value");

        unlockTime = block.timestamp + duration;
        depositVault[msg.sender][beneficiary] += msg.value;
    }

    function claimBeneficiary(address beneficiary, uint256 amount) external {
        require(msg.sender != address(0), "must not be address zero");
        require(amount > 0, "insufficient value amount");
        require(block.timestamp >= unlockTime, "Sorry not yet unlocked");

        require(depositVault[msg.sender][beneficiary] >= amount, "Insufficient balance");

        depositVault[msg.sender][beneficiary] -= amount;
        
        payable(beneficiary).transfer(amount);
    }

    receive() external payable { }
    fallback() external payable { }
}
