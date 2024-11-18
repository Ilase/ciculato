import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

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
  final PageController _pageController = PageController();

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
    if (buttonText == "^") {
      _num1 = double.parse(_currentInput);
      _currentInput = (pow(_num1, 2)).toString();
    } else if (buttonText == "√") {
      _num1 = double.parse(_currentInput);
      _currentInput = (sqrt(_num1)).toString();
    }

    setState(() {
      _output = _currentInput;
    });
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
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
    return Expanded(
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
        title: const Text('Calculator'),
      ),
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // Swipe up
            _pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
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
                      vertical: 24.0, horizontal: 12.0),
                  child: Text(
                    _output,
                    style: const TextStyle(
                        fontSize: 48.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const Expanded(
                  child: Divider(),
                ),
                Column(
                  children: <Widget>[
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
                        _buildButton("C"),
                        _buildButton("="),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 12.0),
                  child: const Text(
                    "Advanced Operations",
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const Expanded(
                  child: Divider(),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _buildAdvancedButton("^"),
                        _buildAdvancedButton("√"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 12.0),
                  child: const Text(
                    "History",
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_history[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
