class Accounts {
  final String broker;
  final String isActive;
  final String accountName;
  
   //Map <dynamic, dynamic> to_json() 
  Accounts({this.broker, this.isActive, this.accountName});
  // Map <dynamic, dynamic> toJson() { 
  //   return <dynamic, dynamic> {"broker" : this.broker, "accountName" : this.accountName};
  // }  

}

class WhiteListArguments {
  final Map account;
  final Map rule;
  WhiteListArguments(this.account, this.rule);
}
