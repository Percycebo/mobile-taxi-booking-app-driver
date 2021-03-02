//import 'dart:js';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mbtsdriver/Widgets/ProgressDialog.dart';
import 'package:mbtsdriver/Widgets/dataprovider.dart';
import 'package:mbtsdriver/datamodels/directiondetails.dart';
import 'package:mbtsdriver/globalvariables.dart';
import 'package:mbtsdriver/helpers/services.dart';

import 'package:provider/provider.dart';


class HelperMethods{


  static Future<DirectionDetails> getDirectionDetails(LatLng startPosition,LatLng endPosition) async{
    String url='https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey';
    var response= await Services.getRequest(url);

    if(response=='failed'){
      return null;
    }
    DirectionDetails directionDetails=DirectionDetails();

    directionDetails.durationText=response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue=response['routes'][0]['legs'][0]['duration']['value'];

    directionDetails.distanceText=response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue=response['routes'][0]['legs'][0]['distance']['value'];

    directionDetails.encodedPoints=response['routes'][0]['overview_polyline']['points'];
    return directionDetails;
  }
  static int estimateFares(DirectionDetails details, int durationVal){
    //per km=R0.5
    //per min=R0.3
    //base fare=R5
    double baseFare=3;
    double distanceFare=(details.distanceValue/1000)*0.5;
    double timeFare=(durationVal/60)*0.3;
    double totalFare=baseFare+distanceFare+timeFare;
    return totalFare.truncate();
  }
  static double generateRandomNumber(int max){
    var randomGenerator=Random();
    int randInt=randomGenerator.nextInt(max);

    return randInt.toDouble();
  }
  static void disableHomeTabLocationUpdates(){
    homeTabPositionStream.pause();
    Geofire.removeLocation(currentFirebaseUser.uid);
  }
  static void enableHomeTabLocationUpdate(){
    homeTabPositionStream.resume();
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);
  }
  static void showProgressDialog(context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context)=>ProgressDialog(status: 'Please wait',),
    );
  }
  static void getHistoryInfo(context){
    DatabaseReference earningsRef=FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}/earnings');
    earningsRef.once().then((DataSnapshot snapshot) {
      if(snapshot.value != null){
        String earnings=snapshot.value.toString();
        Provider.of<AppData>(context,listen: false).updateEarninigs(earnings);
      }
    });
  }
}