import 'package:flutter/material.dart';

void main() {
  runApp(const IOSCalculator());
}

class IOSCalculator extends StatelessWidget {
  const IOSCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CalculatorScreen(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(context).textScaleFactor > 1.0
                ? 1.0
                : MediaQuery.of(context).textScaleFactor,
          ),
          child: child!,
        );
      },
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() =>
      _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = "";
  String display = "0";

  double first = 0;
  String operation = "";

  List<String> history = [];

  void press(String value) {
    setState(() {
      if (value == "AC") {
        expression = "";
        display = "0";
        operation = "";
        first = 0;
      } else if (value == "⌫") {
        if (expression.isNotEmpty) {
          expression = expression.substring(0, expression.length - 1);
          display = expression.isEmpty ? "0" : expression;
        }
      } else if (value == "%") {
        double num = double.tryParse(display) ?? 0;
        display = (num / 100).toString();
        expression = display;
      } else if (["+", "-", "×", "÷"].contains(value)) {
        if (display != "0") {
          first = double.parse(display);
          operation = value;
          expression += value;
          display = "";
        }
      } else if (value == "=") {
        List parts = expression.split(operation);

        if (parts.length < 2) return;

        double second = double.tryParse(parts[1]) ?? 0;
        double result = 0;

        switch (operation) {
          case "+":
            result = first + second;
            break;
          case "-":
            result = first - second;
            break;
          case "×":
            result = first * second;
            break;
          case "÷":
            if (second == 0) {
              display = "Error";
              return;
            }
            result = first / second;
            break;
        }

        history.insert(
          0,
          "$expression = ${result.toString()}",
        );

        display = result.toString();
        expression = display;
      } else {
        expression += value;
        display = expression;
      }
    });
  }

  Widget btn(
    String text, {
    Color color = const Color(0xff333333),
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      
      // Calculate responsive font size
      double fontSize = screenWidth < 600
          ? 20
          : screenWidth < 1200
              ? 24
              : 28;

      double padding = screenWidth < 600
          ? 16
          : screenWidth < 1200
              ? 20
              : 26;

      return Expanded(
        child: Padding(
          padding: EdgeInsets.all(constraints.maxWidth * 0.08),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              padding: EdgeInsets.all(padding),
              shape: const CircleBorder(),
            ),
            onPressed: text.isEmpty ? null : () => press(text),
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Responsive font sizes
    double expressionFontSize =
        screenWidth < 600 ? 18 : screenWidth < 1200 ? 22 : 28;
    double displayFontSize =
        screenWidth < 600 ? 36 : screenWidth < 1200 ? 48 : 54;
    double displayHeight = screenHeight < 600 ? 120 : 150;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: displayHeight,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                alignment: Alignment.bottomRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      expression,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: expressionFontSize,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      display,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: displayFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight < 600 ? 100 : 150,
                child: ListView(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: history
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            e,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: screenWidth < 600 ? 12 : 14,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        btn("AC", color: Colors.grey),
                        btn("⌫", color: Colors.grey),
                        btn("%", color: Colors.grey),
                        btn("÷", color: Colors.orange),
                      ],
                    ),
                    Row(
                      children: [
                        btn("7"),
                        btn("8"),
                        btn("9"),
                        btn("×", color: Colors.orange),
                      ],
                    ),
                    Row(
                      children: [
                        btn("4"),
                        btn("5"),
                        btn("6"),
                        btn("-", color: Colors.orange),
                      ],
                    ),
                    Row(
                      children: [
                        btn("1"),
                        btn("2"),
                        btn("3"),
                        btn("+", color: Colors.orange),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.all(
                                screenWidth < 600 ? 6 : 8),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xff333333),
                                padding: EdgeInsets.all(
                                    screenWidth < 600 ? 16 : 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () => press("0"),
                              child: Text(
                                "0",
                                style: TextStyle(
                                  fontSize: screenWidth < 600
                                      ? 20
                                      : 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        btn("."),
                        btn("=", color: Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}