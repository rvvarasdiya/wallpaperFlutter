import 'package:flutter/material.dart';
import 'package:gammingwallpaper/games.dart';
import 'package:gammingwallpaper/newwallpaper.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:connectivity/connectivity.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{
  TabController tabController;
  @override
  void initState() {
    tabController=new TabController(length: 2, vsync: this);
    // TODO: implement initState
    super.initState();

    permision();
  }
  permision() async{
    if (!(await SimplePermissions
        .checkPermission(Permission.WriteExternalStorage)) && !(await SimplePermissions
        .checkPermission(Permission.ReadExternalStorage))) {
    await SimplePermissions
        .requestPermission(Permission.WriteExternalStorage);

    }
    if(!(await SimplePermissions
        .checkPermission(Permission.ReadExternalStorage)))
    {
      await SimplePermissions
          .requestPermission(Permission.ReadExternalStorage);
    }



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        primary: false,

       flexibleSpace: new SafeArea(child: new TabBar(
         controller: tabController,


         labelStyle: TextStyle(fontSize: 10.0),
         tabs: <Widget>[
           new Tab(icon:new Icon(Icons.access_time),text: "NEW",),
           new Tab(icon:new Icon(Icons.videogame_asset),text: "GAMES",),

         ],
       ),),
        automaticallyImplyLeading: false,

      ),
      body: new TabBarView(
        controller: tabController,
        children: <Widget>[
          new New(),
          new Games()
        ],

      ),

    );
  }
}
