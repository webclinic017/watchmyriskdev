import 'package:flutter/foundation.dart';

class RuleProviders with ChangeNotifier {

  // Rule
  bool _editRule = false;
  Map _rule;
  Map _account;
  
  bool get editRule => _editRule;
  Map get ruleToEdit => _rule;
  Map get account => _account;

  void editThisRule(Map rule, Map account) {
    _rule = rule;
    _account = account;
    _editRule = true;
    notifyListeners();
  }


}


