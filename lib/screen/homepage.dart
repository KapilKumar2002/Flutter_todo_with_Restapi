import 'dart:convert';

import 'package:dailyroutine/constants/constants.dart';
import 'package:dailyroutine/models/datamodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  Future<Response> deleteAlbum(String id) async {
    final http.Response response = await http.delete(
      Uri.parse(Constants.url + "/" + id + "/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "application/json",
      },
    );

    setState(() {
      datalist = [];
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Task that you have done deleted"),
      backgroundColor: Constants.themeColor,
    ));
    return response;
  }

  Future<void> saveData() async {
    final String textVal = _titleController.text;
    final String desVal = _descController.text;
    if (textVal.isNotEmpty && desVal.isNotEmpty) {
      final response = await http.post(Uri.parse(Constants.url),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"task": textVal, "taskdesc": desVal}));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Data saved"),
        backgroundColor: Constants.themeColor,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Invalid credentials!"),
        backgroundColor: Constants.themeColor,
      ));
    }
    setState(() {
      datalist = [];
    });
  }

  Future<void> updateData(String id) async {
    final String textVal = _titleController.text;
    final String desVal = _descController.text;
    if (textVal.isNotEmpty && desVal.isNotEmpty) {
      http.put(
        Uri.parse(Constants.url + "/" + id + "/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'Accept': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'task': _titleController.text,
          'taskdesc': _descController.text,
        }),
      );
      // if (_titleController.text != textVal || _descController.text != desVal) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Task has been updated by you"),
        backgroundColor: Constants.themeColor,
      ));
      // }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Invalid credentials!"),
        backgroundColor: Constants.themeColor,
      ));
    }
    setState(() {
      datalist = [];
    });
  }

  List<ShowDataModel> datalist = [];

  Future<List<ShowDataModel>> getdata() async {
    datalist = [];
    var response = await http.get(Uri.parse('http://10.0.2.2:8000'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map<String, dynamic> i in data) {
        datalist.add(ShowDataModel.fromJson(i));
      }
      return datalist.reversed.toList();
    } else {
      return datalist.reversed.toList();
    }
  }

  Future<void> getInputtext() async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task',
                  ),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'Description of Task',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.themeColor),
                  onPressed: () {
                    saveData();
                    _titleController.text = '';
                    _descController.text = '';
                    Navigator.of(context).pop();
                    // }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> updatedata(String id, String task, String taskdesc) async {
    if (task.isNotEmpty && taskdesc.isNotEmpty) {
      _titleController.text = task;
      _descController.text = taskdesc;
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task',
                  ),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'Description of Task',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.themeColor),
                  onPressed: () {
                    updateData(id);
                    _titleController.text = '';
                    _descController.text = '';
                    Navigator.of(context).pop();
                    // }
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Routine"),
        backgroundColor: Constants.themeColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getInputtext();
        },
        child: Icon(Icons.add),
        backgroundColor: Constants.themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Expanded(
            child: FutureBuilder(
                future: getdata(),
                builder:
                    ((context, AsyncSnapshot<List<ShowDataModel>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Constants.themeColor,
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: datalist.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 20,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        snapshot.data![index].task.toString(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Constants.themeColor),
                                          onPressed: () {
                                            updatedata(
                                                snapshot.data![index].id
                                                    .toString(),
                                                snapshot.data![index].task
                                                    .toString(),
                                                snapshot.data![index].taskdesc
                                                    .toString());
                                          },
                                          child: Text("Edit"))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              right: 13.0),
                                          child: Text(
                                            snapshot.data![index].taskdesc
                                                .toString(),
                                            overflow: TextOverflow.visible,
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          color: Constants.themeColor,
                                          onPressed: () {
                                            // setState(() {
                                            deleteAlbum(snapshot.data![index].id
                                                .toString());
                                            // });
                                          },
                                          icon: Icon(Icons.delete))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                })),
          )
        ]),
      ),
    );
  }
}
