pragma solidity ^0.4.8;
  
 contract ERC20Interface {
     function totalSupply() constant returns (uint256 totalSupply);
     function balanceOf(address _owner) constant returns (uint256 balance);
     function transfer(address _to, uint256 _value);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
 }
  
 contract ERC20Token is ERC20Interface {
     string public constant symbol = "FIXEDKYCToken";
     string public constant name = "KYCTOKEN";
     uint8 public constant decimals = 18;
     uint256 _totalSupply = 1000000;    
     address public owner;
     mapping(address => uint256) balances;  
     mapping(address => mapping (address => uint256)) allowed;
     modifier onlyOwner() {
         if (msg.sender != owner) {
             throw;
         }
         _;
     }
  
     function ERC20Token() {
         owner = msg.sender;
         balances[owner] = _totalSupply;
     }
  
     function totalSupply() public constant returns (uint256 totalSupply) {
         totalSupply = _totalSupply;
     }
  
     function balanceOf(address _owner) public constant returns (uint256 balance) {
         return balances[_owner];
     }
  
     function transfer(address _to, uint256 _amount) public {
         if (balanceOf(owner)>=_amount && _amount > 0) {
            balances[owner] -= _amount;
             balances[_to] += _amount;
             Transfer(msg.sender, _to, _amount);            
         } 
     }
  
     
 
 }
 