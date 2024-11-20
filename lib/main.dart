import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lightThemeData = ThemeData.light().copyWith(
      colorScheme: const ColorScheme.light().copyWith(
        primary: Colors.black,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shadowColor: Colors.black87,
          side: const BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white; // Белый кружочек, когда выбран
          }
          return Colors.grey; // Серый кружочек, когда не выбран
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.black.withOpacity(0.5); // Черный фон, когда выбран
          }
          return Colors.grey.withOpacity(0.5); // Серый фон, когда не выбран
        }),
      ),
    );

    final darkThemeData = ThemeData.dark().copyWith(
      colorScheme: const ColorScheme.dark().copyWith(
        primary: Colors.white,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.black; // Черный кружочек, когда выбран
          }
          return Colors.grey; // Серый кружочек, когда не выбран
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white.withOpacity(0.5); // Белый фон, когда выбран
          }
          return Colors.grey.withOpacity(0.5); // Серый фон, когда не выбран
        }),
      ),
    );

    return MaterialApp(
      title: 'Calculator App',
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: _themeMode,
      home: CalculatorScreen(changeTheme: changeTheme),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  final Function(ThemeMode) changeTheme;

  const CalculatorScreen({super.key, required this.changeTheme});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  ThemeMode _themeMode = ThemeMode.system;
  String _output = "0";
  String _currentInput = "";
  final List<String> _history = [];
  final PageController _pageController = PageController();
  bool _showAdvancedOperations = false;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _currentInput = "";
      } else if (buttonText == "=") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(_currentInput);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          _output = eval.toString();
          _history.add("$_currentInput = $_output");
          _currentInput = _output;
        } catch (e) {
          _output = "Error";
        }
      } else {
        if (_currentInput.isEmpty &&
            (buttonText == "+" ||
                buttonText == "-" ||
                buttonText == "*" ||
                buttonText == "/")) {
          _currentInput = "0$buttonText";
        } else {
          _currentInput += buttonText;
        }
        _output = _currentInput;
      }
    });
  }

  void _advancedButtonPressed(String buttonText) {
    setState(() {
      double num1 = double.tryParse(_currentInput) ?? 0;
      String result;
      if (buttonText == "^") {
        result = (pow(num1, 2)).toString();
      } else if (buttonText == "√") {
        result = (sqrt(num1)).toString();
      } else if (buttonText == "sin") {
        result = (sin(num1)).toString();
      } else if (buttonText == "cos") {
        result = (cos(num1)).toString();
      } else if (buttonText == "tan") {
        result = (tan(num1)).toString();
      } else if (buttonText == "log") {
        result = (log(num1)).toString();
      } else if (buttonText == "%") {
        result = (num1 / 100).toString();
      } else if (buttonText == "π") {
        result = pi.toString();
      } else if (buttonText == "!") {
        int num = num1.toInt();
        int factorial = 1;
        for (int i = 1; i <= num; i++) {
          factorial *= i;
        }
        result = factorial.toString();
      } else {
        result = _currentInput;
      }
      _output = result;
      _currentInput = result;
    });
  }

  void _toggleTheme(bool value) {
    setState(() {
      _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    });
    widget.changeTheme(_themeMode);
  }

  Widget _buildButton(String buttonText) {
    return GridTile(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: OutlinedButton(
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedButton(String buttonText) {
    return GridTile(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: OutlinedButton(
          onPressed: () => _advancedButtonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ciculato'),
        backgroundColor:
            _themeMode == ThemeMode.dark ? Colors.black : Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color:
                    _themeMode == ThemeMode.dark ? Colors.black : Colors.white,
              ),
              child: Center(
                child: Text(
                  'Ciculato',
                  style: TextStyle(
                    color: _themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(
                'About',
                style: TextStyle(
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: _themeMode == ThemeMode.light
                          ? Colors.white
                          : Colors.black,
                      title: const Text('About Ciculato'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('Version: 1.0.0'),
                          const Text('Author: Ilase'),
                          GestureDetector(
                            onTap: () {
                              launch('https://github.com/Ilase');
                            },
                            child: const Text(
                              'GitHub: https://github.com/Ilase',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 114, 114, 114)),
                            ),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Close'),
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
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              trailing: Switch(
                value: _themeMode == ThemeMode.dark,
                onChanged: _toggleTheme,
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 12.0,
                ),
                child: Text(
                  _output,
                  style: const TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! > 0) {
                      setState(() {
                        _showAdvancedOperations = !_showAdvancedOperations;
                      });
                    }
                  },
                  child: Column(
                    children: [
                      Spacer(),
                      Expanded(
                        flex: 4,
                        child: PageView(
                          controller: PageController(),
                          children: [
                            GridView.count(
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 4,
                              children: <Widget>[
                                _buildButton("("),
                                _buildButton(")"),
                                _buildButton("C"),
                                _buildButton("/"),
                                _buildButton("7"),
                                _buildButton("8"),
                                _buildButton("9"),
                                _buildButton("*"),
                                _buildButton("4"),
                                _buildButton("5"),
                                _buildButton("6"),
                                _buildButton("-"),
                                _buildButton("1"),
                                _buildButton("2"),
                                _buildButton("3"),
                                _buildButton("+"),
                                _buildButton("."),
                                _buildButton("0"),
                                _buildButton("00"),
                                _buildButton("="),
                              ],
                            ),
                            GridView.count(
                              crossAxisCount: 4,
                              children: <Widget>[
                                _buildAdvancedButton("^"),
                                _buildAdvancedButton("√"),
                                _buildAdvancedButton("sin"),
                                _buildAdvancedButton("cos"),
                                _buildAdvancedButton("tan"),
                                _buildAdvancedButton("log"),
                                _buildAdvancedButton("%"),
                                _buildAdvancedButton("π"),
                                _buildAdvancedButton("!"),
                                _buildButton(""),
                                _buildButton(""),
                                _buildButton(""),
                                _buildButton(""),
                                _buildButton(""),
                                _buildButton(""),
                                _buildButton(""),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 12.0,
                ),
                child: const Text(
                  "History",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _history[index],
                        style: TextStyle(
                          color: _themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
