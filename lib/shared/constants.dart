import 'package:flutter/material.dart';
import 'package:super_rich_text/super_rich_text.dart';

//const gColor=Colors.amberAccent;
const gColor=Color(0xFF3be0bc);
const lbColor=Color(0xFF12aede);
const dbColor=Color(0xFF0569af);

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  //labelText:"Zia",
  filled: true,
  contentPadding: EdgeInsets.all(5.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 1.0),
  ),
);

TextStyle white_12() {
  return TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 1,
  );
}

TextStyle white_14() {
  return TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      letterSpacing: 1,
      fontFamily: 'Montserrat');
}

TextStyle white14Bold() {
  return TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
      fontFamily: 'Montserrat');
}

TextStyle white_10() {
  return TextStyle(
    color: Colors.white,
    fontSize: 10,
    fontWeight: FontWeight.normal,
    //letterSpacing: 1,
  );
}

TextStyle errorStyle() {
  return TextStyle(
      color: Colors.deepOrangeAccent,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
      fontFamily: 'Montserrat');
}

TextStyle infoStyle() {
  return TextStyle(
      color: lbColor,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
      fontFamily: 'Montserrat');
}

                      

TextStyle nameStyle() {
      return TextStyle(
      color: Colors.grey[300],
      fontSize: 12,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
      fontFamily: 'Montserrat',
      );
}



TextStyle titleStyle() {
  return TextStyle(
      color: Color(0xFF3be0bc),
      fontSize: 14,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
      fontFamily: 'Montserrat');
}

TextStyle inputStyle() {
  return TextStyle(
      color: Colors.deepOrangeAccent,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
      fontFamily: 'Montserrat');
}

void boldMarker(marker, color) {
    SuperRichText.globalMarkerTexts.add(MarkerText(
    marker: marker,
    style: TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
      fontFamily: 'Montserrat',
      )
    )
  );
}

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:WMR/shared/dart' as globals;


class SizeConfig {
 static MediaQueryData _mediaQueryData;
 static double screenWidth;
 static double screenHeight;
 static double blockSizeHorizontal;
 static double blockSizeVertical;
 
 void init(BuildContext context) {
  _mediaQueryData = MediaQuery.of(context);
  //print("Media Query: $_mediaQueryData");
  screenWidth = _mediaQueryData.size.width;
  screenHeight = _mediaQueryData.size.height;
  blockSizeHorizontal = screenWidth / 100;
  blockSizeVertical = screenHeight / 100;
  h1 = blockSizeVertical * 1;
  h2 = blockSizeVertical * 2;
  h3 = blockSizeVertical * 3;
  h4 = blockSizeVertical * 4;
  h5 = blockSizeVertical * 5;
  h10 = blockSizeVertical * 10;
  h15 = blockSizeVertical * 15;
  h20 = blockSizeVertical * 20;
  h30 = blockSizeVertical * 30;
  h40 = blockSizeVertical * 40;
  h50 = blockSizeVertical * 50;
  h60 = blockSizeVertical * 60;
  h70 = blockSizeVertical * 70;
  h80 = blockSizeVertical * 80;

  w1 = blockSizeHorizontal * 1;
  w2 = blockSizeHorizontal * 2;
  w3 = blockSizeHorizontal * 3;
  w4 = blockSizeHorizontal * 4;
  w5 = blockSizeHorizontal * 5;
  w10 = blockSizeHorizontal * 10;
  w15 = blockSizeHorizontal * 15;
  w20 = blockSizeHorizontal * 20;
  w30 = blockSizeHorizontal * 30;
  w40 = blockSizeHorizontal * 40;
  w50 = blockSizeHorizontal * 50;
  w60 = blockSizeHorizontal * 60;
  w70 = blockSizeHorizontal * 70;
  w80 = blockSizeHorizontal * 80;

 }
}

double h1;
double h2;
double h3;
double h4;
double h5;
double h10;
double h15;
double h20;
double h30;
double h40;
double h50;
double h60;
double h70;
double h80;

double w1;
double w2;
double w3;
double w4;
double w5;
double w10;
double w15;
double w20;
double w30;
double w40;
double w50;
double w60;
double w70;
double w80;

Future<void> showHelp(context, title, message, button) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
      
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          //insetPadding: EdgeInsets.only(left:50),
          titleTextStyle: white_14(),
          title: Container(
              //color:Colors.red,
              alignment: Alignment.center,
              child: Text(message)),
          //title: Text('Do you want to $action this item?'),
          actions: <Widget>[
            Container(
              //padding: EdgeInsets.only(right:100),
              //color:Colors.red,
              alignment: Alignment.centerRight,
              width: 400,
              //color:Colors.red,
              child: 
                    FlatButton(
                      child: Text(
                        button,
                        style: titleStyle(),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();

                      },
                    ),
                    //SizedBox(width:100),              
            )
          ]
        );
      }
    );
 }

 bool validate(_formKey) {
    final form = _formKey.currentState;
    //form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }