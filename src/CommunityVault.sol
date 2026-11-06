// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title CommunityVault
/// @notice A shared savings pool. Members deposit ETH, earn a share of the
///         pool's bonus fund over time, and can withdraw whenever they like.
contract CommunityVault {
    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public depositedAt;
    uint256 public totalDeposits;
    address public immutable steward;

    event Deposited(address indexed member, uint256 amount);
    event Withdrawn(address indexed member, uint256 amount);

    constructor() {
        steward = msg.sender;
    }

    /// @notice Put ETH into the pool.
    function deposit() external payable {
        require(msg.value > 0, "nothing to deposit");
        balanceOf[msg.sender] += msg.value;
        depositedAt[msg.sender] = block.timestamp;
        totalDeposits += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    /// @notice Take your whole balance out of the pool.
    function withdraw() external {
        uint256 amount = balanceOf[msg.sender];
        require(amount > 0, "no balance");

        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "transfer failed");

        balanceOf[msg.sender] = 0;
        totalDeposits -= amount;
        emit Withdrawn(msg.sender, amount);
    }

    /// @notice ETH held by the pool right now.
    function poolBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
