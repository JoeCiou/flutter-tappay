import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_tappay/flutter_tappay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FlutterTappay.instance.setup(
      appId: 123456,
      appKey: 'app_xxxxxxxxxxxxx',
      isProduction: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter TapPay Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final result = await FlutterTappay.instance.getLinePayPrime(
                returnUrl: 'flutterTappayExample://handleLinePay',
              );

              if (result.type == LinePayPrimeResultType.success) {
                final prime = result.prime;
                debugPrint('Prime: $prime');

                final url = Uri.parse('https://asia-east1-jrbs-app-beta.cloudfunctions.net/testLinePay');
                  final headers = {
                    'Content-Type': 'application/json',
                  };
                  final body = utf8.encode(json.encode({
                    'prime': prime,
                    'returnUrl': 'https://test.com/linepay',
                  }));
                  final response = await http.post(
                    url,
                    headers: headers,
                    body: body,
                  );

                  if (response.statusCode == 200) {
                    final responseJson = json.decode(response.body) as Map<String, dynamic>;
                    final paymentUrl = responseJson['paymentUrl'] as String;

                    final result = await FlutterTappay.instance.redirectToLinePay(
                      paymentUrl: paymentUrl,
                    );

                    debugPrint('Result: ${result.status}');
                  } else {
                    print('Error: ${response.statusCode}, ${response.body}');
                  }
              } else if (result.type == LinePayPrimeResultType.failure) {
                debugPrint('Error: ${result.code}, ${result.message}');
              }   
            },
            child: const Text('Line Pay'),
          ),
        ),
      ),
    );
  }
}
