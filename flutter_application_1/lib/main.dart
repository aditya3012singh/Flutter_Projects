// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// String name = 'kjhdiug';
// int number = 1;
// double lskd = 1.0;
// List myList = ['sdf', 'dfs'];
// Map<String, String> myMap = {'String': 'String'};
// Map<String, dynamic> myMap1 = {'String': 'String', 'String2': 4444};

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.deepPurple,
//           brightness: Brightness.dark,
//         ),
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//         // leading: Icon(Icons.notification_add, color: Colors.amber),
//       ),
//       // body: Center(
//       //   // Center is a layout widget. It takes a single child and positions it
//       //   // in the middle of the parent.
//       //   child: Container(
//       //     color: Colors.black,
//       //     child: Row(
//       //       //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       //       mainAxisSize: MainAxisSize.min,
//       //       // crossAxisAlignment: CrossAxisAlignment.start,
//       //       children: [
//       //         Container(
//       //           height: 100.0,
//       //           width: 100.0,
//       //           decoration: BoxDecoration(
//       //             borderRadius: BorderRadius.circular(25.0),
//       //             color: Colors.red,
//       //           ),
//       //           child: Center(child: Text("hello"),),
//       //         ),
//       //         Container(
//       //           height: 100.0,
//       //           width: 100.0,
//       //           decoration: BoxDecoration(
//       //             borderRadius: BorderRadius.circular(25.0),
//       //             color: Colors.red,
//       //           )
//       //         )
//       //       ],
//       //     ),
//       //   ),
//       // ),
//       // body: Container(
//       //   // padding: EdgeInsets.all(50.0),
//       //   child: Stack(
//       //     children: [
//       //       // Image.asset(
//       //       //   'assets/images/image.png',
//       //       //   fit: BoxFit.cover,
//       //       //   height: 300,
//       //       // ),
//       //       SizedBox(
//       //         height: 300,
//       //         width: 300,
//       //         child: Center(child: Text("flutter")),
//       //       ),
//       //       ListTile(
//       //         leading: Icon(Icons.account_tree),
//       //         title: Text("khsfriuh"),
//       //         tileColor: Colors.blue,
//       //         trailing: Text("hello"),
//       //         onTap: () {
//       //           print("Clicked on something");
//       //         },
//       //       ),
//       //     ],
//       //   ),
//       // ),
//       body: Wrap(children: [
//         Text("hello hoe are u"),
//         Text("hello how are you"),
//         Text("hello how are u"),
//         Text("hello how are you "),
//         Text("hello how are you"),
//         Text("hello how are you"),
//       ],),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// stateless
// material app
// scaffold

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.teal,
//           brightness: Brightness.dark,
//         ),
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("My App"),
//           centerTitle: true,
//           leading: Icon(Icons.login),
//           actions: [
//             Text("hello"),
//             Icon(Icons.logout)
//           ],
//           backgroundColor: Colors.teal,
//         ),
//         drawer: Drawer(
//           child: Column(
//             children: [
//               ListTile(
//                 title: Text("Logout"),
//               ),
//             ],
//           ),
//         ),
//         floatingActionButton: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             FloatingActionButton(
//               onPressed: () {
//                 print("hello");
//               },
//               child: Icon(Icons.add),
//             ),
//             SizedBox(
//               height: 10.0,
//             ),
//             FloatingActionButton(
//               onPressed: () {
//                 print("hello");
//               },
//               child: Icon(Icons.add),
//             ),
//           ],
//         ),
//         bottomNavigationBar: NavigationBar(
//           destinations: [
//             NavigationDestination(
//               icon: Icon(Icons.home), label:'Home'
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.person), label:'Profile'
//             ),
//           ],
//           onDestinationSelected: (int value) {
//             // print(value);
//           },
//           selectedIndex: 0,
//         ),
//       ),
//     );
//   }
// }

// Material App(Stateful)
// scaffold
// App title
// Bottom Navigation Bar setState

// stateful can refresh
// stateless cant refresh
// setstate to refresh

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/constants.dart';
import 'package:flutter_application_1/data/notifiers.dart';
import 'package:flutter_application_1/views/pages/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_application_1/views/widget_tree.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyApp> {
  @override
  void initState() {
    initThemeMode();
    super.initState();
  }

  void initThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? repeat = prefs.getBool(KConstants.themeModeKey);
    isDarkModeNotifier.value = repeat ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
            ),
          ),
          home: WelcomePage(),
        );
      },
    );
  }
}
