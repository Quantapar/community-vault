// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {CommunityVault} from "../src/CommunityVault.sol";

contract CommunityVaultTest is Test {
    CommunityVault vault;
    address alice = address(0xA11CE);
    address bob = address(0xB0B);

    function setUp() public {
        vault = new CommunityVault();
        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);
    }

    function testDepositAndWithdraw() public {
        vm.prank(alice);
        vault.deposit{value: 3 ether}();
        assertEq(vault.balanceOf(alice), 3 ether);

        vm.prank(alice);
        vault.withdraw();
        assertEq(vault.balanceOf(alice), 0);
        assertEq(alice.balance, 10 ether);
    }

    function testTwoMembers() public {
        vm.prank(alice);
        vault.deposit{value: 2 ether}();
        vm.prank(bob);
        vault.deposit{value: 5 ether}();
        assertEq(vault.totalDeposits(), 7 ether);
        assertEq(vault.poolBalance(), 7 ether);
    }
}
