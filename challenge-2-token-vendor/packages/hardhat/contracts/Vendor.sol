pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

import "hardhat/console.sol";

contract Vendor is Ownable{
  // event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(
        address seller,
        uint256 amountOfETH,
        uint256 amountOfTokens
    );
  YourToken public yourToken;
  uint256 public constant tokensPerEth = 100;
  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable{
    uint256 amountOfTokens = msg.value * tokensPerEth;
    uint256 avalibletoken = yourToken.balanceOf(address(this));
    require(avalibletoken>=amountOfTokens,"Vender has not enough token!");
    yourToken.transfer(msg.sender, amountOfTokens);

    emit BuyTokens(msg.sender, msg.value, amountOfTokens);
  }
  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner{
    uint256 VendorBalance = address(this).balance;
    require(VendorBalance > 0, "Cannot withdraw! ETH is zero");

    (bool success, ) = owner().call{value: VendorBalance}("");
    require(success, "Failed to send Ether");
  }
  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 amount) public {
    uint256 amountOfEth = amount / tokensPerEth;
    require(amountOfEth<=address(this).balance,'Vender enough eth to buy tokens');
    yourToken.transferFrom(msg.sender, address(this), amount);
    (bool success, ) = msg.sender.call{value: amountOfEth}("");
    require(success, "Failed to send Ether");

    emit SellTokens(msg.sender, amountOfEth, amount);
  }
}
