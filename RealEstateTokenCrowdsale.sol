pragma solidity ^0.5.0;


import "./RealEstateToken.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// Have the RealEstatTokenCrowdsale inherit the following OpenZeppelin:

// * Crowdsale
// * MintedCrowdsale  
// * CappedCrowdsale 
// * TimedCrowdsale 
// * RefundablePostDeliveryCrwodsale

contract RealEstateTokenCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale{

    // provide all paramaeters for all the features pf your crowdsale, such as rate, wallet, token, goal, open and close(for timedcrowdsale)
    constructor(
        uint rate,
        address payable wallet,
        uint goal,
        uint open,
        uint Close,
        RealEstateToken token

    ) 
    public 
            Crowdsale(rate, wallet, token)
            CappedCrowdsale(goal)
            TimedCrowdsale(open, Close)
            RefundableCrowdsale(goal)
    {

    }

}

contract RealEstateTokenCrowdsaleDeployer {
    address public realestate_token_address;
    address public realestate_crowdsale_address;


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
        // have the RealEstateCrowdsaleDeployer renounce its minter role.
        token.renounceMinter();






    } 






}


