import 'dart:math';

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
  List<List<List<int>>> squares;
  List<List<List<int>>> editedSudoku;

  //Only initializing
  @override
  void initState() {
    squares = fillSquares();
    editedSudoku = squares;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double widthOfDevice = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false, //Added for bottom overflow warning.
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.grey,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(9),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  createTable(widthOfDevice / 9, squares[0], 0),
                  createTable(widthOfDevice / 9, squares[1], 1),
                  createTable(widthOfDevice / 9, squares[2], 2)
                ],
              ),
              Row(
                children: <Widget>[
                  createTable(widthOfDevice / 9, squares[3], 3),
                  createTable(widthOfDevice / 9, squares[4], 4),
                  createTable(widthOfDevice / 9, squares[5], 5)
                ],
              ),
              Row(
                children: <Widget>[
                  createTable(widthOfDevice / 9, squares[6], 6),
                  createTable(widthOfDevice / 9, squares[7], 7),
                  createTable(widthOfDevice / 9, squares[8], 8)
                ],
              ),
              SizedBox(
                height: 70,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        color: Colors.grey[200]),
                    child: IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.green,
                      ),
                      iconSize: 50,
                      onPressed: () {
                        return showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('REFRESH!'),
                              content: const Text("REFRESH"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        color: Colors.grey[200]),
                    child: IconButton(
                      icon: Icon(
                        Icons.done_outline,
                        color: Colors.green,
                      ),
                      iconSize: 50,
                      onPressed: () {
                        return showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Oppps!'),
                              content: const Text("Not a valid sudoku"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createTable(double cellHeight, List<List<int>> list, int squareId) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black), color: Colors.white),
        child: Table(
          border: TableBorder.symmetric(
              inside: BorderSide(color: Colors.black),
              outside: BorderSide(color: Colors.black)),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: list
              .map((value) => TableRow(
                    children: List.generate(
                      3,
                      (index) => InkResponse(
                        child: SizedBox(
                          height: cellHeight,
                          child: TextField(
                            onChanged: (String item) {
                              // ignore: unused_element
                              // setState(){
                              this.editedSudoku[squareId][list.indexOf(value)]
                                  [index] = int.parse(item);
                              print(editedSudoku[squareId]);
                              // }
                              // editedSudoku[squareId%3+(squareId/3).floor()+list.indexOf(value)][squareId%3*3+index] = int.parse(item);
                              print(
                                  "item: $item  index1: $index   index2: ${list.indexOf(value)}   squareId: $squareId");
                            },
                            readOnly: value[index] != 0,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(1)
                            ],
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                hintText: value[index] != 0
                                    ? value[index].toString()
                                    : "",
                                hintStyle: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                contentPadding:
                                    EdgeInsets.only(bottom: cellHeight / 4)),
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  List<List<List<int>>> fillSquares() {
    List<List<List<int>>> squares = List<List<List<int>>>();
    squares.add(Sudoku.getInnerSquare(0, 0));
    squares.add(Sudoku.getInnerSquare(0, 1));
    squares.add(Sudoku.getInnerSquare(0, 2));
    squares.add(Sudoku.getInnerSquare(1, 0));
    squares.add(Sudoku.getInnerSquare(1, 1));
    squares.add(Sudoku.getInnerSquare(1, 2));
    squares.add(Sudoku.getInnerSquare(2, 0));
    squares.add(Sudoku.getInnerSquare(2, 1));
    squares.add(Sudoku.getInnerSquare(2, 2));
    return squares;
  }

  // List<List<int>> createSudoku() {
  //   var _random = Random();

  //   List<List<int>> sudoku = List.generate(9, (a) => List.generate(9, (i) => 0));
  //   for (var i = 0; i < 35; i++) {
  //     OUTER: for (var i = 0; i < 9; i++) {
  //       for (var i = 0; i < 9; i++) {
  //         var random1 = _random.nextInt(9);
  //         var random2 = _random.nextInt(9);
  //         if (sudoku[random1][random2] == 0) {
  //           List<int> availableOnes = availableItems(
  //               sudoku, (random1 / 3).floor(), (random2 / 3).floor());
  //           if (availableOnes.length != 0) {
  //             var tempRandom = _random.nextInt(availableOnes.length);
  //             var numberToAdd = availableOnes[tempRandom];
  //             if (!sudoku[random1].contains(numberToAdd)) {
  //               for (var k = 0; k < 9; k++) {
  //                 if (sudoku[k][random2] == numberToAdd) {
  //                   break OUTER;
  //                 }
  //               }
  //               sudoku[random1][random2] = numberToAdd;
  //               break OUTER;
  //             }
  //           }
  //         }
  //       }
  //     }
  //   }
  //   return sudoku;
  // }

  // List<int> availableItems(List<List<int>> sudoku, int row, int column) {
  //   List<int> availableOnes = List<int>.generate(9, (index) => index + 1);
  //   for (var i = row * 3; i < row * 3 + 3; i++) {
  //     for (var j = column * 3; j < column * 3 + 3; j++) {
  //       if (sudoku[i][j] != 0) {
  //         availableOnes.remove(sudoku[i][j]);
  //       }
  //     }
  //   }
  //   return availableOnes;
  // }

}

class Sudoku {
  static List<List<int>> getInnerSquare(int row, int column) {
    var sudoku = maskSudoku();
    var innerSquare = List<List<int>>();
    for (var i = row * 3; i < row * 3 + 3; i++) {
      List<int> temp = List<int>();
      for (var j = column * 3; j < column * 3 + 3; j++) {
        temp.add(sudoku[i][j]);
      }
      innerSquare.add(temp);
    }
    return innerSquare;
  }

  static List<List<int>> maskSudoku() {
    Random random = Random();
    var sudoku = getSample();
    for (var i = 0; i < 7; i++) {
      for (var i = 0; i < 7; i++) {
        sudoku[random.nextInt(9)][random.nextInt(9)] = 0;
      }
    }
    return sudoku;
  }

  static List<List<int>> getSample() {
    return [
      [1, 2, 3, 6, 7, 8, 9, 4, 5],
      [5, 8, 4, 2, 3, 9, 7, 6, 1],
      [9, 6, 7, 1, 4, 5, 3, 2, 8],
      [3, 7, 2, 4, 6, 1, 5, 8, 9],
      [6, 9, 1, 5, 8, 3, 2, 7, 4],
      [4, 5, 8, 7, 9, 2, 6, 1, 3],
      [8, 3, 6, 9, 2, 4, 1, 5, 7],
      [2, 1, 9, 8, 5, 7, 4, 3, 6],
      [7, 4, 5, 3, 1, 6, 8, 9, 2]
    ];
  }
}
