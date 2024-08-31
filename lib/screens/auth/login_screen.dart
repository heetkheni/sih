import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sih_practice/screens/auth/bottombar_screen.dart';
import 'package:sih_practice/screens/auth/register_screen.dart';
import 'package:sih_practice/services/auth_services.dart';
import 'package:sih_practice/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isloading
            ? Center(
                child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ))
            : Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 80),
                    child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Unlock a world of books with your library account.',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            Image.asset('assets/images/splash.png'),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Email',
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val!)
                                    ? null
                                    : 'Please enter a valid email';
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: passwordController,
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Password',
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              validator: (val) {
                                if (val!.length < 6) {
                                  return 'Password must have atleast 6 characters';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 45,
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () {
                                  login();
                                },
                                child: Text(
                                  'LogIn',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    elevation: 00),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't Have an Account?",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                                TextButton(
                                  onPressed: () {
                                    nextScreen(context, RegisterScreen());
                                  },
                                  child: Text('Register here',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 14,
                                      )),
                                )
                              ],
                            )
                          ],
                        )),
                  ),
                ),
              ));
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      await AuthServices()
          .loginUserwithEmailandPAssword(
              emailController.text.toLowerCase(), passwordController.text)
          .then((value) async {
        if (value == true) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => BottomBarScreen()),
              (route) => false);
          setState(() {
            isloading = false;
            emailController.clear();
            passwordController.clear();
          });
        } else {
          setState(() {
            isloading = false;
          });
          showSnackBar(context, Colors.red, value);
        }
      });
    }
  }
}
