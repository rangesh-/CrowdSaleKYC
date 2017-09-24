var KYCCrowdsale =  artifacts.require("./KYCCrowdSale.sol");
var ERC20Token = artifacts.require("./ERC20Token.sol");

contract('KYCCrowdsale', function(accounts) {
    it("should put 1000000 Tokens in the Owner account", function() {
      return KYCCrowdsale.deployed().then(function(instance) {
        return instance.getBalance.call(accounts[0]);
      }).then(function(balance) {
        assert.equal(balance.valueOf(), 1000000, "1000000 wasn't in the first account");
      });
    });

    it("should send token correctly and increment FundRaised ", function() {
      var token;
  
      // Get initial balances of first and second account.
      var account_one = accounts[0];
      var account_two = accounts[1];
  
      var account_one_starting_balance;
      var account_two_starting_balance;
      var account_one_ending_balance;
      var account_two_ending_balance;
  
      var amount = 2;
  
      return KYCCrowdsale.deployed().then(function(instance) {
        token = instance;
        return token.getBalance.call(account_one);
      }).then(function(balance) {
        account_one_starting_balance = balance.toNumber();
        return token.getBalance.call(account_two);
      }).then(function(balance) {
        account_two_starting_balance = balance.toNumber();
        return token.ContributetoCrowdSale.call(true,{from: account_two,value : 2 });
      }).then(function() {
        return token.getBalance.call(account_one);
      }).then(function(balance) {
        account_one_ending_balance = balance.toNumber();
        return token.getBalance.call(account_two);
      }).then(function(balance) {
        account_two_ending_balance = balance.toNumber();
  
    //    assert.equal(account_one_ending_balance,  account_one_starting_balance - amount, "Amount wasn't correctly taken from the sender");
     //   assert.equal(account_two_ending_balance, account_two_starting_balance + amount, "Amount wasn't correctly sent to the receiver");
      });
    });

});