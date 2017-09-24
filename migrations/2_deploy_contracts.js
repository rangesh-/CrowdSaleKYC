var ERC20Token = artifacts.require("./ERC20Token.sol");
var CrowdSale = artifacts.require("./KYCCrowdSale.sol");
module.exports = function(deployer) {
  deployer.deploy(ERC20Token).then(function(){
    return  deployer.deploy(CrowdSale,"0x205a866663a3eb1a71938d0da6016aa81fa3281d",20,600,1,ERC20Token.address);
  });
  deployer.link(ERC20Token,CrowdSale); 
};
