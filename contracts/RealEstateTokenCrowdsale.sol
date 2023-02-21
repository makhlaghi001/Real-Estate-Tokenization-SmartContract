pragma solidity ^0.5.0;

import "./RealEstateToken.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

contract RealEstateTokenCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {
    struct investorInfo{
        string name;
        string lastName;
        address investorWallet;
       
    }
    
    
    
    constructor(
        uint256 rate,
        address payable wallet,
        uint256 goal,
        uint256 open,
        uint256 Close,
        //address minter,
        RealEstateToken token
    ) public
      
        Crowdsale(rate, wallet, token)
        MintedCrowdsale()
        CappedCrowdsale(goal)
        TimedCrowdsale(open, Close)
        RefundableCrowdsale(goal)
    {
    }
    mapping (address => investorInfo) public investorRegistrations;
    function investorRegistration(
        string memory name, 
        string memory lastName, 
        address investorWallet
    )public { 
        investorInfo storage investor = investorRegistrations[investorWallet];
        investor.name = name;
        investor.lastName = lastName;
        investor.investorWallet = investorWallet;

        
    }
       
}

contract RealEstateCrowdsaleDeployer{
    
    address public realestate_token_address;
    address public realestate_crowdsale_address;
    //address public minter;


    constructor (
        string memory name, 
        string memory symbol, 
        address payable wallet,
        uint goal
       

    ) public 
        
    
    {
        // Create a new instance of the RealEstateToken contract.
        RealEstateToken token = new RealEstateToken (name, symbol, 0);
        // Assign he token contract’s address to the 'realestate_token_address' variable.
        realestate_token_address = address(token);
        // Create a new instance of the 'RealEstateTokenCrowdsale'.
        RealEstateTokenCrowdsale RealEstate_Crowdsale = new RealEstateTokenCrowdsale (1,wallet,goal, now, now + 10 weeks,token);
        // Aassign the `RealEstateTokenCrowdsale` contract’s address to the `realestate_crowdsale_address` variable.
        realestate_crowdsale_address = address(RealEstate_Crowdsale);
        // Set the "RealEstate_Crowdsale" contract as the minter 
        token.addMinter(realestate_crowdsale_address);
        // have the realestate_crowdsale_address renounce its minter role.
        //token.addMinter
        token.renounceMinter();

    }
    



} 
   