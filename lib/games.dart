import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gammingwallpaper/categorywise.dart';
import 'package:gammingwallpaper/fullscreen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Games extends StatefulWidget {
  @override
  _GamesState createState() => _GamesState();
}

class _GamesState extends State<Games> {

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    init();
  }
  init()async{
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      debugPrint('mobile');
      setState(() {

      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      debugPrint('wifi');
      setState(() {

      });
      // I am connected to a wifi network.
    }
    else
    {
      Fluttertoast.showToast(
          msg: "Check Internet Connection",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          bgcolor: "#000000",
          textcolor: '#ffffff'
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.orange.shade50,
      child: StreamBuilder(
          stream: Firestore.instance.collection('category').orderBy("url",descending: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return new Center(child: CircularProgressIndicator(),);
            return new StaggeredGridView.countBuilder(
              padding: const EdgeInsets.all(0.0),
              crossAxisCount: 4,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, i) {
                String imgPath = snapshot.data.documents[i]['url'];
                debugPrint(i.toString()+"/////////////"+imgPath);
                String imagename=snapshot.data.documents[i]['cat'];
                String id=snapshot.data.documents[i].documentID;
                return new Material(
                  elevation: 5.0,
                  borderRadius:
                  new BorderRadius.all(new Radius.circular(5.0)),
                  child: new InkWell(
                      onTap: () {

                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                new CategoryWise(imagename)));
                      },
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            height: MediaQuery.of(context).size.height/3-20,
                            width: MediaQuery.of(context).size.width,
                            child: Hero(
                              tag: imgPath,
                              child:
                              new FadeInImage(
                                image: new NetworkImage(imgPath),
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width/2,


                                placeholder: new AssetImage("assets/images.png"),
                              ),
                            ),
                          ),

                          new Container(
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Padding(padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 2.0)
                                  ,child: new Text(snapshot.data.documents[i]['cat'],textAlign: TextAlign.start,),
                                ),


                              ],
                            ),
                          )

                        ],
                      )
                  ),
                );
              },
              staggeredTileBuilder: (i) =>
              new StaggeredTile.count(4, i.isEven ? 2.5 : 2.5),
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 5.0,
            );

          }),
    );
  }
}
