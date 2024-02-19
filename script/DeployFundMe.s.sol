// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {

    function run() external returns(FundMe) {

        // its a mock TX        
        HelperConfig helperconfig = new HelperConfig();
        address ethusdPriceFeed = helperconfig.activeNetworkConfig();

        // after startBroadcast => its a real TX
        vm.startBroadcast();
        FundMe fundme = new FundMe(ethusdPriceFeed);
        vm.stopBroadcast();
        return fundme;
    }
}