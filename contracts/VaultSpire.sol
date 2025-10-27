// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title VaultSpire
 * @dev A decentralized vault system that allows users to deposit, withdraw, and check their balances securely.
 */
contract VaultSpire {
    mapping(address => uint256) private balances;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    /**
     * @dev Deposit Ether into the vault.
     */
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    /**
     * @dev Withdraw Ether from the vault.
     * @param _amount The amount to withdraw.
     */
    function withdraw(uint256 _amount) public {
        require(_amount > 0, "Withdrawal amount must be greater than zero");
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);

        emit Withdrawn(msg.sender, _amount);
    }

    /**
     * @dev Check the balance of the caller.
     * @return balance The current balance of the user.
     */
    function getBalance() public view returns (uint256 balance) {
        return balances[msg.sender];
    }
}
