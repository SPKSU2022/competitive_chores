import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:competative_chores/Amplify.dart';
import 'package:competative_chores/Classes/Families.dart';
import 'package:competative_chores/Classes/Formatting.dart';
import 'package:competative_chores/Classes/User.dart';
import 'package:competative_chores/MainPage.dart';
import 'package:competative_chores/Screens/FamilyChecker.dart';
import 'package:competative_chores/Screens/LoginRoot.dart';
import 'package:competative_chores/Services/Database.dart';
import 'package:competative_chores/Services/Initializer.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'amplifyconfiguration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
      print('Successfully configured');
    } on Exception catch (e) {
      print('Error configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      signUpForm: SignUpForm.custom(
        fields: [
          SignUpFormField.username(),
          SignUpFormField.password(),
          SignUpFormField.passwordConfirmation(),
          SignUpFormField.email(required: true),
          SignUpFormField.name(required: true)
        ],
      ),
      child: MaterialApp(
          theme: ThemeData(
              inputDecorationTheme: InputDecorationTheme(
                floatingLabelStyle: TextStyle(color: Formatting.textColor),
                labelStyle: TextStyle(color: Formatting.textColor.withAlpha(150)),
                counterStyle: TextStyle(color: Formatting.textColor.withAlpha(150)),
                errorStyle: const TextStyle(color: Colors.red),
                hoverColor: Formatting.bannerBlue.withAlpha(100),
                iconColor: Formatting.lighterRed,
                contentPadding: const EdgeInsets.all(16),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                fillColor: Formatting.bannerBlue.withAlpha(200),
                filled: false,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(style: BorderStyle.solid),
                ),
              ),
              indicatorColor: Formatting.lighterRed,
              textTheme: TextTheme(
                  bodyText1: TextStyle(color: Formatting.textColor),
                  subtitle2: TextStyle(color: Formatting.textColor),
                  subtitle1: TextStyle(color: Formatting.textColor),
                  labelMedium: TextStyle(color: Formatting.textColor)),
              cardColor: Formatting.bannerRed,
              canvasColor: Formatting.creame,
              colorScheme: ColorScheme(
                  brightness: Brightness.light,
                  primary: Formatting.bannerBlue,
                  onPrimary: Color.fromARGB(255, 255, 212, 212),
                  secondary: Formatting.bannerBlue,
                  onSecondary: Colors.green,
                  error: Colors.blue,
                  onError: Colors.amber,
                  background: Colors.yellow,
                  onBackground: Colors.purple,
                  surface: Formatting.bannerBlue,
                  onSurface: Color.fromARGB(255, 190, 38, 58))),
          color: Formatting.creame,
          builder: Authenticator.builder(),
          home: const LoginRoot()),
    );
  }
}
