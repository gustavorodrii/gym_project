import 'package:flutter/material.dart';
import 'package:gym_project/data/workout_data.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Hive.openBox("workout_database1");

    didChangeDependencies();

    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  final newWorkoutNameController = TextEditingController();

  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Crie um novo treino"),
        content: TextField(
          controller: newWorkoutNameController,
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: Text("Salvar"),
          ),
          MaterialButton(
            onPressed: cancel,
            child: Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutPage(
            workoutName: workoutName,
          ),
        ));
  }

  void save() {
    String newWorkoutName = newWorkoutNameController.text;
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
  }

  void clear() {
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Treinos'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          child: const Icon(Icons.add),
        ),
        body: Container(
          color: Colors.grey[200],
          child: ListView.builder(
            itemCount: value.getWorkoutList().length,
            itemBuilder: (context, index) => Dismissible(
              key: Key(value.getWorkoutList()[index].name),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                Provider.of<WorkoutData>(context, listen: false)
                    .deleteWorkout(index);
              },
              background: Container(
                color: Colors.red,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  title: Text(
                    value.getWorkoutList()[index].name,
                    textAlign: TextAlign.end,
                  ),
                  trailing: InkWell(
                    onTap: () =>
                        goToWorkoutPage(value.getWorkoutList()[index].name),
                    child: Container(
                      color: Colors.grey[800],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InkWell(
                          onTap: () => goToWorkoutPage(
                              value.getWorkoutList()[index].name),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                value.getWorkoutList()[index].name,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
