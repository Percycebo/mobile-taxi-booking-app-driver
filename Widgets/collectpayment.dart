import 'package:flutter/material.dart';
import 'package:mbtsdriver/Widgets/BrandDivider.dart';
import 'package:mbtsdriver/Widgets/TaxiButton.dart';
import 'package:mbtsdriver/brand_colors.dart';
import 'package:mbtsdriver/helpers/helpermethods.dart';

class CollectPayment extends StatelessWidget {
  final String paymentMethod;
  final int fares;

  CollectPayment({this.paymentMethod,this.fares});


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4)
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Text('${paymentMethod} PAYMENT'),
            SizedBox(height: 20,),
            BrandDivider(),
            SizedBox(height: 16,),
            Text('\R${fares}', style: TextStyle(fontFamily: 'Brand-Bold',fontSize: 50),),
            SizedBox(height: 16,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Amount above is the total fare to be charged to the rider', textAlign: TextAlign.center,),
            ),
            SizedBox(height: 30,),
            Container(
              width: 230,
              child: TaxiButton(
                title: (paymentMethod=='cash')?'COLLECT CASH':'CONFIRM',
                color: BrandColors.colorGreen,
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);

                  HelperMethods.enableHomeTabLocationUpdate();

                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
