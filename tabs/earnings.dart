import 'package:flutter/material.dart';
import 'package:mbtsdriver/Widgets/BrandDivider.dart';
import 'package:mbtsdriver/Widgets/dataprovider.dart';
import 'package:mbtsdriver/brand_colors.dart';
import 'package:provider/provider.dart';

class EarningsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: BrandColors.colorPrimary,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: [
                Text('Total Earnings', style: TextStyle(color: Colors.white),),
                Text('\R${Provider.of<AppData>(context).earnings}', style: TextStyle(color: Colors.white,
                    fontSize: 40,
                    fontFamily: 'Brand-Bold'),)
              ],
            ),
          ),
        ),
        FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: null,
            color: BrandColors.colorGreen,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 18),
              child: Row(
                children: [
                  Image.asset('images/taxi.png', width: 70,),
                  SizedBox(width: 16,),
                  Text('Trips', style: TextStyle(fontSize: 16),),
                  Expanded(child: Container(child: Text(
                    '3', textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 18),))),
                ],
              ),
            )),
        BrandDivider(),
      ],
    );
  }
}
