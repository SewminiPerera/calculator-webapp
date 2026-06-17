import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = "0";
  String _operation = "";
  double _firstValue = 0;
  bool _shouldResetDisplay = false;
  bool _showHistory = false;
  final List<String> _history = [];

  void _onNumberPressed(String value) {
    setState(() {
      if (_shouldResetDisplay) {
        _input = value;
        _shouldResetDisplay = false;
      } else {
        if (_input == "0" && value != ".") {
          _input = value;
        } else if (value == ".") {
          if (!_input.contains(".")) {
            _input += value;
          }
        } else {
          _input += value;
        }
      }
    });
  }

  void _onOperationPressed(String operation) {
    setState(() {
      if (_operation.isNotEmpty && !_shouldResetDisplay) {
        _calculate();
      }

      _firstValue = double.tryParse(_input) ?? 0;
      _operation = operation;
      _shouldResetDisplay = true;
    });
  }

  void _calculate() {
    if (_operation.isEmpty || _shouldResetDisplay) return;

    double secondValue = double.tryParse(_input) ?? 0;
    double result = 0;

    switch (_operation) {
      case "+":
        result = _firstValue + secondValue;
        break;
      case "-":
        result = _firstValue - secondValue;
        break;
      case "×":
        result = _firstValue * secondValue;
        break;
      case "÷":
        if (secondValue == 0) {
          _input = "Cannot divide by 0";
          _operation = "";
          _shouldResetDisplay = true;
          return;
        }
        result = _firstValue / secondValue;
        break;
    }

    String resultStr = result % 1 == 0
        ? result.toInt().toString()
        : result.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');

    _history.insert(0, "${_firstValue.toString()} $_operation ${secondValue.toString()} = $resultStr");
    _input = resultStr;
    _operation = "";
    _shouldResetDisplay = true;
  }

  void _onEqual() {
    setState(() {
      _calculate();
    });
  }

  void _onClear() {
    setState(() {
      _input = "0";
      _operation = "";
      _firstValue = 0;
      _shouldResetDisplay = false;
    });
  }

  void _onBackspace() {
    setState(() {
      if (_input.length > 1) {
        _input = _input.substring(0, _input.length - 1);
      } else {
        _input = "0";
      }
    });
  }

  void _onPercent() {
    setState(() {
      double value = double.tryParse(_input) ?? 0;
      value = value / 100;
      _input = value % 1 == 0 ? value.toInt().toString() : value.toString();
    });
  }

  Widget _buildButton(String text, VoidCallback onPressed, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? const Color(0xFF424242),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      body: SafeArea(
        child: Column(
          children: [
            // Display Area
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Equation line
                      Text(
                        _operation.isEmpty
                            ? ""
                            : "$_firstValue $_operation ${_shouldResetDisplay ? "" : _input}",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _input,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // History Toggle and Display Area
            if (_showHistory && _history.isNotEmpty)
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  reverse: true,
                  itemCount: _history.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      _history[index],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
            // History Toggle Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _showHistory = !_showHistory;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  foregroundColor: Colors.white,
                ),
                icon: Icon(_showHistory ? Icons.expand_less : Icons.expand_more),
                label: Text(_showHistory ? "Hide History" : "Show History"),
              ),
            ),
            // Buttons Area
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildButton("AC", _onClear, color: Colors.orange),
                        _buildButton("⌫", _onBackspace, color: Colors.orange),
                        _buildButton("%", _onPercent, color: Colors.orange),
                        _buildButton("÷", () => _onOperationPressed("÷"),
                            color: Colors.orange),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton("7", () => _onNumberPressed("7")),
                        _buildButton("8", () => _onNumberPressed("8")),
                        _buildButton("9", () => _onNumberPressed("9")),
                        _buildButton("×", () => _onOperationPressed("×"),
                            color: Colors.orange),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton("4", () => _onNumberPressed("4")),
                        _buildButton("5", () => _onNumberPressed("5")),
                        _buildButton("6", () => _onNumberPressed("6")),
                        _buildButton("-", () => _onOperationPressed("-"),
                            color: Colors.orange),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton("1", () => _onNumberPressed("1")),
                        _buildButton("2", () => _onNumberPressed("2")),
                        _buildButton("3", () => _onNumberPressed("3")),
                        _buildButton("+", () => _onOperationPressed("+"),
                            color: Colors.orange),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () => _onNumberPressed("0"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF424242),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "0",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        _buildButton(".", () => _onNumberPressed(".")),
                        _buildButton("=", _onEqual, color: Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
