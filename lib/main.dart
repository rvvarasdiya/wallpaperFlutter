import 'package:flutter/material.dart';
import 'package:gammingwallpaper/Favorit.dart';
import 'package:gammingwallpaper/Home.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share/share.dart';



main  ()
{
Routes();
}

class Routes {

  var routes = <String, WidgetBuilder>{
    "/SignUp": (BuildContext context) => new wallpaper(),

  };

  Routes() {

    runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Wallpaper",
      onGenerateTitle: (BuildContext contex)=>"Wallpaper",
      home: new wallpaper(),
      theme: new ThemeData(
          accentColor: Colors.orange.shade900,
          primaryColor: Colors.orange.shade800,
          primaryColorDark: Colors.orange.shade800,
          indicatorColor: Colors.orange.shade800,
          backgroundColor: Colors.orange.shade900,
          inputDecorationTheme: InputDecorationTheme(

          )

      ),
      routes: routes,
    ));
  }
}

class wallpaper extends StatefulWidget {
  @override
  _wallpaperState createState() => _wallpaperState();
}

class _wallpaperState extends State<wallpaper> {
  int index=0;
  int i=0;


  setbody(int pos)
  {
    switch(pos)
    {
      case 0:return Home();
      case 1:return Favorit();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new Drawer(

        child: new Container(
          decoration: BoxDecoration(color: Colors.orange.shade800),
          child: new Column(
            children: <Widget>[
              new Container(

                decoration: BoxDecoration(color:Colors.orange.shade800),
                child:new UserAccountsDrawerHeader(accountName: Text("HD Gamming Wallpaper"), accountEmail: Text("Wallpaper for Gammmers")
                    ,

                    decoration: BoxDecoration( color: Colors.orange.shade800)
                    ,currentAccountPicture:CircleAvatar(
                      backgroundImage:AssetImage("assets/images.png",) ,
                      backgroundColor: Colors.orange,
                    )
                ) ,
              )

              ,
              new Container(
                height:MediaQuery.of(context).size.height-193,
               decoration: BoxDecoration(color: Colors.white),
               child: new Column(
                  children: <Widget>[
                    new ListTile(
                      leading: Icon(Icons.home),
                      title: Text("Home"),
                      selected: index==0?true:false,
                      onTap: (){
                        Navigator.of(context).pop();
                        setState(() {
                          index=0;

                        });
                      },

                    ),
                    new ListTile(
                      leading: Icon(Icons.favorite_border),

                      title: Text("Favorit"),
                      selected: index==1?true:false,
                      onTap: (){
                        Navigator.of(context).pop();
                        setState(() {
                          index=1;

                        });
                      },

                    ),
                    Divider()
                    , new ListTile(
                      leading: Icon(Icons.star_border),

                      title: Text("Rate the app"),
                      onTap: (){
                        LaunchReview.launch(androidAppId:"com.wallpaper.gammingwallpaper");
                      },

                    ),
                    new ListTile(
                      leading: Icon(Icons.share),

                      title: Text("Share with your friend"),
                      onTap: (){
                        Share.share("Download This Amazing Gamming Wallpaper App"+"\nhttps://play.google.com/store/apps/details?id=com.wallpaper.gammingwallpaper");
                      },

                    ),
                  ],
               ),
             )
            ],
          ),
        )

      ),
      appBar:new PreferredSize(child:  new AppBar(

        title:Text("HD GAMMING WALLPAPER",style: TextStyle(fontSize: 18.0),) ,
        elevation: index==0? 0.0:4.0,
      ), preferredSize: Size.fromHeight(60.0)), body: setbody(index),
    );
  }
}

