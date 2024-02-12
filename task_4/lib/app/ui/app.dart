import 'dart:async';

import 'package:devtools_flutter/app/data/data_network.dart';
import 'package:flutter/material.dart';

import '../data/stundents.dart';
import '../data/data_not_network.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список студентов'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Все студенты'),
            Tab(text: 'Активисты'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FutureBuilder(
            future: getStudents(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data!
                      .map(
                        (student) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage('assets/avatar.webp'),
                            maxRadius: 20,
                            child: Text(student.lastName),
                          ),
                          title: Text(
                              '${student.lastName} ${student.firstName} ${student.middleName}'),
                          subtitle: Text('Средний балл: ${student.rating}'),
                          trailing: IconButton(
                            icon: Icon(student.isActivist
                                ? Icons.star
                                : Icons.star_border),
                            onPressed: () =>
                                _showConfirmationBottomSheet(context, student),
                          ),
                        ),
                      )
                      .toList(),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          FutureBuilder(
            future: getStudents(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data!
                      .where((studnet) => studnet.isActivist == true)
                      .map(
                        (student) => ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/avatar.webp'),
                        maxRadius: 20,
                        child: Text(student.lastName),
                      ),
                      title: Text(
                          '${student.lastName} ${student.firstName} ${student.middleName}'),
                      subtitle: Text('Средний балл: ${student.rating}'),
                      trailing: IconButton(
                        icon: Icon(student.isActivist
                            ? Icons.star
                            : Icons.star_border),
                        onPressed: () =>
                            _showConfirmationBottomSheet(context, student),
                      ),
                    ),
                  )
                      .toList(),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showConfirmationBottomSheet(BuildContext context, Student student) {
    StreamController<int> _streamController = StreamController<int>();
    Stream stream = _streamController.stream;

    _streamController.sink.add(42);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  'Изменить статус ${student.firstName} на ${student.isActivist ? 'не активист' : 'активист'}?'),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      StreamSubscription streamSubscription =
                          stream.listen((event) {
                        print(event);
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Отмена'),
                  ),
                  TextButton(
                    onPressed: () {
                      student.isActivist = !student.isActivist;
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    child: const Text('Подтвердить'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
