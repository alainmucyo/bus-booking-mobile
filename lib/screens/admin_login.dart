import 'package:booking_app/providers/auth_provider.dart';
import 'package:booking_app/screens/admin_dashboard.dart';
import 'package:booking_app/screens/admin_reports.dart';
import 'package:booking_app/utils/constants.dart';
import 'package:booking_app/utils/http_exception.dart';
import 'package:booking_app/widgets/shared/input_widget.dart';
import 'package:booking_app/widgets/shared/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminLogin extends StatefulWidget {
  static const routeName = "/login";

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  var _isLoading = false;
  var _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _loginData = {"username": "", "password": ""};

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .login(_loginData["username"], _loginData["password"]);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => AdminDashboard()),
          ModalRoute.withName("/admin-dashboard"));
    } on HttpException catch (err) {
      Utils.showSnackBar(title: err.message, context: context);
      return;
    } catch (err) {
      print(err);
      Utils.showSnackBar(title: err.toString(), context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.PRIMARY,
        title: Text("Login"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        "Welcome Back :)",
                        style: TextStyle(
                            fontSize: 30,
                            color: CustomColor.SUPER_DARK_GREY,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                        child: Text(
                      "Please, provide your credentials to login as a bus driver!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    )),
                    SizedBox(height: 45),
                    InputWidget(
                      label: "Username",
                      inputType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Username can\'t be empty!';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _loginData["username"] = val;
                      },
                    ),
                    SizedBox(height: 22),
                    InputWidget(
                      label: "Password",
                      obscure: true,
                      inputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Password can\'t be empty!';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _loginData["password"] = val;
                      },
                    ),
                    SizedBox(height: 22),
                    PrimaryButton(
                      text: "Login",
                      isLoading: _isLoading,
                      block: true,
                      onPressed: _submitForm,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
