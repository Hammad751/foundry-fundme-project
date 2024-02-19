// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, withdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundme;
    address USER = makeAddr("user");
    uint256 constant send_value = 0.01 ether;
    uint256 constant userFund = 5 ether;
    uint256 constant gasPrice = 2;

    function setUp() external{
        DeployFundMe deploy = new DeployFundMe();
        fundme = deploy.run();
        vm.deal(USER, userFund);
    }

    // write test case here
    function testUserCanFundInteractions() public {
        // create an instance for FundFundMe contract
        FundFundMe fundFundMe = new FundFundMe();
        // vm.prank(USER);
        // vm.deal(USER, send_value);
        // call the method FundFundMe contract having argument with fundeme contract address
        fundFundMe.fundfundme(address(fundme));

        withdrawFundMe withdrawfundme = new withdrawFundMe();
        withdrawfundme.withdraw_FundeMe(address(fundme));

        assert(address(fundme).balance ==0);
        // add test
        // address funder = fundme.getFunder(0);
        // assertEq(funder, USER);
    }
}