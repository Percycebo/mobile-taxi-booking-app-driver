import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mbtsdriver/Widgets/AvailabilityButton.dart';
import 'package:mbtsdriver/Widgets/ConfirmSheet.dart';
import 'package:mbtsdriver/Widgets/TaxiButton.dart';
import 'package:mbtsdriver/Widgets/notificationdialog.dart';
import 'package:mbtsdriver/brand_colors.dart';
import 'package:mbtsdriver/datamodels/driver.dart';
import 'package:mbtsdriver/globalvariables.dart';
import 'package:mbtsdriver/helpers/helpermethods.dart';
import 'package:mbtsdriver/helpers/pushnotificationservice.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GoogleMapController mapController;
  Completer<GoogleMapController>_controller=Completer();


  DatabaseReference tripRequestRef;
  Geolocator geoLocator;
  var locationOptions=LocationOptions(accuracy: LocationAccuracy.bestForNavigation,distanceFilter: 4);

  String availabilityTitle='GO ONLINE';
  Color availabilityColor=BrandColors.colorOrange;
  bool isAvailable=false;
  bool isApproved=false;

  void getCurrentPosition()async{
    Position position= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition=position;
    LatLng pos= LatLng(position.latitude, position.longitude);
    CameraPosition cp= new CameraPosition(target: pos);
    //mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
    mapController.animateCamera(CameraUpdate.newLatLng(pos));
  }
  void getCurrentDriverInfo()async{
    currentFirebaseUser=await FirebaseAuth.instance.currentUser;
    DatabaseReference driverRef=FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}');
    driverRef.once().then((DataSnapshot snapshot) {
      if(snapshot.value != null){
        currentDriverInfo=Driver.fromSnapshot(snapshot);
      }

    });
    PushNotificationService pushNotificationService=PushNotificationService();

    pushNotificationService.initialize(context);
    pushNotificationService.getToken();
    HelperMethods.getHistoryInfo(context);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentDriverInfo();
  }
  @override
  Widget build(BuildContext context) {
    getCurrentDriverInfo();
    return Stack(
      children: <Widget>[
        GoogleMap(
          padding: EdgeInsets.only(top: 135),
          initialCameraPosition: googlePlex,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
            mapController=controller;

            getCurrentPosition();
          },
        ),
        Container(
          height: 135,
          width: double.infinity,
          color: BrandColors.colorPrimary,
        ),
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AvailabilityButton(
                title: availabilityTitle,
                color: availabilityColor,
                onPressed: (){

                  showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (BuildContext context)=>ConfirmSheet(
                        title: (!isAvailable)?'GO ONLINE':'GO OFFLINE',
                        subtitle: (!isAvailable)? 'You are about to become available online':'You will stop receiving trip requests',
                        onPressed: (){
                          checkIFapproved();
                          if(!isAvailable && isApproved){
                            GoOnline();
                            getLocationUpdates();
                            Navigator.pop(context);

                            setState(() {
                              availabilityColor=BrandColors.colorGreen;
                              availabilityTitle='GO OFFLINE';
                              isAvailable=true;
                            });
                          }
                          else{
                            GoOffline();
                            Navigator.pop(context);
                            setState(() {
                              availabilityColor=BrandColors.colorOrange;
                              availabilityTitle='GO ONLINE';
                              isAvailable=false;
                            });

                          }
                        },
                      ),
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }
  void GoOnline(){
    Geofire.initialize('driversAvailable');
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);
    tripRequestRef=FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}/newtrip');
    tripRequestRef.set('waiting');
    tripRequestRef.onValue.listen((event) {

    });
  }
  void GoOffline(){
    Geofire.removeLocation(currentFirebaseUser.uid);
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
    tripRequestRef=null;
  }
  void getLocationUpdates(){
    StreamSubscription<Position> homeTabPositionStream;
    homeTabPositionStream=Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.bestForNavigation,distanceFilter: 4 ).listen((Position position) {
      currentPosition=position;
      if(isAvailable){
        Geofire.setLocation(currentFirebaseUser.uid, position.latitude, position.longitude);
      }
      LatLng pos= LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(pos));

    });
  }
  void checkIFapproved(){
    DatabaseReference rideIDDs= FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}');
    rideIDDs.once().then((DataSnapshot snapshot) {
      if(snapshot.value['status']=='yes'){
        isApproved=true;
      }
      else{
        isApproved=false;
        Navigator.pop(context);
      }
    });
  }

}
