import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier{
   String earnings='0';
   void updateEarninigs(String newEarnings){
     earnings=newEarnings;
     notifyListeners();

   }
}