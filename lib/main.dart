import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final titleController = TextEditingController();
  final desCriptionController = TextEditingController();

  // final Stream<QuerySnapshot> notes =
  //     FirebaseFirestore.instance.collection('notes').snapshots();

  @override
  Widget build(BuildContext context) {
    CollectionReference notes = FirebaseFirestore.instance.collection('notes');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fire Note'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (() {
          showModalBottomSheet(
              context: context,
              builder: (c) {
                return Container(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          hintText: 'Title',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: desCriptionController,
                        decoration: const InputDecoration(
                          hintText: 'description',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MaterialButton(
                        onPressed: () {
                          notes.add({
                            'title': titleController.text,
                            'description': desCriptionController.text,
                          });
                        },
                        child: const Text('Add Note'),
                      ),
                    ],
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                    ),
                  ),
                );
              });
        }),
      ),
      body: Center(
        child: StreamBuilder(
          stream: notes.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading');
            }

            final data = snapshot.requireData;

            return ListView.builder(
                itemCount: data.size,
                itemBuilder: ((context, index) {
                  return ListTile(
                    title: Text(
                      data.docs[index]['title'],
                    ),
                    subtitle: Text(data.docs[index]['description']),
                  );
                }));
          },
        ),
      ),
    );
  }
}
