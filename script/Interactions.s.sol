// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script { 
    constructor() {}
    uint256 sendValue = 0.01 ether;
    function fundfundme(address _mostrecentDeployed) public {
        vm.startBroadcast();
        FundMe(payable(_mostrecentDeployed)).fund{value: sendValue}();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", sendValue);
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );

        vm.startBroadcast();
        fundfundme(mostRecentDeployed);
        vm.stopBroadcast();
    }
}

contract withdrawFundMe is Script {

    function withdraw_FundeMe(address _mostrecentDeployed) public {
        vm.startBroadcast();
        FundMe(payable(_mostrecentDeployed)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );

        vm.startBroadcast();
        withdraw_FundeMe(mostRecentDeployed);
        vm.stopBroadcast();
    }
}