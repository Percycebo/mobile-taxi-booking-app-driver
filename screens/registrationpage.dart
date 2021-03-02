import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbtsdriver/Widgets/ProgressDialog.dart';
import 'package:mbtsdriver/Widgets/TaxiButton.dart';
import 'package:mbtsdriver/globalvariables.dart';
import 'package:mbtsdriver/screens/loginpage.dart';
import 'package:mbtsdriver/screens/mainpage.dart';
import 'package:mbtsdriver/brand_colors.dart';
import 'package:mbtsdriver/screens/vehicleinfo.dart';


class RegistrationPage extends StatefulWidget {
  static const String id='register';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<ScaffoldState> scaffoldKey =new GlobalKey<ScaffoldState>();

  void showSnackBar(String title){
    final snackbar=SnackBar(content: Text(title, textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),);
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var fullNameController= TextEditingController();

  var phoneController=TextEditingController();

  var emailController=TextEditingController();

  var passwordController=TextEditingController();

  void registerUser() async{
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context)=> ProgressDialog(status: 'Registering you',),
    );

    final User user=(await _auth.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )).user;

    if(user != null){
      DatabaseReference newUserRef= FirebaseDatabase.instance.reference().child('drivers/${user.uid}');

      Map useMap={
        'fullname':fullNameController.text,
        'email':emailController.text,
        'phone':phoneController.text,
        'status':'no',
      };
      newUserRef.set(useMap);
      currentFirebaseUser=user;
      Navigator.pushNamed(context, VehicleInfoPage.id);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 70,),
                Image(
                  alignment: Alignment.center,
                  height: 100.0,
                  width: 100.0,
                  image: AssetImage('images/logo.png'),
                ),
                SizedBox(height: 40,),

                Text('Create Driver Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: fullNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Full name',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize:10.0,
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10,),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: 'Phone',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize:10.0,
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10,),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email address',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize:10.0,
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10,),

                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize:10.0,
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 40,),

                      TaxiButton(
                        title:'REGISTER',
                        color: BrandColors.colorGreen,
                        onPressed: () async{
                          var connectivityResult= await Connectivity().checkConnectivity();
                          if(connectivityResult!=ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
                            showSnackBar('No internet Connectivity');
                            return;
                          }
                          if (fullNameController.text.length<3){
                            showSnackBar('Please provide a valid fullname');
                            return;
                          }
                          if(phoneController.text.length<10){
                            showSnackBar('Please provide a valid phone number');
                            return;
                          }
                          if(!emailController.text.contains('@')){
                            showSnackBar("Please provide a valid email");
                            return;
                          }
                          if(passwordController.text.length<8){
                            showSnackBar("Password must be at least 8 characters");
                            return;
                          }
                          registerUser();
                        },
                      ),
                    ],
                  ),
                ),

                FlatButton(
                    onPressed: (){
                      Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
                    },
                    child: Text('Already have Driver account? Log in')),
              ],
            ),
          ),
        )
    );
  }
}


