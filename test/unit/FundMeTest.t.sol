// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundme;

    address USER = makeAddr("user");
    uint256 constant send_value = 0.01 ether;
    uint256 constant userFund = 5 ether;
    uint256 constant gasPrice = 2;

    /**
     * we import "DeployFundMe" contract here so that we don't have to rewrite the price feed address 
     * every time we want to change the chain.
     * i.e, we make it dynamic 
     * every time we deploy the contract, we get the price feed address here in this test file. so that,
     * we don't have to bother every time with addresses.
     */
    function setUp() external{
        
        DeployFundMe deployfundme = new DeployFundMe();
        fundme = deployfundme.run();
        vm.deal(USER, userFund);
    }

    function testMinimumfive() public {
        assertEq(fundme.MINIMUM_USD(), 5e18);   
    }

    function testOwnerIsMsgSender() public{
        assertEq(fundme.getOwner(), msg.sender);
    }

    /**
     * there we go with 4 types of testings
     * 1: Unit Testing: Testing specific task of our code
     * 2: Integeration Testing: Testing how our code works with other parts of code
     * 3: forked Testing: Testing code on simulated environment
     * 4: Stagging: Testing in real environment that is not pod
     */

    function testPriceFeedVersion() public {
        uint256 version = fundme.getVersion();
        assertEq(version, 4);
    }

    function testFailsWithoutEnoughEth() public {
        fundme.fund();
        vm.expectRevert();
    }

    function testFundsUpdated() public {
        vm.prank(USER); // the next TX will be sent by USER
        fundme.fund{value: send_value}();
        uint256 amountFunded = fundme.getAddressToAmountFunded(USER);
        assertEq(amountFunded, send_value);
    }

    function testAddFunders() public {
        vm.prank(USER);
        fundme.fund{value: send_value}();

        address funder = fundme.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded(){
        vm.prank(USER);
        fundme.fund{value: send_value}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundme.withdraw();
    }

    function testWithdrawWithSingleFunder() public funded {
        uint256 ownerActualBalance = fundme.getOwner().balance;
        uint256 fundmeActualBalance = address(fundme).balance;

        uint256 gasStart = gasleft();
        vm.txGasPrice(gasPrice);
        vm.prank(fundme.getOwner());
        fundme.withdraw();
        uint256 gasEnd = gasleft();

        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        console.log(gasUsed);

        uint256 currentOwnerbalance = fundme.getOwner().balance;
        uint256 currentFundmeBalance = address(fundme).balance;

        assertEq(currentFundmeBalance, 0);
        assertEq(ownerActualBalance + fundmeActualBalance, currentOwnerbalance);
    }

    function testWithdrawWithMltiplefunders() public funded {
        uint160 numOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for(uint160 i=startingFunderIndex; i<numOfFunders; i++){
            hoax(address(i), send_value);
            fundme.fund{value: send_value}();
        } 

        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundmeBalance = address(fundme).balance;

        vm.startPrank(fundme.getOwner());
        fundme.withdraw();
        vm.stopPrank();

        assert(address(fundme).balance == 0);
        assert(startingOwnerBalance + startingFundmeBalance == fundme.getOwner().balance);
    }

}