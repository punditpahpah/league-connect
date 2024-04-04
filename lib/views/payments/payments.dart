import 'package:flutter/material.dart';
import 'package:dating_app/theme/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Payments extends StatefulWidget {
  
  

  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  String status="Nope.";
  Future<bool> _willPopCallback() async{
    Navigator.pop(context,status);
    return true;
  }
  @override
  Widget build(BuildContext context) {
    ProgressDialog dialog = new ProgressDialog(context);
    return WillPopScope(
      onWillPop:_willPopCallback, 
    child:Scaffold(
       appBar: AppBar(
         title:Text('Pay with PayPal'),
       ),
       body: WebView(
         initialUrl: 'https://bcesystem.com/loteria/loteria/payments/league.php?user_id=1&number_id=1&number_name=1&price=60',
          javascriptMode: JavascriptMode.unrestricted,
           onPageStarted: (String url) {
             dialog.style(message:'Please wait....');
              dialog.show();
            // Fluttertoast.showToast(
            //   msg: "$url",
            //   toastLength: Toast.LENGTH_SHORT,
            //   gravity: ToastGravity.CENTER,
            //   backgroundColor: Colors.red,
            //   textColor: Colors.white,
            //   fontSize: 16.0);
            if(url.contains("Oncancel.php")){
              status="Nope.";
              Navigator.pop(context, 'Nope.');
              Navigator.pop(context, 'Nope.');
            }
            else if(url.contains("success.php")){
              status="Done.";
              Navigator.pop(context, 'Done.');
              Navigator.pop(context, 'Done.');
            }
          },
          onPageFinished:(String url){
            dialog.hide();
          }
          
       ),
    ),
    );
  }
}