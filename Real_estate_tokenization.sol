pragma solidity ^0.5.0;

//  Import the following contracts from the OpenZeppelin library:
//    * `ERC20`
//    * `ERC20Detailed`
//    * `ERC20Mintable`
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Mintable.sol";

// Create a constructor for the KaseiCoin contract and have the contract inherit the libraries that you imported from OpenZeppelin.
contract RealEstateToken is ERC20, ERC20Detailed, ERC20Mintable {
    address payable owner;

    modifier onlyOwner {
        require(msg.sender == owner, "You do not have permission to mint these tokens!");
        _;
    }
    

    constructor(string memory name, string memory symbol, uint initial_supply) ERC20Detailed(name,symbol, 18) public {
        owner = msg.sender;
        _mint(owner, initial_supply);
    }

    function mint(address recipient, uint amount) public onlyOwner returns(bool) {
        _mint(recipient, amount);
    }



}