import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/auth/SignInPage.dart';

import 'common/SharePrefService.dart';

void main() async {
  // Init
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.sharePrefsInit();

  // Start the app
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    MyAppState state = context.findAncestorStateOfType<MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    Locale appLocale = sharedPrefs.getLocale();
    setState(() {
      _locale = appLocale;
    });
    super.didChangeDependencies();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (this._locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800]!)),
        ),
      );
    }
    else {
      return CupertinoApp(
        theme: const CupertinoThemeData(brightness: Brightness.light),
        // home: CupertinoHomePage(),
        home: const SignInPage(),
        locale: _locale,
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        supportedLocales: const [
          Locale("en", "US"),
          Locale("vi", "VN"),
        ],
      );
    }
  }
}
