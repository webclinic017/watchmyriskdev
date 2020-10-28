import 'package:flutter/foundation.dart';

class WmrProviders with ChangeNotifier {

  // Rule
  bool _editRule = false;
  Map _rule;
  Map _account;
  
  bool get editRule => _editRule;
  Map get ruleToEdit => _rule;
  Map get account => _account;
  int _index = 0;
  int get getIndex => _index;


  void editThisRule(Map rule, Map account) {
    _rule = rule;
    _account = account;
    _editRule = true;
    notifyListeners();
  }

  void saveIndex(int index) {
    _index = index;
    notifyListeners();
  }

// Token


  String _token;
  String get getToken => _token;

  void saveToken(String token) {
    _token = token;
    notifyListeners();
  }

 // Map _account;
  //Map _watchlist;
  Map get getAccount => _account;
  void saveAccount(Map account) {
    _account = account;
    notifyListeners();
  }

  Map _defaultAccount;
  Map get getDefaultAccount => _defaultAccount;
  void saveDefaultAccount(Map defaultAccount) {
    _defaultAccount = defaultAccount;
    notifyListeners();
  }


  Map _watchlist;
  Map get getWatchlist => _watchlist;
  void saveWatchlist(Map watchlist) {
    _watchlist = watchlist;
    notifyListeners();
  }

  Map _defaultWatchlist;
  Map get getDefaultWatchlist => _defaultWatchlist;
  void saveDefaultWatchlist(Map defaultWatchlist) {
    _defaultWatchlist = defaultWatchlist;
    notifyListeners();
  }

  int _watchlistIndex = 0;
  int get watchlistIndex => _watchlistIndex;
  void saveWatchlistIndex(int num) {
    _watchlistIndex = num;
    notifyListeners();
  }

  int _numManualPortfolios = 0;
  int get numManualPortfolios => _numManualPortfolios;
  void saveNumManualPortfolios(int num) {
    _numManualPortfolios = num;
    notifyListeners();
  }
//saveAccountIndex
  int _numLinkedAccounts = 0;
  int get numLinkedAccounts => _numLinkedAccounts;
  void saveNumLinkedAccounts(int num) {
    _numLinkedAccounts = num;
    notifyListeners();
  }
  
  int _accountIndex = 0;
  int get accountIndex => _accountIndex;
  void saveAccountIndex(int num) {
    _accountIndex = num;
    notifyListeners();
  }
//  // int _index;
//  // int get getIndex => _index;
//   void saveIndex(int index) {
//     _index = index;
//     notifyListeners();
//   }




}


