// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VaultSpire {
    IERC20 public immutable asset;        // underlying ERC20 asset
    uint256 public totalShares;           // total shares issued
    mapping(address => uint256) public shareBalance;

    event Deposit(address indexed user, uint256 assetAmount, uint256 sharesMinted);
    event Withdraw(address indexed user, uint256 sharesBurned, uint256 assetAmount);

    constructor(address _asset) {
        require(_asset != address(0), "Invalid asset address");
        asset = IERC20(_asset);
    }

    /// @notice Deposit asset tokens into vault — get shares
    function deposit(uint256 amount) external {
        require(amount > 0, "Deposit: amount zero");

        uint256 sharesToMint;
        uint256 vaultBalance = asset.balanceOf(address(this));
        if (totalShares == 0 || vaultBalance == 0) {
            sharesToMint = amount;
        } else {
            sharesToMint = (amount * totalShares) / vaultBalance;
        }

        require(asset.transferFrom(msg.sender, address(this), amount), "Deposit: transfer failed");

        totalShares += sharesToMint;
        shareBalance[msg.sender] += sharesToMint;

        emit Deposit(msg.sender, amount, sharesToMint);
    }

    /// @notice Withdraw underlying asset by burning shares
    function withdraw(uint256 shareAmount) external {
        require(shareAmount > 0, "Withdraw: zero shares");
        uint256 userShares = shareBalance[msg.sender];
        require(userShares >= shareAmount, "Withdraw: insufficient shares");

        uint256 vaultBalance = asset.balanceOf(address(this));
        uint256 amountToReturn = (vaultBalance * shareAmount) / totalShares;

        shareBalance[msg.sender] -= shareAmount;
        totalShares -= shareAmount;

        require(asset.transfer(msg.sender, amountToReturn), "Withdraw: transfer failed");

        emit Withdraw(msg.sender, shareAmount, amountToReturn);
    }

    /// @notice Preview: how many shares you'd get for depositing a given asset amount
    function previewDeposit(uint256 amount) external view returns (uint256) {
        uint256 vaultBalance = asset.balanceOf(address(this));
        if (totalShares == 0 || vaultBalance == 0) {
            return amount;
        }
        return (amount * totalShares) / vaultBalance;
    }

    /// @notice Preview: how much asset you'd get for burning given shares
    function previewWithdraw(uint256 shareAmount) external view returns (uint256) {
        uint256 vaultBalance = asset.balanceOf(address(this));
        require(totalShares > 0, "No shares exist");
        return (vaultBalance * shareAmount) / totalShares;
    }
}
