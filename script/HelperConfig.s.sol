// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script{

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_VALUE = 2000e8;

    struct NetworkConfig{
        address priceFeed;  // ETH/USD price feed
    }

    NetworkConfig public activeNetworkConfig;

    constructor(){
        if(block.chainid == 80001){
            activeNetworkConfig = getChainEthConfig();
        }
        else{
            activeNetworkConfig = getLocalEthconfig();
        }
    }

    function getChainEthConfig() public pure returns(NetworkConfig memory) {
        NetworkConfig memory mumbaiConfig = NetworkConfig({
            priceFeed: 0x0715A7794a1dc8e42615F059dD6e406A6594651A
        });

        return mumbaiConfig;
    }

    function getLocalEthconfig() public returns(NetworkConfig memory) {

        if(activeNetworkConfig.priceFeed != address(0)){
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_VALUE);
        vm.stopBroadcast();

        NetworkConfig memory localConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return localConfig;
    }
}