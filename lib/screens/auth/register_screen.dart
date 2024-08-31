import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sih_practice/screens/auth/bottombar_screen.dart';
import 'package:sih_practice/screens/auth/login_screen.dart';
import 'package:sih_practice/services/auth_services.dart';
import 'package:sih_practice/services/notification_service.dart';
import 'package:sih_practice/widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();
  bool isloading = false;
  String token = "";

  NotificationServices notificationServices = new NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    notificationServices.notificationPermission();
    notificationServices.firebaseInit();
    notificationServices.isTokenRefresh();
    notificationServices.getToken().then((value) {
      print(value);
      token = value;
    });
    super.initState();
  }
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
                                'Signup',
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
                                'Join our library community with just a few clicks.',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            Image.asset('assets/images/splash.png'),
                            TextFormField(
                              controller: userNameController,
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Full Name',
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Name can not be empty';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: emailController,
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
                              height: 10,
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
                                  register();
                                },
                                child: Text(
                                  'Register',
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
                                  "Already Have an Account?",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                                TextButton(
                                  onPressed: () {
                                    nextScreen(context, LoginScreen());
                                  },
                                  child: Text('Login Now',
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

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      await AuthServices()
          .signUpUserwithEmailandPAssword(userNameController.text,
              emailController.text.toLowerCase(), passwordController.text , token)
          .then((value) async {
        if (value == true) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => BottomBarScreen()),
              (route) => false);
          setState(() {
            isloading = false;
            emailController.clear();
            passwordController.clear();
            userNameController.clear();
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
