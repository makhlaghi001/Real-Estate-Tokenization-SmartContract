pragma solidity ^0.5.0;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Mintable.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/access/AccessControl.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol";
contract RealEstateToken is ERC20, ERC20Detailed, ERC20Mintable{
    
    struct RealEstateAsset{
        uint assetId;
        string assetName;
        string assetType;
        string location;
        uint value;
        string listingURL;
        
    }

    constructor(string memory name, string memory symbol, uint initialSupply)
        
        ERC20Detailed(name, symbol, 18)
        public

    {
        mint(msg.sender, initialSupply);
       
    }
    
    
    mapping(uint => RealEstateAsset) public realEstateAssets;
    function registerRealEstateAsset(
        uint assetId,
        string memory assetName,
        string memory assetType,
        string memory location, 
        uint value,
        string memory listingURL
    ) public{

        RealEstateAsset storage asset = realEstateAssets[assetId];
        asset.assetName = assetName;
        asset.assetType = assetType;
        asset.location = location;
        asset.value = value;
        asset.listingURL = listingURL;
       

    }
    
    
    
}
    
    











    
    








