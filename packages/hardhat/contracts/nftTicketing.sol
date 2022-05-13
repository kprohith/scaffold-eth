pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// import "@openzeppelin/contracts/access/Ownable.sol";
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract nftTicketing is ERC721URIStorage {
    bool public saleIsActive = false;

    constructor() ERC721("nftTickets", "NFTT") {
        owner = msg.sender;
    }

    function openSale() public {
      saleIsActive = true;
    }

    function closeSale() public {
      saleIsActive = false;
    }

    uint256 ticketPrice = 1 wei;
    address owner;
    mapping(address => uint256) public ticketHolders;

    
    function buyTickets(address _user, uint256 _amount) public payable {
        require(msg.value >= ticketPrice * _amount, "Value incorrect!");
        addTickets(_user, _amount);
    }

    function useTickets(address _user, uint256 _amount) public {
        subTickets(_user, _amount);
    }

    function addTickets(address _user, uint256 _amount) internal {
        ticketHolders[_user] = ticketHolders[_user] + _amount;
    }

    function subTickets(address _user, uint256 _amount) internal {
        require(
            ticketHolders[_user] >= _amount,
            "You do not have enough tickets!"
        );
        ticketHolders[_user] = ticketHolders[_user] - _amount;
    }

    function withdraw() public {
        require(msg.sender == owner, "You are not the owner!");
        (bool success, ) = payable(owner).call{value: address(this).balance}(
            ""
        );
        require(success);
    }

    receive() external payable {}

    fallback() external payable {}
}
