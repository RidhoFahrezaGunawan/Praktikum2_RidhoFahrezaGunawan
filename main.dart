import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  TextEditingController num1Controller = TextEditingController();
  TextEditingController num2Controller = TextEditingController();
  TextEditingController operationController = TextEditingController();

  SharedPreferences? sharedPreferences;

  void initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  void calculateAndSaveResult() {
    double num1 = double.parse(num1Controller.text);
    double num2 = double.parse(num2Controller.text);
    String operation = operationController.text;
    double result;

    switch (operation) {
      case '+':
        result = num1 + num2;
        break;
      case '-':
        result = num1 - num2;
        break;
      case '*':
        result = num1 * num2;
        break;
      case '/':
        result = num1 / num2;
        break;
      default:
        return;
    }

    sharedPreferences?.setDouble('result', result);
    sharedPreferences?.setString('operation', operation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: num1Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Number 1'),
            ),
            TextField(
              controller: num2Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Number 2'),
            ),
            TextField(
              controller: operationController,
              decoration: InputDecoration(labelText: 'Operation (+, -, *, /)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                calculateAndSaveResult();
              },
              child: Text('Hitung'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ResultScreen(),
                ));
              },
              child: Text('Lihat Hasil'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  SharedPreferences? sharedPreferences;

  void initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    initializeSharedPreferences();
    double result = sharedPreferences?.getDouble('result') ?? 0.0;
    String operation = sharedPreferences?.getString('operation') ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Operasi Aritmatika'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hasil Operasi Aritmatika: $result'),
            Text('Operasi Aritmatika: $operation'),
          ],
        ),
      ),
    );
  }
}
