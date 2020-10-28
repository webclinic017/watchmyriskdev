//import 'package:WMR/screens/accounts/holdings.dart';
import 'package:flutter/material.dart';
//import 'package:WMR/models/accounts.dart';
import 'package:WMR/screens/rules/rules.dart';
import 'package:WMR/screens/accounts/edit_watchlist.dart';

import 'package:flutter_icons/flutter_icons.dart';
import 'package:WMR/shared/storage.dart';

SS _storage = SS();


//import 'package:WMR/shared/loading.dart';
//import 'package:WMR/shared/globals.dart' as globals;
//import 'package:provider/provider.dart';

class WatchlistTile extends StatefulWidget {
  final Map account;
  final int index;
  final bool isSelected;
  final VoidCallback onSelect;

  const WatchlistTile({
    Key key,
    @required this.account,
    @required this.index,
    @required this.isSelected,
    @required this.onSelect,
  })  : assert(index != null),
        assert(isSelected != null),
        assert(onSelect != null),
        assert(account != null),
        super(key: key);

  @override
  _WatchlistTileState createState() => _WatchlistTileState();
}

Widget showEdit(account, context) {
  if (account['is_active'] == true) {
    return (IconButton(
        icon: Icon(FlutterIcons.sound_mix_ent),
        tooltip: 'Rules',
        color: Colors.white,
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Rules(account: account),
              ));
        }));
    //globals.account = account;
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) =>
    //         //Rules(accountId: account['account_id']))
    //         Rules(),
    //     settings: RouteSettings(
    //       arguments: account,
    //     ),
    //   ),
    // );
    //},
    //)); // icon-1
  } else {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      //child: Card(
      //margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
      child: Text(
        "Disabled",
        textAlign: TextAlign.left,
        //overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
          letterSpacing: 1,
        ),
      ),
    );
  }
}



class _WatchlistTileState extends State<WatchlistTile> {
  @override
  Widget build(BuildContext context) {
    //dynamic wp = Provider.of<WmrProviders>(context);

    //print("Rebuilding Watchlist Widget");
    //globals.tabIndex = 1;
    dynamic assetImg = 'watchlist.jpg';
    //void onSelect = widget.onSelect;

    return GestureDetector(
      onTap: widget.onSelect,

      // onTap: () async {
      //   onSelect;
      //   await Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) =>
      //             Holdings(),
      //       ));
      // },

      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20.0,
            backgroundImage: AssetImage('assets/$assetImg'),
          ),
          // title: Text("Title ${widget.index}"),
          // subtitle: Text("Description ${widget.index}"),
          title: Text(
            widget.account['account_name'],
            textAlign: TextAlign.left,
            //overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey[300],
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              letterSpacing: 1,
            ),
          ),
          //subtitle: Text(widget.account['broker']),
          trailing: Wrap(
            //mainAxisSize: MainAxisSize.min,
            spacing: 10, // space between two icons
            children: <Widget>[
              showEdit(widget.account, context),
              //SizedBox(width:5.0,),
              IconButton(
                  //icon: Icon(Icons.settings),
                  
                  icon: Icon(FlutterIcons.edit_ant),

                  tooltip: 'Settings',
                  color: Colors.white,
                  onPressed: () async {
                    //globals.account = widget.account;
                    
                    await _storage.write('watchlist', widget.account);
        
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditWatchlist(account: widget.account),
                        ));
                  })
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         //Rules(accountId: account['account_id']))
              //         EditWatchlist(),
              //     settings: RouteSettings(
              //       arguments: widget.account,
              //     ),
              //   ),
              // );
              //}),
              //showHolding(widget.account, context),
            ],
          ),
        ),
        decoration: widget.isSelected
            ? BoxDecoration(color: Colors.grey[700])
            : BoxDecoration(),
      ),
    );
  }
}
