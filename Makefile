# include env file


-include .env

deploy-mumbai:
	forge script script/DeployFundMe.s.sol --rpc-url $(MUMBAI_RPC_URL) --broadcast 
	--private-key $(PRIVATE_KEY)
	
# --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv