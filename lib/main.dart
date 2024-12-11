//IM/2021/008 - Tharindu Lakmal

import 'package:first_flutter_app/buttons.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math'; // Import for sqrt

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 105, 72, 161)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var userQuestion = '';
  var userAnswer = '';

  final List<dynamic> buttons = [
    'C',
    '√',
    '%',
    '÷',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
  ];

  final List<dynamic> lastButtons = ['0', '.', Icons.backspace, '='];

  @override
  Widget build(BuildContext context) {
    final buttonSize = (MediaQuery.of(context).size.width - 50) / 4;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Text(
                      userQuestion,
                      style: TextStyle(
                          fontSize: userQuestion.length > 10 ? 30 : 40),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Text(
                      userAnswer,
                      style: TextStyle(
                        color: userAnswer == "Can't divide by zero"  ? Colors.red : Colors.black,
                        fontSize: userAnswer.length > 10 ? 30 : 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  SizedBox(
                    height: buttonSize * 4 + 40,
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      itemCount: buttons.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return MyButton(
                            buttonTapped: () {
                              setState(() {
                                userQuestion = '';
                                userAnswer = '';
                              });
                            },
                            color: const Color.fromARGB(255, 12, 126, 192),
                            textColor: const Color.fromARGB(255, 255, 255, 255),
                            content: buttons[index],
                          );
                        }

                        return Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: buttonSize,
                            height: buttonSize,
                            child: MyButton(
                              buttonTapped: () {
                                handleInput(buttons[index]);
                              },
                              content: buttons[index],
                              color: buttons[index] == '√' ||
                                      isOperator(buttons[index])
                                  ? const Color.fromRGBO(58, 193, 255, 1)
                                  : const Color.fromARGB(255, 184, 233, 241),
                              textColor: isOperator(buttons[index])
                                  ? const Color.fromARGB(255, 0, 0, 0)
                                  : Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: lastButtons.map((item) {
                        return SizedBox(
                          width: buttonSize,
                          height: buttonSize,
                          child: MyButton(
                            buttonTapped: () {
                              handleInput(item == Icons.backspace
                                  ? '⌫'
                                  : item.toString());
                            },
                            content: item,
                            color: item == '='
                                ? const Color.fromARGB(255, 12, 126, 192)
                                : const Color.fromARGB(255, 184, 233, 241),
                            textColor:
                                item == '=' ? Colors.white : Colors.black,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isOperator(dynamic x) {
    return x == '%' || x == 'x' || x == '-' || x == '+' || x == '÷';
  }

  bool isEvaluated = false;

 void handleInput(String input) {
  setState(() {
    // Handle the '-' operator
    if (input == '-') {
      // Prevent consecutive '-' operators
      if (userQuestion.isNotEmpty &&
          userQuestion[userQuestion.length - 1] == '-') {
        return; // Do nothing if the last character is already '-'
      }
    } 
    // Handle generic operator in puts
    else if (isOperator(input)) {
      // Prevent starting with an operator or having multiple consecutive operators
      if (userQuestion.isEmpty ||
          isOperator(userQuestion[userQuestion.length - 1])) {
        return; // Do nothing in these cases
      }
    } 
    // Handle the '√' (square root) operator
    else if (input == '√') {
      // Prevent consecutive '√' operators
      if (userQuestion.isNotEmpty &&
          userQuestion[userQuestion.length - 1] == '√') {
        return; // Do nothing if the last character is already '√'
      } else {
        userQuestion += input; // Append '√' to the question
      }
    }

    // Handle the '⌫' (backspace) input
    if (input == '⌫') {
      userQuestion = userQuestion.isNotEmpty
          ? userQuestion.substring(0, userQuestion.length - 1)
          : ''; // Remove the last character if the question is not empty
    } 
    // Handle the '=' (equals) input
    else if (input == '=') {
      equalPressed(); // Evaluate the expression
      isEvaluated = true; // Mark as evaluated
    } 
    // Handle '0' input
    else if (input == '0') {
      // Prevent multiple leading zeros
      if (userQuestion.isEmpty || userQuestion == '0') {
        userQuestion = '0'; // Keep a single zero
      } else {
        userQuestion += input; // Append zero if valid
      }
    } 
    // Handle input after an evaluated result
    else if (isEvaluated) {
      // If the input is not an operator, reset the question
      if (!isOperator(input)) {
        userQuestion = input; // Start a new question
        userAnswer = ''; // Clear the previous answer
        isEvaluated = false; // Reset evaluation flag
        return;
      } 
      // If the input is an operator, append it to the previous result
      else if (isOperator(input)) {
        userQuestion += input; // Add operator to continue calculation
        isEvaluated = false; // Reset evaluation flag
      }
    } 
    // Handle input when the question is just '0'
    else if (userQuestion == '0') {
      if (input == '.') {
        userQuestion += input; // Allow decimal point after zero
      } else {
        userQuestion = ''; // Clear leading zero
        userQuestion += input; // Append new input
      }
    } 
    // Handle the '.' (decimal point) input
    else if (input == '.') {
      // Prevent multiple decimal points in the question
      if (userQuestion.isEmpty || userQuestion[userQuestion.length - 1] == '.') {
        return; // Do nothing if there's already a decimal point
      } else {
        userQuestion += input; // Append decimal point
      }
    } 
    // Handle any other input that is not a square root
    else if (input != '√') {
      userQuestion += input; // Append input to the question
    }
  });
}


  void equalPressed() {
    String finalQuestion = userQuestion;

    finalQuestion = finalQuestion.replaceAll('x', '*');
    finalQuestion = finalQuestion.replaceAll('÷', '/');

    // Handle square root
    finalQuestion = finalQuestion.replaceAllMapped(
      RegExp(r'√(\d+(\.\d+)?)'),
      (match) => '${sqrt(double.parse(match.group(1)!))}',
    );

    // Handle percentage
    finalQuestion = finalQuestion.replaceAllMapped(
      RegExp(r'(\d+(\.\d+)?)%'),
      (match) => '(${match.group(1)!}/100)',
    );

    try {
      // Check for division by zero
      if (finalQuestion.contains('/0')) {
        setState(() {
          userAnswer = "Can't divide by zero";
        });
        return;
      }

      Parser p = Parser();
      Expression exp = p.parse(finalQuestion);
      ContextModel cm = ContextModel();

      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        if (eval == eval.toInt()) {
        userAnswer = eval.toInt().toString(); // Display as an integer
      } else {
        userAnswer = eval.toString(); // Display as a decimal
      }
      });
    } catch (e) {
      setState(() {
        userAnswer = 'Error';
      });
    }
  }
}
