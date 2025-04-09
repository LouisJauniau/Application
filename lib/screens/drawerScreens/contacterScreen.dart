import 'package:provider/provider.dart';

import '../../providers/TraductionController.dart';
import '../../widgets/customAppBar.dart';
import 'package:flutter/material.dart';

/// affchage de la fenetre contacter nous (avec le mail de contact)
class ContacterScreen extends StatefulWidget {
  static const routeName = '/contacter.dart';

  ContacterScreen({Key key}) : super(key: key);

  @override
  contacterScreenState createState() => contacterScreenState();
}

class contacterScreenState extends State<ContacterScreen> {
  @override
  Widget build(BuildContext context) {
    var trade =
        Provider.of<TraductionController>(context, listen: false).trade.value ??
            false;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leadingWidth: 100,
          leading: CustomAppBar(
            from: '',
          ),
        ),
        body: Column(children: [
          SizedBox(height: 200),
          Container(
            //color: Colors.white,
            width: double.infinity,
            child: Center(
              child: Container(
                height: 300,
                width: 250,
                child: !trade
                    ? Text(
                        'Merci de nous contacter à l\'adresse suivante : \n auraguidearchitecture@gmail.com',
                        style: TextStyle(fontFamily: 'myriad', fontSize: 23),
                      )
                    : Text(
                        'Please contact us at the following address :\n auraguidearchitecture@gmail.com',
                        style: TextStyle(fontFamily: 'myriad', fontSize: 23),
                      ),
              ),
            ),
          ),
        ]));
  }
}
