import 'dart:io';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CleverTap Flutter Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CleverTap Flutter Project'),
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
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // CleverTap logs enabled
    CleverTapPlugin.setDebugLevel(3);

    // CleverTap notification channel
    CleverTapPlugin.createNotificationChannel("fluttertestapp", "Flutter Test", "Flutter Test", 5, true);

    // CleverTap AppInbox initialization
    CleverTapPlugin.initializeInbox();

    // CleverTap App Personalization
    CleverTapPlugin.enablePersonalization();

    // CleverTap Push Install Referrer
    CleverTapPlugin.pushInstallReferrer("source", "medium", "campaign");

    // CleverTap GDPR OptIn
    CleverTapPlugin.setOptOut(false);

    // CleverTap Device Networking Info
    CleverTapPlugin.enableDeviceNetworkInfoReporting(true);

    var lat = 19.07;
    var long = 72.87;
    CleverTapPlugin.setLocation(lat, long);

    // ignore: unused_element
    void inboxDidInitialize() {
      setState(() {
        print("inboxDidInitialize called");
        var styleConfig = {
          'noMessageTextColor': '#ff6600',
          'noMessageText': 'No message(s) to show.',
          'navBarTitle': 'App Inbox'
        };
        CleverTapPlugin.showInbox(styleConfig);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const CustomTextField(
              labelText: 'Enter Identity',
              hintText: 'Enter Your Identity',
            ),
            const CustomTextField(
              labelText: 'Enter Full Name',
              hintText: 'Enter Your Full Name',
            ),
            const CustomTextField(
              labelText: 'Enter Email',
              hintText: 'Enter Your Email ID',
            ),
            const CustomTextField(
              labelText: 'Enter Phone',
              hintText: 'Enter Your Phone Number',
            ),
            CustomButton(
              text: 'On User Login Button',
              onPressed: () {
                var stuff = ["Shoes", "Winshitter"];
                var profile = {
                  'Name': 'Hello Mottoa',
                  'Identity': 'mottog',
                  'Email': 'hellomotto@yopmail.com',
                  'Phone': '+916784213212',
                  'stuff': stuff
                };
                CleverTapPlugin.onUserLogin(profile);
              },
            ),
            CustomButton(
              text: 'User Profile Update Button',
              onPressed: () {
                var stuff = ["bags", "shoes"];
                var dob = '2012-04-22';
                var profile = {
                  'Name': 'John Wick',
                  'Identity': '100',
                  'dob': CleverTapPlugin.getCleverTapDate(DateTime.parse(dob)),
                  'Email': 'john@gmail.com',
                  'Phone': '+14155551234',
                  'props': 'property1',
                  'stuff': stuff
                };
                CleverTapPlugin.profileSet(profile);
                Text(myController.text);
              },
            ),
            CustomButton(
              text: 'Event With No Properties Button',
              onPressed: () {
                CleverTapPlugin.recordEvent("Category Viewed", {});
              },
            ),
            CustomButton(
              text: 'Event With Properties Button',
              onPressed: () {
                var eventData = {
                  'Product Category': 'Appliances',
                  'Product Name': 'Convection Microwave Oven'
                };
                CleverTapPlugin.recordEvent("Product Viewed Flutter Properties", eventData);
              },
            ),
            CustomButton(
              text: 'Charged Event Button',
              onPressed: () {
                var item1 = {
                  'name': 'thing1',
                  'amount': '100'
                };
                var item2 = {
                  'name': 'thing2',
                  'amount': '100'
                };
                var items = [item1, item2];
                var chargeDetails = {
                  'total': '200',
                  'payment': 'cash'
                };
                CleverTapPlugin.recordChargedEvent(chargeDetails, items);
              },
            ),
            CustomButton(
              text: 'App Inbox Button',
              onPressed: () {
                var eventData = {
                  'Product Category': 'Appliances',
                  'Product Name': 'Convection Microwave Oven'
                };
                CleverTapPlugin.recordEvent("App Inbox Button", eventData);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          hintText: hintText,
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
