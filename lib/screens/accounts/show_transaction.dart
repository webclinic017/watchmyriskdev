import 'package:flutter/material.dart';
import 'package:WMR/shared/constants.dart';



class  ShowTransaction extends StatelessWidget {
  ShowTransaction(this.tr,this.account,this.caller);

  final Map tr;
  final Map account;
  final String caller;
  final rw = w40;

  Widget showMinPct() {
    if (tr['rule'].containsKey('min')) {
      return
                Container(  
                  alignment: Alignment.centerLeft,
                  width:w80,
                  child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                  SizedBox(width:rw, child: Text("Min %:")),
                  Expanded(child: Text(tr['rule']['min']['user'].toString()))
                  ]),
                );
    } else {
      return SizedBox(width:0);
    }

  }

  Widget showMaxPct() {
    if (tr['rule'].containsKey('max')) {
      return
                Container(  
                  alignment: Alignment.centerLeft,
                  width:w80,
                  child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                  SizedBox(width:rw, child: Text("Max %:")),
                  Expanded(child: Text(tr['rule']['max']['user'].toString()))
                  ]),
                );
    } else {
      return SizedBox(width:0);
    }

  }

Widget showPricePct() {
    if (tr['rule'].containsKey('price_pct')) {
      return
                Container(  
                  alignment: Alignment.centerLeft,
                  width:w80,
                  child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                  SizedBox(width:rw, child: Text("% of price change:")),
                  Expanded(child: Text(tr['rule']['price_pct'].toString()))
                  ]),
                );
    } else {
      return SizedBox(width:0);
    }

  }

  Widget showVolumePct() {
    if (tr['rule'].containsKey('volume')) {
      return
                Container(  
                  alignment: Alignment.centerLeft,
                  width:w80,
                  child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                  SizedBox(width:rw, child: Text("% of volume change:")),
                  Expanded(child: Text(tr['rule']['volume']['pct'].toString()))
                  ]),
                );
    } else {
      return SizedBox(width:0);
    }

  }



  Widget drawRow(col1,col2) {
    return
                Container(  
                  alignment: Alignment.centerLeft,
                  width:w80,
                  child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                  SizedBox(width:rw, child: Text(col1)),
                  Expanded(child: Text(col2))
                  ]),
                );
              
            
            
  }
  
  Widget showPurchasedAt() {
  if (tr.containsKey('buy_price')) {
      return
                Container(  
                  alignment: Alignment.centerLeft,
                  width:w80,
                  child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                  SizedBox(width:rw, child: Text("Purchase price:")),
                  Expanded(child: Text(tr['buy_price'].toString()))
                  ]),
                );
    } else {
      return SizedBox(width:0);
    }
  }

  Widget showSoldAt() {
  if (tr.containsKey('sell_price')) {
      return
                Container(  
                  alignment: Alignment.centerLeft,
                  width:w80,
                  child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                  SizedBox(width:rw, child: Text("** Trigger price:")),
                  Expanded(child: Text(tr['sell_price'].toString()))
                  ]),
                );
    } else {
      return SizedBox(width:0);
    }
  }

  Widget showVolume() {
  if (tr.containsKey('volume')) {
      return
                Container(  
                  alignment: Alignment.centerLeft,
                  width:w80,
                  child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                  SizedBox(width:rw, child: Text("** Trigger volume:")),
                  Expanded(child: Text(tr['volume'].toString()))
                  ]),
                );
    } else {
      return SizedBox(width:0);
    }
  }
  
  @override
  Widget build(BuildContext context) {
  //print(tr);
  return Material(
        child: Scaffold( 
          
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0), // here the desired height
            
            child: AppBar( centerTitle: true,
             automaticallyImplyLeading: true,
             //title: Text("Rule Match Info",style: titleStyle(),),
             title: Column(
                children: <Widget>[
                  Text(
                    "$caller info",
                    style: white14Bold(),
                  ),
                  Text(
                    account['account_name'],
                    style: white_10(),
                  ),
                ],
              ),
            ),
          ),

      body: 
      SingleChildScrollView(
          child: 
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 40,0,20),
                child: Table(
                  // columnWidths: {
                  //       0: FlexColumnWidth(3),
                  //       1: FlexColumnWidth(7),   
                  //     },   
                  border: TableBorder.all(color:Colors.blueGrey),
                  children: [
                    TableRow(
                      children:[
                        Container(
                          //color:Colors.blueAccent,
                          alignment: Alignment.centerLeft,
                          width:w80,
                          child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                          SizedBox(width:rw, height:h3, child: Text("Symbol:", style:white14Bold())),
                          Expanded(child: Text(tr['ticker'], style:white14Bold()))
                          ]),
                        )
                      
                    ]),
                    TableRow(
                      children:[
                        Container(
                          
                          alignment: Alignment.centerLeft,
                          width:w80,
                          child: Row(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                          SizedBox(width:rw, child: Text("Date:")),
                          Expanded(child: Text(tr['date']))
                          ]),
                        )
                      
                    ]),
                    TableRow(
                      children:[
                        Container( 
                          alignment: Alignment.centerLeft,
                          width:w80,
                          child: Row(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                          SizedBox(width:rw, child: Text("Quantity:")),
                          Expanded(child: Text(tr['qty'].toString()))
                          ]),
                        )
                      
                    ]),
                    TableRow(
                      children:[
                        Container( 
                          alignment: Alignment.centerLeft,
                          width:w80,
                          child: Row(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                          SizedBox(width:rw, child: Text("Profit/Loss:")),
                          Expanded(child: Text(tr['pl_pc'].toString()))
                          ]),
                        )
                      
                    ]),
                    TableRow(
                      children:[
                      showPurchasedAt(),
                    ]),
                    TableRow(
                      children:[
                      showSoldAt(),
                    ]),
                    TableRow(
                      children:[
                      showVolume(),
                    ]),
                    
                    TableRow(
                      children:[
                        Container(  
                          alignment: Alignment.centerLeft,
                          width:w80,
                          child: Row(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                          SizedBox(width:rw, child: Text("* Rule:")),
                          Expanded(child: Text(tr['rule']['name']))
                          ]),
                        )
                      
                    ]),
                    TableRow(
                      children:[
                      drawRow("Rule description:",tr['rule']['description'])
                    ]),
                    TableRow(
                      children:[
                      drawRow("Notify only:",tr['rule']['notify_only'].toString())
                    ]),
                    TableRow(
                      children:[
                      drawRow("End-Of-Day only:",tr['rule']['eod_only'].toString())
                    ]),

                    TableRow(
                      children:[
                      showMinPct(),
                    ]),
                    TableRow(
                      children:[
                      showMaxPct(),
                    ]),
                    TableRow(
                      children:[
                      showPricePct(),
                    ]),
                    TableRow(
                      children:[
                      showVolumePct(),
                    ]),
                    
  
                  
                  ]   
              )
                  ),
                  SizedBox(height: h3,),

                  Text("Please note:", style:white14Bold()),
                  SizedBox(height: h1,),
                  Text("* The rule is what it was at the time of matching and could be different from what it is now if it is updated afterwards."),
                  SizedBox(height: h2,),
                  Text("** For the linked accounts, the trigger price/volume might not be the exact price/volume when your broker executed the sell order."),
                  SizedBox(height: h3,),
         
            ],
        ),
          ),
      )
        
                  
        
      
        )
    );
  }
}
