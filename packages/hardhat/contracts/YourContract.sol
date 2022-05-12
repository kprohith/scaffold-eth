pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
// import "@openzeppelin/contracts/access/Ownable.sol"; 
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol


contract YourContract {

    uint256 ticketPrice = 1 wei;
    address owner;
    mapping (address => uint256) public ticketHolders;

    constructor() {
        owner = msg.sender;
    }

    function buyTickets(address _user, uint256 _amount) payable public {
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
        require(ticketHolders[_user] >= _amount, "You do not have enough tickets!");
        ticketHolders[_user] = ticketHolders[_user] - _amount;
    }

    function withdraw() public {
        require(msg.sender == owner, "You are not the owner!");
        (bool success, ) = payable(owner).call{value: address(this).balance}("");
        require(success);
    }

   receive() external payable {}
   fallback() external payable {}
}