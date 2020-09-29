import 'package:flutter/material.dart';
import 'package:gammingwallpaper/databasehelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gammingwallpaper/fullscreen.dart';
import 'package:gammingwallpaper/model.dart';
class Favorit extends StatefulWidget {
  @override
  _FavroitState createState() => _FavroitState();
}

class _FavroitState extends State<Favorit> {



  List data=[];
  bool flag=false;

  @override
  void initState() {
    // TODO: implement initState
    getdata();

  }


  getdata() async {
    //debugPrint(id);
    var db=new DatabaseHelper();
    data = await db.getAllUsers();
    for (int i = 0; i < data.length; i++) {
      debugPrint(i.toString());
    }
    if(data.length==0)
      {
        flag=true;
      }

setState(() {

});



//    setState(() {
//      _subType=dataaa;
//    });


  }
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.orange.shade50,
      child: data.length!=0?new StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(0.0),
        crossAxisCount: 4,
        itemCount: data.length,
        itemBuilder: (context, i) {
          //   getdata(dataa[i]['favId']);

          String imgPath = data[i]['url'];
          debugPrint(i.toString()+"/////////////"+imgPath);
          String imagename=data[i]['cat'];
          String id=data[i]['favId'];
          return new Material(
            elevation: 5.0,
            borderRadius:
            new BorderRadius.all(new Radius.circular(5.0)),
            child: new InkWell(
                onTap: () async{

                  Map result=await Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                          new FullScreenImagePage(imgPath,imagename,id)));

                    if(result!=null)
                      {
                      getdata();
                      }

                       debugPrint(result.toString());

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
                            ,child: new Text(data[i]['cat'],textAlign: TextAlign.start,),
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
      ):new Center(child:flag==false?new CircularProgressIndicator():new Text("No Data Found") )


    );
  }
}
