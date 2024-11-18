import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

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
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
          headlineSmall: TextStyle(color: Colors.black),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.black),
            textStyle: const TextStyle(color: Colors.black),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white),
            textStyle: const TextStyle(color: Colors.white),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: Colors.black,
        ),
      ),
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
  String _output = "0";
  String _currentInput = "0";
  String _operator = "";
  double _num1 = 0;
  double _num2 = 0;
  final List<String> _history = [];
  bool _showAdvancedOperations = false;
  final PageController _pageController = PageController();
  bool _isDarkMode = false;

  void _buttonPressed(String buttonText) {
    if (buttonText == "C") {
      _output = "0";
      _currentInput = "0";
      _operator = "";
      _num1 = 0;
      _num2 = 0;
    } else if (buttonText == "+" ||
        buttonText == "-" ||
        buttonText == "*" ||
        buttonText == "/") {
      _num1 = double.parse(_currentInput);
      _operator = buttonText;
      _currentInput = "0";
    } else if (buttonText == "=") {
      _num2 = double.parse(_currentInput);
      if (_operator == "+") {
        _currentInput = (_num1 + _num2).toString();
      } else if (_operator == "-") {
        _currentInput = (_num1 - _num2).toString();
      } else if (_operator == "*") {
        _currentInput = (_num1 * _num2).toString();
      } else if (_operator == "/") {
        _currentInput = (_num1 / _num2).toString();
      }
      _history.add("$_num1 $_operator $_num2 = $_currentInput");
      _num1 = 0;
      _num2 = 0;
      _operator = "";
    } else {
      if (_currentInput == "0") {
        _currentInput = buttonText;
      } else {
        _currentInput = _currentInput + buttonText;
      }
    }

    setState(() {
      _output = _currentInput;
    });
  }

  void _advancedButtonPressed(String buttonText) {
    _num1 = double.parse(_currentInput);
    if (buttonText == "^") {
      _currentInput = (pow(_num1, 2)).toString();
    } else if (buttonText == "√") {
      _currentInput = (sqrt(_num1)).toString();
    } else if (buttonText == "sin") {
      _currentInput = (sin(_num1)).toString();
    } else if (buttonText == "cos") {
      _currentInput = (cos(_num1)).toString();
    } else if (buttonText == "tan") {
      _currentInput = (tan(_num1)).toString();
    } else if (buttonText == "log") {
      _currentInput = (log(_num1)).toString();
    } else if (buttonText == "%") {
      _currentInput = (_num1 / 100).toString();
    } else if (buttonText == "π") {
      _currentInput = pi.toString();
    } else if (buttonText == "!") {
      int num = _num1.toInt();
      int factorial = 1;
      for (int i = 1; i <= num; i++) {
        factorial *= i;
      }
      _currentInput = factorial.toString();
    }

    setState(() {
      _output = _currentInput;
    });
  }

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    widget.changeTheme(value ? ThemeMode.dark : ThemeMode.light);
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: SizedBox(
        height:
            80, // adjust the height as needed to make the buttons more square
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
    return Expanded(
      child: SizedBox(
        height:
            80, // adjust the height as needed to make the buttons more square
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
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                child: Text(
                  'Ciculato',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
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
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
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
                              style: TextStyle(color: Colors.blue),
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
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              trailing: Switch(
                value: _isDarkMode,
                onChanged: _toggleTheme,
              ),
            ),
          ],
        ),
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        color: _isDarkMode ? Colors.black : Colors.white,
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              // Swipe up
              setState(() {
                _showAdvancedOperations = !_showAdvancedOperations;
              });
            }
          },
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              // Swipe left
              _pageController.animateToPage(
                2,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            } else if (details.primaryVelocity! < 0) {
              // Swipe right
              _pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          },
          child: PageView(
            controller: _pageController,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                height: _showAdvancedOperations
                    ? MediaQuery.of(context).size.height * 0.8
                    : MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 12.0),
                      child: Text(
                        _output,
                        style: const TextStyle(
                            fontSize: 48.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // removed the line in the middle of the calculator
                    // const Expanded(
                    //   child: Divider(),
                    // ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            _buildButton("("),
                            _buildButton(")"),
                            Expanded(
                              flex: 2,
                              child: OutlinedButton(
                                onPressed: () => _buttonPressed("C"),
                                child: const Text(
                                  "C",
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            _buildButton("7"),
                            _buildButton("8"),
                            _buildButton("9"),
                            _buildButton("/"),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            _buildButton("4"),
                            _buildButton("5"),
                            _buildButton("6"),
                            _buildButton("*"),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            _buildButton("1"),
                            _buildButton("2"),
                            _buildButton("3"),
                            _buildButton("-"),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            _buildButton("."),
                            _buildButton("0"),
                            _buildButton("00"),
                            _buildButton("+"),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            _buildButton("="),
                          ],
                        ),
                      ],
                    ),
                    AnimatedOpacity(
                      opacity: _showAdvancedOperations ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: _showAdvancedOperations
                          ? SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      _buildAdvancedButton("^"),
                                      _buildAdvancedButton("√"),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _buildAdvancedButton("sin"),
                                      _buildAdvancedButton("cos"),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _buildAdvancedButton("tan"),
                                      _buildAdvancedButton("log"),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _buildAdvancedButton("%"),
                                      _buildAdvancedButton("π"),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _buildAdvancedButton("!"),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(
                        vertical: 24.0, horizontal: 12.0),
                    child: const Text(
                      "History",
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
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
                              color: _isDarkMode ? Colors.white : Colors.black,
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
        ),
      ),
    );
  }
}
