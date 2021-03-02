
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mbtsdriver/Widgets/TaxiButton.dart';
import 'package:mbtsdriver/brand_colors.dart';
import 'package:mbtsdriver/globalvariables.dart';
import 'package:mbtsdriver/screens/mainpage.dart';

class VehicleInfoPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey =new GlobalKey<ScaffoldState>();

  void showSnackBar(String title){
    final snackbar=SnackBar(content: Text(title, textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),);
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  static const String id='vehicleinfo';
  var carModelController=TextEditingController();
  var carColorController=TextEditingController();
  var vehicleNumberController=TextEditingController();

  void updateProfile(context){
    String id=currentFirebaseUser.uid;
    DatabaseReference driveRef=FirebaseDatabase.instance.reference().child('drivers/$id/vehicle_details');
    Map map={
      'car_color':carColorController.text,
      'car_model':carModelController.text,
      'vehicle_number':vehicleNumberController.text,
    };
    driveRef.set(map);
    Navigator.pushNamed(context, MainPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              Image.asset('images/logo.png',height: 110,width: 110,),
              Padding(
                padding:  EdgeInsets.fromLTRB(30,20,30,30),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    Text('Enter vehicle details',style: TextStyle(fontFamily: 'Brand-Bold',fontSize: 22),),
                    SizedBox(height: 20,),
                    TextField(
                      controller: carModelController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Car model',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10,),

                    TextField(
                      controller: carColorController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Car color',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      controller: vehicleNumberController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Vehicle number',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 40,),
                    TaxiButton(
                      color: BrandColors.colorAccent,
                      title:'PROCEED' ,
                      onPressed: (){
                        if(carModelController.text.length<3){
                          showSnackBar('Please provide a valid car model');
                        }
                        if(carColorController.text.length<3){
                          showSnackBar('Please provide a valid car color');
                        }
                        if(vehicleNumberController.text.length<3){
                          showSnackBar('Please provide a valid vehicle number');
                        }
                        updateProfile(context);

                      },
                    )
                  ],
                ),
              )
            ],
            
          ),
        ),
      )
    );
  }
}
