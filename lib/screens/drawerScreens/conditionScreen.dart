import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../providers/TraductionController.dart';
import '../../widgets/customAppBar.dart';
import 'package:flutter/material.dart';

/// affichage des conditions générales d'utilisations
class ConditionScreen extends StatefulWidget {
  static const routeName = 'condition.dart';

  ConditionScreen({Key key}) : super(key: key);

  @override
  _ConditionScreenState createState() => _ConditionScreenState();
}

class _ConditionScreenState extends State<ConditionScreen> {
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
          leading: CustomAppBar(from: '')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.all(4),
                    padding: EdgeInsets.all(4),
                    height: 45,
                    child: !trade
                        ? Text(
                            'Conditions Générales d\'Utilisation',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(209, 62, 150, 1),
                                fontFamily: 'myriad'),
                          )
                        : Text(
                            'Terms of service',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(209, 62, 150, 1),
                                fontFamily: 'myriad'),
                          )),
                StreamBuilder<Object>(
                    stream: !trade
                        ? FirebaseFirestore.instance
                            .collection('conditionsGenerale')
                            .doc('9gnuEHsn8hPLDFXFh87O')
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection('conditionsGenerale')
                            .doc('2xVuVVoD2MsLg0xcLlR1')
                            .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        String _text = snapshot.data.get('contenu');
                        List<String> _liste = _text.split('&title');
                        return Container(
                          height: MediaQuery.of(context).size.height -
                              100 -
                              kToolbarHeight,
                          child: ListView.builder(
                            itemCount: _liste.length,
                            itemBuilder: (ctx, index) => Center(
                              child: Container(
                                margin: EdgeInsets.all(3),
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  _liste[index],
                                  style: TextStyle(
                                      fontSize: index % 2 == 0 ? 17 : 19,
                                      color: index % 2 == 0
                                          ? Colors.black
                                          : Colors.blue[900],
                                      fontWeight: index % 2 == 0
                                          ? FontWeight.normal
                                          : FontWeight.w600,
                                      fontFamily: 'myriad'),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    }),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
