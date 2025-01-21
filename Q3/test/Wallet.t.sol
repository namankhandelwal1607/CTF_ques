// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/Wallet.sol";

contract WalletTest is Test {
    Wallet public wallet;
    address payable public owner;
    address payable public user;
    uint256 public initialBalance = 10 ether;

    function setUp() public {
        owner = payable(address(this));
        user = payable(address(0x1));
        vm.deal(owner, initialBalance);
        wallet = new Wallet{value: initialBalance}();
    }

    function testConstructor() public {
        assertEq(wallet.owner(), address(this));
        assertEq(address(wallet).balance, initialBalance);
    }

    function testTransferAsOwner() public {
        uint256 transferAmount = 1 ether;
        uint256 initialUserBalance = user.balance;
        
        wallet.transfer(user, transferAmount);
        
        assertEq(user.balance, initialUserBalance + transferAmount);
        assertEq(address(wallet).balance, initialBalance - transferAmount);
    }

    function testFailTransferNotOwner() public {
        vm.prank(user);
        wallet.transfer(user, 1 ether);
    }

    function testFailTransferInsufficientBalance() public {
        uint256 tooMuch = initialBalance + 1 ether;
        wallet.transfer(user, tooMuch);
    }

    receive() external payable {}
}