import 'package:flutter/material.dart';
import 'package:WMR/shared/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';


class Disclaimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold( 
          
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0), // here the desired height
            
            child: AppBar( centerTitle: true,
             automaticallyImplyLeading: true,
             title: Text("DISCLAIMER and RISK WARNING",
             style: white14Bold(),),
            ),
          ),

      body: 
      Container(
        padding: EdgeInsets.all(20.0),
        child: 
        SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            Text("Terms of use",
            style: titleStyle(),),
            SizedBox(height:10.0),
              
              AutoSizeText(
              "Your continued access and use of this application is conditional on your acceptance of and continued compliance with these Terms of Use. Any new features, functionality and/or content will also be subject to these Term of Use and any additional terms and conditions which will be notified from time to time. In addition to these Terms of Use and any additional terms and conditions, the Privacy Policy will govern how your personal information will be used on this application, and together they form the agreement between you and us (the “Agreement”). Nothing in this Agreement will be deemed to confer any third-party rights or benefits.",
              style: white_14(),
              ),

            SizedBox(height:10.0),
            Text("THIS AGREEMENT CONTAINS DISCLAIMER AND OTHER PROVISIONS THAT LIMIT OUR LIABILITY TO YOU.",
            style: white14Bold(),),
            SizedBox(height:10.0),

            AutoSizeText("By accessing, browsing, using and/or downloading the pages in this application, you agree to accept and comply with this Agreement for each use and visit to this application. If you do not agree to accept and comply with this Agreement, you should not access, browse or otherwise use this application."),
            SizedBox(height:10.0),
            Text("Watchmyrisk reserves the right, at any time, to modify, alter, or update this Agreement, and you agree to be bound by such modifications, alterations, or updates. Such modifications, alterations, and updates shall be effective immediately upon posting. You agree to be bound by such modified, altered, and updated Terms of Use if You access or use this application after We have posted notice of such modifications, alterations or updates."),
            SizedBox(height:10),  
            Text("You agree to regularly review this Agreement and to be aware of such revisions.",
            style: white14Bold(),),
            SizedBox(height:10),
            AutoSizeText("Your use of this application following any such change constitutes your agreement to follow and be bound by this Agreement as changed. Content and Intellectual Property. Unless otherwise stated, the content of this application including, but not limited to, the text , audio, video, html code, buttons and graphic images contained herein and their arrangement is our property or that of our licensors, and may not be copied, reproduced, republished, uploaded, posted, transmitted, or distributed in any way, without the prior written consent of the proper owner."), 
            AutoSizeText("All trademarks used or referred to in this application are the property of their respective owners. Nothing contained in this application shall be construed as conferring any license or right to any our copyright, patent, trademark or other proprietary interests or any third party. This application and the content provided in this application, including, but not limited to, graphic images, audio, video, html code, buttons, and text, may not be copied, reproduced, republished, uploaded, posted, transmitted, or distributed in any way, without our prior written consent, except that you may download, display, and print one copy of the materials on any single device solely for your personal, non-commercial use, provided that you do not modify the material in any way and you keep intact all copyright, trademark, and other proprietary notices. Except as expressly provided for in these Terms of Use, you acquire no rights in or to this application.",
            style: white_14(),),
            SizedBox(height:10.0),
            
            Text("Your Usage",
            style: titleStyle(),),
            SizedBox(height:10.0),
            Text("You hereby confirm that you will comply with the following requirements in accessing and using this application:",
            style: white_14(),),
            SizedBox(height:10.0),

            Padding(
              padding: const EdgeInsets.fromLTRB(12.0,0,0,0),
              child: Text("i. You are responsible for protecting your personal information."),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0,0,0,0),
              child: Text("ii. You are responsible for selecting/editing rules applied to your brokerage accounts."),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0,0,0,0),
              child: Text("iii. Due to the nature of market volatility and brokerages’ trade execution priorities, watchmyrisk cannot guarantee a timely order execution."),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0,0,0,0),
              child: Text("iv. Due to the nature of market volatility and brokerages’ trade execution priorities, watchmyrisk cannot guarantee an exact price for its order execution."),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0,0,0,0),
              child: Text("v. Depending on the load on the system, watchmyrisk may encounter delay in applying your rules to your brokerage account(s) and subsequently resulting in not so perfect order execution."),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0,0,0,0),
              child: Text("vi. watchmyrisk is not responsible for delays caused by your brokerage company."),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0,0,0,0),
              child: Text("vii. watchmyrisk is not responsible for downtime of your brokerage APIs."),
            ),
             SizedBox(height: 10.0),

                    Text(
                      "Billing",
                      style: titleStyle(),
                    ),
                    Text(
                      
                          "Unpaid linked accounts or manual portfolios will be suspended after a week. Upon suspensention, no new rule matching will be performed.",
                      style: white_12(),
                    ),

          ],),
        ),
      )
      
        )
    );
  }
}