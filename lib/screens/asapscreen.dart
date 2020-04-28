import 'package:asap_app/services/crud.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _startingDate;
  DateTime _endingTime;
  crudmethods crudObj = crudmethods();

// launch the calender
  _launcCalender(
      {@required String eventName,
      String eventDesc,
      @required dynamic eventStarting,
      @required dynamic eventEnding}) async {
    String url =
        'https://www.google.com/calendar/render?action=TEMPLATE&text=${eventName}&dates=${eventStarting}/${eventEnding}Z&details=${eventDesc}&sf=true&output=xml';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget image_carousel = Container(
      height: 200,
      child: Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('assets/web1.png'),
          AssetImage('assets/webinar2.png'),
        ],
        autoplay: false,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
      ),
    );
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'ASAP',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: <Widget>[],
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Webinar Series',
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ),
            image_carousel,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Classes',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                height: 600,
                color: Colors.white,
                child: StreamBuilder(
                  stream: Firestore.instance.collection('testcrud').snapshots(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, i) {
                          if (snapshot.data.documents[i].data['startingDate'] !=
                              null) {
                            _startingDate = DateTime.parse(snapshot
                                .data.documents[i].data['startingDate']
                                .toDate()
                                .toString());
                            print(_startingDate);
                          }
                          if (snapshot.data.documents[i].data['endingDate'] !=
                              null) {
                            _endingTime = DateTime.parse(snapshot
                                .data.documents[i].data['endingDate']
                                .toDate()
                                .toString());
                            print(_startingDate);
                          }

                          return Container(
                            margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 10.0),
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 1.0),
                                      blurRadius: 6.0)
                                ]),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 10,
                                ),
                                ClipRect(
                                  child: Image(
                                    height: 150,
                                    width: 110,
                                    image: AssetImage('assets/class1.jpeg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      'Subject:${snapshot.data.documents[i].data['subject']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                        'Topic:${snapshot.data.documents[i].data['topic']}'),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                        'Module ${snapshot.data.documents[i].data['mno']}'),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                        'By ${snapshot.data.documents[i].data['instructor']}'),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                        'Dept:${snapshot.data.documents[i].data['dept']}'),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                        'Semister ${snapshot.data.documents[i].data['sno']}'),
                                    Container(
                                      width: 130,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      child: Center(
                                          child: Text(
                                              '$_startingDate - $_endingTime')),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  },
                ))
          ],
        ),
      ),
    );
  }
}
