//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract tokenICO {

    IERC20 token = IERC20(0xd9145CCE52D386f254917e481eB44e9943F39138);
    address public admin;
    address payable public deposit;
    uint public saleStart = block.timestamp;
    uint public saleEnd = block.timestamp+604800;
    uint public hardCap = 300 ether;
    uint public maxInvestment = 5 ether;
    uint public minInvestment = 1 ether;
    uint public recievedAmount = 0;
    uint public oneTokenPrice = 0.1 ether;

    constructor(){
        admin = msg.sender; 
        deposit = payable(admin);
    }

    function goalStatus() public view returns (bool) {
        if(recievedAmount == hardCap){
            return true;
        }
        else{
            return false;
        }
  }

    modifier saleisActive{
        require(block.timestamp >= saleStart && block.timestamp <= saleEnd);
        require(goalStatus() == false); 
        _;
    }
    
   receive() payable external {
        require(msg.value >= minInvestment && msg.value <= maxInvestment);
        buyToken();
    } 


    function buyToken() internal saleisActive{
        uint numOfTokens = msg.value / oneTokenPrice;
        token.transfer(msg.sender, numOfTokens);
        recievedAmount = recievedAmount + msg.value;
    } 

    function getBalance() public view returns (uint){
        
        return address(this).balance;
    }

    function setDepositAddress(address _address) public  {
        require(msg.sender == admin);
        deposit = payable(_address);
    }

    function withdrawFunds() public payable {
        require(msg.sender == admin);
        deposit.transfer(getBalance());

    }


}
