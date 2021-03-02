import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mbtsdriver/Widgets/BrandDivider.dart';
import 'package:mbtsdriver/Widgets/ProgressDialog.dart';
import 'package:mbtsdriver/Widgets/TaxiButton.dart';
import 'package:mbtsdriver/brand_colors.dart';
import 'package:mbtsdriver/datamodels/tripdetails.dart';
import 'package:mbtsdriver/globalvariables.dart';
import 'package:mbtsdriver/helpers/helpermethods.dart';
import 'package:mbtsdriver/screens/mainpage.dart';
import 'package:mbtsdriver/screens/newtrippage.dart';
import 'package:toast/toast.dart';

class NotificationDialog extends StatelessWidget {
  final TripDetails tripDetails;
  NotificationDialog({this.tripDetails});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 30,),
            Image.asset('images/taxi.png',width: 100,),
            SizedBox(height: 16,),
            Text('New Trip Request',style: TextStyle(fontFamily: 'Brand-Bold',fontSize: 18),),
            SizedBox(height: 30,),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset('images/pickicon.png',height: 16,width: 16,),
                      SizedBox(width: 18,),
                      Expanded(child: Container(child: Text(tripDetails.pickupAddress,style: TextStyle(fontSize: 18),))),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset('images/desticon.png',height: 16,width: 16,),
                      SizedBox(width: 18,),
                      Expanded(child: Container(child: Text(tripDetails.destinationAddress,style: TextStyle(fontSize: 18),))),
                    ],

                  ),
                  SizedBox(height: 15,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Shared:',style: TextStyle(fontSize: 18),),
                      SizedBox(width: 18,),
                      Expanded(child: Container(child: Text(tripDetails.rideSHareStatus,style: TextStyle(fontSize: 18),))),
                    ],

                  )

                ],

              ),
            ),
            BrandDivider(),
            SizedBox(height: 8,),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: TaxiButton(
                        title: 'Decline',
                        color: BrandColors.colorPrimary,
                        onPressed: (){
                          //assetsAudioPlayer.stop();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Container(
                      child: TaxiButton(
                        title: 'Accept',
                        color: BrandColors.colorGreen,
                        onPressed: (){
                          checkAvailability(context);
                          Navigator.pop(context);

                        },
                      ),
                    ),
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
  void checkAvailability(context){

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context)=> ProgressDialog(status: 'Fetching data',),
    );

    DatabaseReference newRideRef=FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}/newtrip');
    newRideRef.once().then((DataSnapshot snapshot){

      Navigator.pop(context);

      String thisRideID="";
      if(snapshot.value!=null){
        thisRideID=snapshot.value.toString();
      }
      else{
        print('ride not found');
      }

      if(thisRideID==tripDetails.rideID){
        newRideRef.set('accepted');

        Navigator.push(
          context,MaterialPageRoute(builder: (context)=>NewTripPage(tripDetails: tripDetails,)),
        );
        HelperMethods.disableHomeTabLocationUpdates();
      }
      else if(thisRideID=='cancelled'){
        Toast.show("ride has been cancelled", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }
      else if(thisRideID=='timeout'){
        Toast.show("ride has timed out", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
        print('ride has timed out');
      }
      else{
        Toast.show("ride not found", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }

    });
  }
}
