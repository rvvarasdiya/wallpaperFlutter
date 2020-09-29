import 'dart:io';
import 'databasehelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:simple_permissions/simple_permissions.dart';
import 'package:advanced_share/advanced_share.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:documents_picker/documents_picker.dart';
class FullScreenImagePage extends StatefulWidget {
  String imgPath;
  String imagename;
  String id;
  FullScreenImagePage(this.imgPath,this.imagename,this.id);
  @override
  _FullScreenImagePageState createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  static const platform = const MethodChannel('samples.flutter.io/battery');
  var progressString = "";
  var db = new DatabaseHelper();
  bool state=false;
  // Get battery level.
  String _setWallpaper = '';
  bool downloading = false;
  GlobalKey<ScaffoldState> _scaffold=new GlobalKey<ScaffoldState>();
  bool isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
    //initPlatformState();
  }

  init() async
  {
    int count=await db.getCount(widget.id);
    debugPrint(count.toString());
    if(count>0)
      {
        state=true;
      }
      else
        {
          state=false;
        }
        setState(() {

        });
  }
  Future<void> initPlatformState() async {
    bool teste;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {

      List<dynamic> docs = await DocumentsPicker.pickDocuments;
      teste = await FlutterShare.share(title: 'teste', fileUrl: docs[0] as String);

    } on PlatformException {

    }

    if (!mounted) return;

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop:_onWillPop ,child: new Scaffold(
      key: _scaffold,
      body: new SizedBox.expand(
        child: new Container(
          decoration: new BoxDecoration(color: Colors.orange.shade50),
          child: new Stack(

            children: <Widget>[
              new Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,

                child: new Hero(
                  tag: widget.imgPath,
                  child: new Image.network(widget.imgPath, fit: BoxFit.fill,),
                ),
              ),
              new Align(
                alignment: Alignment.topCenter,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new AppBar(
                      elevation: 0.0,
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      title: new Text(widget.imagename),
                      leading: new IconButton(
                        icon: new Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop({"result":true}),
                      ),
                    )
                  ],
                ),
              ),
              new Padding(padding: EdgeInsets.fromLTRB(00.0, 0.0, 00.0, 30.0),
                child: new Align(
                  alignment: Alignment.bottomLeft,
                  child: new Row(

                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[


                      new RaisedButton(
                        splashColor: Colors.yellow,
                        color: Colors.orange.shade900,
                        padding: EdgeInsets.all(12.0),
                        shape: CircleBorder(  ),
                        child: state==false?new Icon(
                          Icons.favorite_border,
                          color: Colors.white,

                        ):new Icon(
                          Icons.favorite,
                          color: Colors.white,

                        ),
                        onPressed: () {
                          if(state==false)
                          {
                            addfav();
                            debugPrint("clcick1");
                          }
                          else
                          {
                            deletefav();
                            debugPrint("clcick2");
                          }



                        },

                      ),
                      new RaisedButton(
                        splashColor: Colors.yellow,
                        color: Colors.orange.shade900,
                        padding: EdgeInsets.all(12.0),
                        shape: CircleBorder(),
                        child: new Icon(
                          Icons.cloud_download,
                          color: Colors.white,

                        ),
                        onPressed: () {

                          downloadwallpaper();
                        },

                      ),

                      new RaisedButton(
                        splashColor: Colors.yellow,
                        color: Colors.orange.shade900,
                        padding: EdgeInsets.all(12.0),
                        shape: CircleBorder(),
                        child: new Icon(
                          Icons.wallpaper,
                          color: Colors.white,

                        ),
                        onPressed: () {
                          debugPrint("clcick");
                          downloadwallpaper(data:1);
                        },

                      ),
                      new RaisedButton(

                        splashColor: Colors.yellow,
                        color: Colors.orange.shade900,
                        padding: EdgeInsets.all(12.0),
                        shape: CircleBorder(),
                        child: new Icon(
                          Icons.share,
                          color: Colors.white,

                        ),
                        onPressed: () {
                          debugPrint("clcick");
                          _shareImage();

                        },

                      ),


                    ],
                  ),
                ),)
            ],
          ),
        ),
      ),
    ),);
  }

  String text = "whatever";

  void downloadwallpaper({int data}) async {
    if (!(await SimplePermissions
        .checkPermission(Permission.WriteExternalStorage)) && !(await SimplePermissions
        .checkPermission(Permission.ReadExternalStorage))) {
      await SimplePermissions
          .requestPermission(Permission.WriteExternalStorage);
      await SimplePermissions
          .requestPermission(Permission.ReadExternalStorage);

    }

    if(data!=null)
      {
        _scaffold.currentState.showSnackBar(new SnackBar(
          content: new Text("Waiting....."),));


      }
      else
        {
          _scaffold.currentState.showSnackBar(new SnackBar(
            content: new Text("Waiting...."),));
        }

    Dio dio=new Dio();
    final externalDir = await getExternalStorageDirectory();
    final myDir = new Directory("${externalDir}/wallpaper");
    myDir.exists().then((isThere) {
      isThere ? print('exists') :  new Directory(externalDir.path+'/'+'wallpaper').create(recursive: true)
// The created directory is returned as a Future.
          .then((Directory directory) {
        print('Path of New Dir: '+directory.path);
      });
    });
      final filePath = path.join(externalDir.path,"wallpaper", widget.id + '.jpeg');
      final file = new File(filePath);
      if(await file.exists())
        {
            debugPrint("already awailible");
            if(data!=null)
              {

              }
              else {
              _scaffold.currentState.showSnackBar(new SnackBar(
                content: new Text("Wallpaper already Downloaded...."),));
            }
        }
        else
          {


            await dio.download(widget.imgPath, filePath,onProgress: (rec,totle){
              print("REC:$rec,TOTLE:$totle");

            });
            _scaffold.currentState.showSnackBar(new SnackBar(content: new Text("download completed...."),));
          }
          if(data!=null)
            {
              _scaffold.currentState.showSnackBar(new SnackBar(content: new Text("Wallpaper Updated..."),));
              String setWallpaper;
              try {
                 await platform.invokeMethod('setWallpaper', filePath);
                setWallpaper = 'Wallpaer Updated....';

              } on PlatformException catch (e) {
                setWallpaper = "Failed to Set Wallpaer: '${e.message}'.";
              }
              _scaffold.currentState.showSnackBar(new SnackBar(content: new Text("Wallpaper Updated..."),));


            }



  }




  _shareImage() async {
    if (!(await SimplePermissions
        .checkPermission(Permission.WriteExternalStorage))) {
      await SimplePermissions
          .requestPermission(Permission.WriteExternalStorage);


    }
    if(!(await SimplePermissions
        .checkPermission(Permission.ReadExternalStorage)))
      {
        await SimplePermissions
            .requestPermission(Permission.ReadExternalStorage);
      }
    generic();
  }
  void generic() async{
    final externalDir = await getExternalStorageDirectory();
    final filePath = path.join(externalDir.path,"wallpaper", widget.id + '.jpeg');
    //debugPrint(filePath.toString());
    final file = new File(filePath);
    if(await file.exists())
    {

      Uri BASE64IMAGE =Uri.file(filePath);
      debugPrint(BASE64IMAGE.toString());
      bool teste;
      try {
        teste = await FlutterShare.share(title: 'wallpaper', fileUrl: filePath as String,message:"hello");
      }catch(e) {
        debugPrint(e.toString());
      } if (!mounted) return;

      setState(() {
      });




    }else
      {
        _scaffold.currentState.showSnackBar(new SnackBar(
          content: new Text("Wallpaper Not Downloaded...."),));
      }



  }

Future addfav ()
async {

  int res=await db.saveUser(widget.id,widget.imgPath,widget.imagename);
  debugPrint(res.toString());
  setState(() {
    state=true;
  });
}
  void deletefav() async{

    int data=await db.deleteUser(widget.id);
    setState(() {
      state=false;
    });

  }



  Future<bool> _onWillPop() {

    Navigator.of(context).pop({"result":true});

  }
}

