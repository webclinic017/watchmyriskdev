//import 'package:WMR/screens/authenticate/sign_in.dart';
//import 'package:WMR/shared/constants.dart';
import "package:flutter/material.dart";
import "package:flutter_swiper/flutter_swiper.dart";

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   // No Back Arrow
      //   titleSpacing: 0.0,
      //   automaticallyImplyLeading: false,
      //   //backgroundColor: Colors.lightBlueAccent[800],
      //   elevation: 0.0,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       FlatButton.icon(
      //           icon: Icon(Icons.home),
      //           label: Text('Home'),
      //           //onPressed: () => widget.toggleView(),
      //           onPressed: () {
      //             //Navigator.of(context).pushReplacementNamed('/about');
      //             Navigator.of(context).pushReplacementNamed('/sign_in');
      //           }),
      //       SizedBox(width: 20.0),
      //       FlatButton.icon(
      //           icon: Icon(Icons.skip_next_sharp),
      //           label: Text('Skip'),
      //           //onPressed: () => widget.toggleView(),
      //           onPressed: () {
      //             Navigator.of(context).pushReplacementNamed('/sign_in');
      //           }),
      //     ],
      //   ),

      //   // actions: <Widget>[
      //   //   FlatButton.icon(
      //   //       icon: Icon(Icons.person),
      //   //       label: Text('Register'),
      //   //       //onPressed: () => widget.toggleView(),
      //   //       onPressed: () {
      //   //         Navigator.of(context).pushReplacementNamed('/sign_on');
      //   //       }),
      //   // ],
      // ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            new Positioned.fill(
              child: new Image.asset(
                "assets/intro_bg.png",
                fit: BoxFit.fill,
                //alignment: Alignment.center,
              ),
            ),

            // new Image.asset(
            //       "assets/intro6.png",
            //       fit: BoxFit.fill,
            //       //alignment: Alignment.center,
            //     ),
            // Container(
            //   width: double.infinity,
            //   child: new DecoratedBox(
            //     decoration: new BoxDecoration(
            //       image: new DecorationImage(
            //         image: new AssetImage("assets/intro_bg.png"),
            //         fit: BoxFit.fill,
            //       ),
            //     ),
            //   ),
            // ),

            new Swiper.children(
              //control: SwiperControl(),
              onTap: (i) {
                if (i == 5) {
                  Navigator.of(context).pushReplacementNamed('/sign_in');
                }
              },
              autoplay: false,
              loop: false,
              pagination: new SwiperPagination(
                  margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                  builder: new DotSwiperPaginationBuilder(
                      color: Colors.grey[900],
                      activeColor: Colors.grey[500],
                      size: 8.0,
                      activeSize: 8.0)),
              children: <Widget>[
                new Image.asset(
                  "assets/intro1.png",
                  //fit: BoxFit.contain,
                  fit: BoxFit.fitHeight,
                  //fit: BoxFit.cover,
                  //height: 200,
                  //width: double.infinity,
                  alignment: Alignment.center,
                ),
                new Image.asset(
                  "assets/intro2.png",
                  //fit: BoxFit.fitWidth,

                  fit: BoxFit.fitHeight,
                  alignment: Alignment.center,
                ),
                new Image.asset(
                  "assets/intro3.png",
                  //fit: BoxFit.contain
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.center,
                ),
                new Image.asset(
                  "assets/intro4.png",
                  //fit: BoxFit.cover,
                  fit: BoxFit.fitHeight,

                  alignment: Alignment.center,
                ),
                new Image.asset(
                  "assets/intro5.png",
                  fit: BoxFit.fitHeight,
                  //fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
                new Image.asset(
                  "assets/intro6.png",
                //  fit: BoxFit.cover,
                  fit: BoxFit.cover,

                  alignment: Alignment.center,
                ),
                // Stack(
                //   children: <Widget>[
                //     Container(
                //       alignment: Alignment.center,
                //       child: Image.asset(
                //         "assets/intro6.png",
                //         fit: BoxFit.fitHeight,
                //         alignment: Alignment.center,
                //       ),
                //     ),
                //     Container(
                //         alignment: Alignment.bottomCenter,
                //         child: Padding(
                //           padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
                //           child: Text(
                //             'Click to start',
                //             style: TextStyle(
                //                 color: dbColor,
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 18.0),
                //           ),
                //         )),
                //   ],
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
