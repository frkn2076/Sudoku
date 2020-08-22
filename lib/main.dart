import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double widthOfDevice = MediaQuery.of(context).size.width;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    Widget createTable() {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        height: widthOfDevice / 3 - 1,
        width: widthOfDevice / 3 - 1,
        child: Table(
          border: TableBorder.symmetric(
              inside: BorderSide(color: Colors.black54),
              outside: BorderSide(color: Colors.black)),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: List.generate(
              3,
              (row) => TableRow(
                  children: List.generate(
                      3,
                      (column) => Padding(
                          padding: const EdgeInsets.all(5),
                          child: SizedBox(
                              width: 30,
                              height: 30,
                              child: TextField(
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              )))))),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          padding: const EdgeInsets.all(9),
          child: Table(
              border: TableBorder.symmetric(
                  outside: BorderSide(color: Colors.black)),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(children: [
                  Container(
                    height: widthOfDevice - 9,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 3, // takes 30% of available width
                            child: Row(
                              children: <Widget>[
                                createTable(),
                                createTable(),
                                createTable()
                              ],
                            ),
                          ),
                          // Container(
                          //   width: 100,
                          //   child: Row(
                          //     children: <Widget>[
                          //       createTable(),
                          //       createTable(),
                          //       createTable(),
                          //     ],
                          //   ),
                          // ),
                          // Container(
                          //   child: Row(
                          //     children: <Widget>[
                          //       createTable(),
                          //       createTable(),
                          //       createTable(),
                          //     ],
                          //   ),
                          // ),
                          // Container(
                          //   child: Row(
                          //     children: <Widget>[
                          //       createTable(),
                          //       createTable(),
                          //       createTable(),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ])
              ]),
        ));
  }
}
