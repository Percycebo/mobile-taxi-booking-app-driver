
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:mbtsdriver/Widgets/BrandDivider.dart';
import 'package:mbtsdriver/brand_colors.dart';
import 'package:mbtsdriver/globalvariables.dart';
import 'package:mbtsdriver/screens/loginpage.dart';
import 'package:mbtsdriver/tabs/earnings.dart';
import 'package:mbtsdriver/tabs/hometab.dart';
import 'package:mbtsdriver/tabs/profile.dart';
import 'package:mbtsdriver/tabs/ratings.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class MainPage extends StatefulWidget {
  static const String id='mainpage';
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin{
  TabController tabController;
  int selectedIndex=0;
  void onItemClicked(int index){
    setState(() {
      selectedIndex=index;
      tabController.index=selectedIndex;
    });
  }
  @override
  void initState(){
    tabController=TabController(length: 4, vsync: this);
  }
  void dispose(){
    tabController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        width: 250,
        color: Colors.white,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              Container(
                height: 160,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: <Widget>[
                      Image.asset('images/user_icon.png',height: 60,width: 60,),
                      SizedBox(width: 15,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text((currentDriverInfo==null)?'User':currentDriverInfo.fullName,style: TextStyle(fontSize: 20,fontFamily: 'Brand-Bold'),),
                          SizedBox(height: 5,),
                          Text('View Proifle'),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              BrandDivider(),
              SizedBox(height: 10,),

              ListTile(
                leading: Icon(OMIcons.history),
                title: Text('Trip History',),
              ),
              ListTile(
                leading: Icon(OMIcons.info),
                title: Text('About',),
              ),
              SizedBox(height: 200,),
              BrandDivider(),
              ListTile(
                leading: Icon(Icons.arrow_back),
                title: Text('Sign Out', ),
                onTap: (){
                  Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
                },
              ),
            ],
          ),

        ),
      ),

        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: tabController,
          children: <Widget>[
            HomeTab(),
            EarningsTab(),
            RatingsTab(),
            ProfileTab(),
          ],
        ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Earnings',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.star),
          //   label: 'Ratings',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: 'Profile',
          // ),

        ],
        currentIndex: selectedIndex,
        unselectedItemColor:BrandColors.colorIcon,
        selectedItemColor: BrandColors.colorOrange,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        onTap: onItemClicked,
      ),
    );
  }

}
