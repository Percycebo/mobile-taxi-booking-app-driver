import 'package:flutter/material.dart';
import 'package:mbtsdriver/Widgets/TaxiOutlineButton.dart';
import 'package:mbtsdriver/brand_colors.dart';

class ConfirmSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onPressed;

  ConfirmSheet({this.title,this.subtitle,this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              spreadRadius: 0.5,
              offset: Offset(
                0.7,
                0.7,
              )
          )
        ]
    ),
      height: 220,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal:24, vertical: 18 ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10,),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22,fontFamily: 'Brand-Bold',color: BrandColors.colorDimText),
            ),
            SizedBox(height: 20,),
            Text(subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: BrandColors.colorTextLight),),
            SizedBox(height: 20,),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: TaxiOutlineButton(
                      title: 'BACK',
                      color: BrandColors.colorLightGrayFair,
                      onPressed:(){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                SizedBox(width: 16,),
                Expanded(
                  child: Container(
                    child: TaxiOutlineButton(
                      title: 'CONFIRM',
                      color: BrandColors.colorGreen,
                      onPressed: onPressed,
                    ),
                  ),
                ),

              ],
            )

          ],
        ),
      ),

    );
  }
}
