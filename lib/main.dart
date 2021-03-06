import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Geekwalk UI'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _GeekWalk _form = _GeekWalk();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String port = "";

  void getHttp() async {
    try {
      var response = await Dio().get('http://127.0.0.1:8888');
      print(response);
    } catch (e) {
      print(e);
    }
  }

  void _addFrontend() {
    setState(() {
      _form.frontend.add(new _GeekWalkFrontend());
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    String str = json.encode(_form);
    try {
      await Dio().post('http://127.0.0.1:8888/config', data: str);
      showMessage("????????????");
    } on DioError catch (err) {
      showMessage(err.response!.data.toString());
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration:
                    InputDecoration(hintText: '??????', labelText: '??????????????????'),
                    validator: (value) {
                      if (value!.length == 0) {
                        return '??????????????????';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        _form.port = int.parse(value);
                      }
                    }),
                ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: _form.frontend.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration:
                                      InputDecoration(labelText: '??????'),
                                      validator: (value) {
                                        if (!value!.startsWith("/")) {
                                          return "??????/??????";
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _form.frontend[index].prefix = value!;
                                      },
                                    ),
                                    TextFormField(
                                      decoration:
                                      InputDecoration(labelText: '????????????'),
                                      onSaved: (value) {
                                        _form.frontend[index].dir = value!;
                                      },
                                    ),
                                    TextFormField(
                                      decoration:
                                      InputDecoration(labelText: '404?????????'),
                                      onSaved: (value) {
                                        _form.frontend[index].reroute404 =
                                        value!;
                                      },
                                    ),
                                    TextFormField(
                                      decoration:
                                      InputDecoration(labelText: '?????????????????????'),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onSaved: (value) {
                                        if (value!.isNotEmpty) {
                                          _form.frontend[index].maxAgeSeconds =
                                              int.parse(value);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _form.frontend[index].cachingEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    _form.frontend[index].cachingEnabled =
                                        value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                TextButton(onPressed: _addFrontend, child: Text("????????????")),
                ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: _form.backend.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration:
                                      InputDecoration(labelText: '??????'),
                                      validator: (value) {
                                        if (!value!.startsWith("/")) {
                                          return "??????/??????";
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _form.backend[index].prefix = value!;
                                      },
                                    ),
                                    TextFormField(
                                      decoration:
                                      InputDecoration(labelText: '????????????'),
                                      validator: (value) {
                                        // if(value == null || !value.startsWith("http://"))

                                        if (!((value != null &&
                                            value.startsWith(
                                                "http://")) ||
                                            (value != null &&
                                                value
                                                    .startsWith("https://"))
                                            // value.startsWith("https://")

                                        )) {
                                          return "??????http://???https://??????";
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _form.backend[index].upstream = value!;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _form.backend.add(new _GeekWalkBackend());
                      });
                    },
                    child: Text("????????????"))

                // Row(
                //   // mainAxisSize: MainAxisSize.max,
                //   children: [
                //     Text("??????"),
                //     SizedBox(
                //       width: 100,
                //       child: TextField(
                //         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                //         controller: _controller,
                //       ),
                //     )
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submit,
        tooltip: '??????',
        child: Icon(Icons.save),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _GeekWalk {
  late int port;
  List<_GeekWalkFrontend> frontend = [];
  List<_GeekWalkBackend> backend = [];

  Map<String, dynamic> toJson() =>
      {
        'port': port,
        "frontend": frontend.map((c) => c.toJson()).toList(),
        "backend": backend.map((c) => c.toJson()).toList(),
      };
}

class _GeekWalkFrontend {
  late String prefix;
  late String dir;
  late String reroute404;
  late bool cachingEnabled = false;
  late int maxAgeSeconds;

  Map<String, dynamic> toJson() =>
      {
        'prefix': prefix,
        'dir': dir,
        'reroute404': reroute404,
        'cachingEnabled': cachingEnabled,
        'maxAgeSeconds': maxAgeSeconds,
      };
}

class _GeekWalkBackend {
  late String prefix;
  late String upstream;

  Map<String, dynamic> toJson() => {'prefix': prefix, 'upstream': upstream};
}
