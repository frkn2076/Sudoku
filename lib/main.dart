import 'dart:math';
import 'package:collection/collection.dart';
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

  @override
  void initState() {
    squares = Sudoku.fillSquares();
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
                        color: Colors.blueGrey,
                      ),
                      iconSize: 50,
                      onPressed: () {
                        return showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('REFRESH!'),
                              content: const Text("Sudoku is refreshed!"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return MyApp();
                                        },
                                      ),
                                    );
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
                        color: Colors.blueGrey,
                      ),
                      iconSize: 50,
                      onPressed: () {
                        return Sudoku.isValidSudoku(editedSudoku)
                            ? showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Heyyy!'),
                                    content: const Text("You completed sudoku"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return MyApp();
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              )
                            : showDialog<void>(
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
                              this.editedSudoku[squareId][list.indexOf(value)]
                                  [index] = int.parse(item);
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
}

class Sudoku {
  
  static bool isValidSudoku(List<List<List<int>>> squares) {
    Function eq = const ListEquality().equals;
    List<int> expectedSorted = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    List<List<int>> sudoku = List<List<int>>();

    //square check
    for (var i = 0; i < 9; i++) {
      List<int> oneDimensionalSquare =
          squares[i][0] + squares[i][1] + squares[i][2];
      oneDimensionalSquare.sort();
      if (!eq(oneDimensionalSquare, expectedSorted)) {
        return false;
      }
    }

    //2d array convert
    sudoku.add(squares[0][0] + squares[1][0] + squares[2][0]);
    sudoku.add(squares[0][1] + squares[1][1] + squares[2][1]);
    sudoku.add(squares[0][2] + squares[1][2] + squares[2][2]);
    sudoku.add(squares[3][0] + squares[4][0] + squares[5][0]);
    sudoku.add(squares[3][1] + squares[4][1] + squares[5][1]);
    sudoku.add(squares[3][2] + squares[4][2] + squares[5][2]);
    sudoku.add(squares[6][0] + squares[7][0] + squares[8][0]);
    sudoku.add(squares[6][1] + squares[7][1] + squares[8][1]);
    sudoku.add(squares[6][2] + squares[7][2] + squares[8][2]);

    //sudoku check
    for (var i = 0; i < 9; i++) {
      sudoku[0].sort();
      if (!eq(sudoku[0], expectedSorted)) {
        return false;
      }
    }
    return true;
  }

  static List<List<List<int>>> fillSquares() {
    List<List<int>> sudoku = maskSudoku();
    List<List<List<int>>> squares = List<List<List<int>>>();
    squares.add(Sudoku.getInnerSquare(sudoku, 0, 0));
    squares.add(Sudoku.getInnerSquare(sudoku, 0, 1));
    squares.add(Sudoku.getInnerSquare(sudoku, 0, 2));
    squares.add(Sudoku.getInnerSquare(sudoku, 1, 0));
    squares.add(Sudoku.getInnerSquare(sudoku, 1, 1));
    squares.add(Sudoku.getInnerSquare(sudoku, 1, 2));
    squares.add(Sudoku.getInnerSquare(sudoku, 2, 0));
    squares.add(Sudoku.getInnerSquare(sudoku, 2, 1));
    squares.add(Sudoku.getInnerSquare(sudoku, 2, 2));
    return squares;
  }

  static List<List<int>> getInnerSquare(List<List<int>> sudoku, int row, int column) {
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
    var sudoku = sudokuGenerator();
    for (var i = 0; i < 7; i++) {
      for (var i = 0; i < 7; i++) {
        sudoku[random.nextInt(9)][random.nextInt(9)] = 0;
      }
    }
    return sudoku;
  }

  static List<List<int>> sudokuGenerator() {

    List<int> sequence = List.generate(18, (index) => index%9+1);
    List<List<int>> sample = List.generate(9, (index) => sequence.sublist(9-(index/3).floor()-(index%3)*3,9-(index/3).floor()-(index%3)*3+9));

    Random random = Random();

    for (var k = 0; k < 25; k++) {
      var switch1 = random.nextInt(9) + 1;
      var switch2 = random.nextInt(9) + 1;

      if (switch1 != switch2) {
        for (var i = 0; i < 9; i++) {
          for (var j = 0; j < 9; j++) {
            if (sample[i][j] == switch1) {
              sample[i][j] = switch2;
            } else if (sample[i][j] == switch2) {
              sample[i][j] = switch1;
            }
          }
        }
      }
    }

    return sample;
  }
}
