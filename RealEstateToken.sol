pragma solidity ^0.5.0;

//  Import the following contracts from the OpenZeppelin library:
//    * `ERC20`
//    * `ERC20Detailed`
//    * `ERC20Mintable`

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Mintable.sol";


contract RealEstateToken is ERC20, ERC20Detailed,ERC20Mintable{

    constructor(
        string memory name,
        string memory symbol,
        uint initial_supply

    )    
    
        ERC20Detailed(name, symbol, 18)
        public
    {
        mint(msg.sender, initial_supply);
    }
    

     mapping (uint256 => string) public tokenURIs;
     function setTokenURI(uint256 tokenID, string memory tokenURI) public {
        tokenURIs[tokenID] = tokenURI;
    }

    function RegisterRealEstateAsset(address owner, string memory tokenURI)
        public
        returns (uint256)
   
    {
        uint256 tokenID = totalSupply();
        mint(owner, tokenID);
        setTokenURI(tokenID, tokenURI);

        return tokenID;

    } 
}
