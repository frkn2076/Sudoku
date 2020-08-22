import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Sudoku'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double widthOfDevice = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false, //Added for bottom overflow warning.
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          padding: const EdgeInsets.all(9),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  createTable(widthOfDevice / 9),
                  createTable(widthOfDevice / 9),
                  createTable(widthOfDevice / 9)
                ],
              ),
              Row(
                children: <Widget>[
                  createTable(widthOfDevice / 9),
                  createTable(widthOfDevice / 9),
                  createTable(widthOfDevice / 9)
                ],
              ),
              Row(
                children: <Widget>[
                  createTable(widthOfDevice / 9),
                  createTable(widthOfDevice / 9),
                  createTable(widthOfDevice / 9)
                ],
              ),
              // SizedBox(
              //   height: 70,
              // ),
              // Container(
              //   child: IconButton(
              //     icon: ,
              //   ),
              // )
            ],
          ),
        ));
  }
}

Widget createTable(double cellHeight) {
  var widthOfDevice;
  return Expanded(
      child: Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
    ),
    child: Table(
      border: TableBorder.symmetric(
          inside: BorderSide(color: Colors.black),
          outside: BorderSide(color: Colors.black)),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: List.generate(
          3,
          (row) => TableRow(
                children: List.generate(
                  3,
                  (column) => InkResponse(
                    child: SizedBox(
                      height: cellHeight,
                      child: TextField(
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1)
                        ], // Only numbers can be entered
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              )),
    ),
  ));
}
