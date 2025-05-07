import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController id = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController userStatus = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Users", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: id,
              decoration: InputDecoration(hintText: "ID"),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            TextField(
              controller: email,
              decoration: InputDecoration(hintText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: userName,
              decoration: InputDecoration(hintText: "username"),
            ),
            TextField(
              controller: firstName,
              decoration: InputDecoration(hintText: "firstname"),
              keyboardType: TextInputType.name,
            ),
            TextField(
              controller: lastName,
              decoration: InputDecoration(hintText: "lastname"),
              keyboardType: TextInputType.name,
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(hintText: "Password"),
            ),
            ElevatedButton(
              onPressed: () {
                if (validationBeforeRegister()) {
                  registerUser();
                }
              },
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }

  bool validationBeforeRegister() {
    if (id.text.isEmpty) {
      return _showError("Please fill ID");
    }
    if (email.text.isEmpty) {
      return _showError("Enter an email");
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email.text)) {
      return _showError("Enter a valid email");
    }
    if (userName.text.isEmpty) {
      return _showError("Username is required");
    }
    if (firstName.text.isEmpty) {
      return _showError("First name is required");
    }
    if (lastName.text.isEmpty) {
      return _showError("Last name is required");
    }
    if (password.text.isEmpty) {
      return _showError("Enter password");
    }
    if (password.text.length < 6) {
      return _showError("Password must be at least 6 characters");
    }

    return true;
  }

  bool _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
    return false;
  }

  void registerUser() async {
    var baseUrl = "https://rest.echoapi.com/users";
    var data = {
      "id": id.text,
      "username": userName.text,
      "firstName": firstName.text,
      "lastName": lastName.text,
      "email": email.text,
      "password": password.text,
      "phone": "",
      "userStatus": 0,
    };

    var body = json.encode(data);
    var urlParse = Uri.parse(baseUrl);
    http.Response response = await http.post(
      urlParse,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    var responseData = jsonDecode(response.body);
    var errorCode = responseData['error'];
    var messageDone = responseData['msg'];
    _showError(messageDone);

    print(responseData);
  }
}
