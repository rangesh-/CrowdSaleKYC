pragma solidity ^0.4.4;
import "./ERC20Token.sol";

contract KYCCrowdSale {

address public beneficiary;
address public owner;
uint256 public fundingexpected;
uint256 public fundingraised;
uint public deadline;
uint public pricepertoken;
bool IsCrowdSaleClosed =false;
bool IsDeadlineReached = false;
bool IsFundingSuccessful =false;
uint256 _nooftokensfornonkyc=2;
mapping(address=>uint) Contributors;
ERC20Token token; 
event ContributedToCrowdSaleEvent(address to,uint amount);
event FundCapReached(address owner,address beneficiary,uint amount);

modifier IsCrowdSaleOpen(){
    require(IsCrowdSaleClosed == false);
    _;
}

modifier onlyOwner(){
    require(msg.sender==owner);
    _;
}
modifier IsDeadLineNotReached(){
    require(now<=deadline);
    _;             
}

modifier IsEtherNotFraction(){
    require ((msg.value * 1 ether)%1 == 0);
    _;
}

modifier IsValidEtherContribution(){
    require(msg.value * 1 ether >= pricepertoken);
    _;
}

modifier afterCrowdSaleExpired(){
    require(now>deadline);
    _;
}

function KYCCrowdSale(address fundtoberaisedfor, uint256 fundcap,uint256 funddeadline,uint priceoftoken,address erc20token) {
beneficiary = fundtoberaisedfor;
fundingexpected = fundcap;
deadline = now + funddeadline * 1 minutes;
pricepertoken = priceoftoken * 1 ether;
token = ERC20Token(erc20token);
}

// Payable Function which takes ethers from callers based on KYC condition 

function ContributetoCrowdSale(bool IsKYCverified) public IsCrowdSaleOpen()  IsDeadLineNotReached() IsEtherNotFraction() IsValidEtherContribution() payable {
uint amountcontributed = msg.value * 1 ether;
if (IsKYCverified) {
Contributors[msg.sender] += amountcontributed;
fundingraised += amountcontributed;
token.transfer(msg.sender,amountcontributed/pricepertoken);
ContributedToCrowdSaleEvent(msg.sender,amountcontributed/pricepertoken);
} else {
   require(token.balanceOf(msg.sender)<_nooftokensfornonkyc);
   uint etherstobereturned = (amountcontributed / pricepertoken ) - _nooftokensfornonkyc + token.balanceOf(msg.sender);
   uint kycfund = amountcontributed - etherstobereturned;
   Contributors[msg.sender] += kycfund;
   fundingraised += kycfund;
   token.transfer(msg.sender,kycfund);
   ContributedToCrowdSaleEvent(msg.sender,kycfund);
}
}

function CloseCrowdSale() public onlyOwner() {
    require(now>=deadline); 
    if (fundingraised >= fundingexpected) {
     IsFundingSuccessful = true;
     FundCapReached(owner,beneficiary,fundingraised);
      }
   IsCrowdSaleClosed = true;
}

function Withdraw() afterCrowdSaleExpired() public {
require(IsCrowdSaleClosed == true);
  if (!IsFundingSuccessful) {
    uint amount = Contributors[msg.sender];
    msg.sender.transfer(amount * 1 ether);
    Contributors[msg.sender] = 0;
    } else {
    if (msg.sender == beneficiary && IsFundingSuccessful) {
        beneficiary.transfer(fundingraised * 1 ether);
        IsFundingSuccessful = false;
        fundingraised = 0;
    }
  }
}

function getBalance(address addr) public returns (uint256) {
    return token.balanceOf(addr);
}

function getFundsRaised() public returns (uint256) {
    return fundingraised;
}


}