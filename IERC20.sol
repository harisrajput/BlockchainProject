//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {IERC20} from "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
contract token is IERC20 {

    string public constant name = "Haris";
    string public constant symbol = "MHR";
    uint8 public constant decimals = 18;
    uint256 _totalSupply;
    address owner; 

    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    constructor() {
    _totalSupply = 1000000000000;
    owner = msg.sender;
    balances[address(this)] = _totalSupply;
}

    function totalSupply() public view override returns(uint){
        return _totalSupply;
    }

    function balanceOf(address _owner) public view override returns (uint) {
    return balances[_owner];
}
    function transfer(address receiver, uint numTokens) public override returns (bool) {
    require(numTokens <= balances[address(this)]);
    balances[address(this)] -= numTokens;
    balances[receiver] += numTokens;
    emit Transfer(msg.sender, receiver, numTokens);
    return true;
}

    function approve(address delegate, uint numTokens) public override returns (bool) {
    allowed[msg.sender][delegate] = numTokens;
    emit Approval(msg.sender, delegate, numTokens);
    return true;
}

    function allowance(address _owner, address delegate) public view override returns (uint) {
    return allowed[_owner][delegate];
}


    function transferFrom(address _owner, address buyer, uint numTokens) public override returns (bool) {
    require(numTokens <= balances[_owner]);
    require(numTokens <= allowed[_owner][msg.sender]);
    balances[_owner] -= numTokens;
    allowed[_owner][msg.sender] -= numTokens;
    balances[buyer] += numTokens;
    emit Transfer(_owner, buyer, numTokens);
    return true;
}



}
