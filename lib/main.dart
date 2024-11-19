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
    if (!mounted) return;
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

  @override
  void initState() {
    super.initState();
    // _themeMode = widget.changeTheme(_themeMode); // No need to set theme mode here
  }

  String _output = "0";
  String _currentInput = "0";
  String _operator = "";
  double _num1 = 0;
  double _num2 = 0;
  final List<String> _history = [];
  bool _showAdvancedOperations = false;
  final PageController _pageController = PageController();
  final bool _isDarkMode = false;

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
      _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    });
    widget.changeTheme(_themeMode);
  }

  Widget _buildButton(String buttonText) {
    return GridTile(
      child: OutlinedButton(
        onPressed: () => _buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildAdvancedButton(String buttonText) {
    return GridTile(
      child: OutlinedButton(
        onPressed: () => _advancedButtonPressed(buttonText),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
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
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        color: _themeMode == ThemeMode.dark ? Colors.black : Colors.white,
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              setState(() {
                _showAdvancedOperations = !_showAdvancedOperations;
              });
            }
          },
          child: PageView(
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
                    child: GridView.count(
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
                    child: GridView.count(
                      crossAxisCount: 3,
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
                      ],
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
