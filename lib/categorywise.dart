import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gammingwallpaper/fullscreen.dart';
class CategoryWise extends StatefulWidget {
  String imagename;

  CategoryWise(this.imagename);
  @override
  _CategoryWiseState createState() => _CategoryWiseState();
}

class _CategoryWiseState extends State<CategoryWise> {

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
    return new Scaffold(
      appBar:AppBar(
         title: new Text(widget.imagename),
      ),
      body:  new Container(
        color: Colors.orange.shade50,
        child: StreamBuilder(
            stream: Firestore.instance.collection('image').where("cat",isEqualTo: widget.imagename).orderBy("url",descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return new Center(child: CircularProgressIndicator());
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
                                  new FullScreenImagePage(imgPath,imagename,id)));
                        },
                        child: new Column(
                          children: <Widget>[
                            new Hero(
                              tag: imgPath,
                              child:
                              new FadeInImage(
                                image: new NetworkImage(imgPath),
                                height: 282.0,
                                width: MediaQuery.of(context).size.width/2,
                                fit: BoxFit.cover,

                                placeholder: new AssetImage("assets/images.png"),
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
                new StaggeredTile.count(2, i.isEven ? 3.5 : 3.5),
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
              );

            }),
      ),
    );
  }
}
