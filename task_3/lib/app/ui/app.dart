import 'dart:async';

import 'package:flutter/material.dart';

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

  List<Student> students = [
    Student('Иванов', 'Иван', 'Иванович', 4.5, true),
    Student('Петров', 'Петр', 'Петрович', 3.8, false),
    Student('Сидорова', 'Анна', 'Игоревна', 4.2, true),
    Student('Козлов', 'Екатерина', 'Александровна', 3.9, false),
    Student('Никитин', 'Дмитрий', 'Владимирович', 4.8, true),
    Student('Лебедева', 'Ольга', 'Сергеевна', 3.5, false),
    Student('Морозов', 'Артем', 'Васильевич', 4.1, true),
    Student('Смирнова', 'Елизавета', 'Дмитриевна', 4.3, true),
    Student('Кузнецов', 'Илья', 'Александрович', 3.7, false),
    Student('Васильева', 'Мария', 'Павловна', 4.6, true),
    Student('Федоров', 'Алексей', 'Игоревич', 3.6, false),
    Student('Щербакова', 'Анастасия', 'Олеговна', 4.4, true),
    Student('Жуков', 'Максим', 'Сергеевич', 3.8, false),
    Student('Комарова', 'Екатерина', 'Ивановна', 4.0, true),
    Student('Белов', 'Даниил', 'Алексеевич', 3.9, false),
    Student('Григорьева', 'Анна', 'Владимировна', 4.7, true),
    Student('Тимофеев', 'Артем', 'Степанович', 3.7, false),
    Student('Лебедь', 'Евгений', 'Викторович', 4.2, true),
    Student('Соколова', 'Ольга', 'Владимировна', 3.6, false),
    Student('Кузьмин', 'Андрей', 'Сергеевич', 4.5, true),
  ];

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
          buildStudentList(students),
          buildActivistList(students),
        ],
      ),
    );
  }

  Widget buildStudentList(List<Student> students) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/avatar.webp'),
            maxRadius: 20,
            child: Text(students[index].lastName[0]),
          ),
          title: Text(
              '${students[index].lastName} ${students[index].firstName} ${students[index].middleName}'),
          subtitle: Text('Средний балл: ${students[index].rating}'),
          trailing: IconButton(
            icon: Icon(
                students[index].isActivist ? Icons.star : Icons.star_border),
            onPressed: () =>
                _showConfirmationBottomSheet(context, students[index]),
          ),
        );
      },
    );
  }

  Widget buildActivistList(List<Student> students) {
    List<Student> activists =
        students.where((student) => student.isActivist).toList();
    return ListView.builder(
      itemCount: activists.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/avatar.webp'),
            maxRadius: 20,
            child: Text(activists[index].lastName[0]),
          ),
          title: Text(
              '${activists[index].lastName} ${activists[index].firstName} ${activists[index].middleName}'),
          subtitle: Text('Средний балл: ${activists[index].rating}'),
        );
      },
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
                      StreamSubscription streamSubscription = stream.listen((event) {
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

class Student {
  String lastName;
  String firstName;
  String middleName;
  double rating;
  bool isActivist;

  Student(this.lastName, this.firstName, this.middleName, this.rating,
      this.isActivist);
}
