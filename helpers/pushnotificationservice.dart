
//import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mbtsdriver/Widgets/ProgressDialog.dart';
import 'package:mbtsdriver/Widgets/notificationdialog.dart';
import 'package:mbtsdriver/datamodels/tripdetails.dart';
import 'package:mbtsdriver/globalvariables.dart';

class PushNotificationService{
  final FirebaseMessaging fcm=FirebaseMessaging();
  Future initialize(context)async{
    print('Hello are you in there');
    fcm.configure(
      //onBackgroundMessage: myBackgroundMessageHandler,
      onMessage: (Map<String, dynamic> message) async {
        fetchRideInfo(getRideID(message),context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        fetchRideInfo(getRideID(message),context);
      },
      onResume: (Map<String, dynamic> message) async {
        fetchRideInfo(getRideID(message),context);
      },
    );
  }
  Future<String> getToken()async{
    String token=await fcm.getToken();
    print('token: $token');
    DatabaseReference tokenRef=FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}/token');
    tokenRef.set(token);
    fcm.subscribeToTopic('alldrivers');
    fcm.subscribeToTopic('allusers');
  }
  String getRideID(Map<String, dynamic> message){
    String rideID=message['data']['ride_id'];
    print('Ride_ID: $rideID');

    return rideID;
  }
  void fetchRideInfo(String rideID,context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context)=> ProgressDialog(status: 'Fetching data',),
    );
    DatabaseReference rideRef=FirebaseDatabase.instance.reference().child('rideRequest/$rideID');
    rideRef.once().then((DataSnapshot snapshot) {
      //print('print $rideID');
      Navigator.pop(context);
      if(snapshot.value!=null){

        // assetsAudioPlayer.open(
        //   Audio('sonds/alert.mp3'),
        // );
        //assetsAudioPlayer.play();
        double pickupLat=double.parse(snapshot.value['location']['latitude'].toString());
        double pickupLng=double.parse(snapshot.value['location']['longitude'].toString());
        String pickupAddress=snapshot.value['pickup_address'].toString();

        double destinationLat=double.parse(snapshot.value['location']['latitude'].toString());
        double destinationLng=double.parse(snapshot.value['location']['longitude'].toString());
        String destinationAddress=snapshot.value['destination_address'].toString();
        String paymentMethod=snapshot.value['payment_method'].toString();
        String riderName=snapshot.value['rider_name'];
        String riderPhone=snapshot.value['rider_phone'];
        String rideShare=snapshot.value['rideshare'];
        String seconfriderName=snapshot.value['2ndridername'];

        TripDetails tripDetails=TripDetails();
        tripDetails.rideID=rideID;
        tripDetails.pickupAddress=pickupAddress;
        tripDetails.destinationAddress=destinationAddress;
        tripDetails.pickup=LatLng(pickupLat, pickupLng);
        tripDetails.destination=LatLng(destinationLat, destinationLng);
        tripDetails.paymentMethod=paymentMethod;
        tripDetails.riderName=riderName;
        tripDetails.riderPhone=riderPhone;
        tripDetails.rideSHareStatus=rideShare;
        tripDetails.secondRiderName=seconfriderName;
        print(tripDetails.destinationAddress);
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context)=>NotificationDialog(tripDetails: tripDetails,));
      }
    });
  }

}