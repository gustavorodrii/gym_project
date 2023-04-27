import 'package:flutter/material.dart';
import 'package:gym_project/components/exercise_tile.dart';
import 'package:gym_project/data/workout_data.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  final exerciseNameController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Adicione um novo exercício",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, color: Colors.grey[900]),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: exerciseNameController,
              decoration: InputDecoration(hintText: 'Nome do exercício'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Este campo é obrigatório';
                }
                return null;
              },
            ),
            TextField(
              controller: repsController,
              decoration: InputDecoration(hintText: 'Repetições do exercício'),
            ),
            TextField(
              controller: setsController,
              decoration: InputDecoration(hintText: 'Séries do exercício'),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                onPressed: () {
                  if (exerciseNameController.text.isEmpty) {
                    return;
                  }
                  save();
                },
                child: Text(
                  "Salvar",
                  style: TextStyle(fontSize: 16, color: Colors.grey[900]),
                ),
              ),
              MaterialButton(
                onPressed: cancel,
                child: Text(
                  "Cancelar",
                  style: TextStyle(fontSize: 16, color: Colors.grey[900]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void save() {
    String newExerciseName = exerciseNameController.text;
    String reps = repsController.text;
    String sets = setsController.text;

    Provider.of<WorkoutData>(context, listen: false).addExercise(
      widget.workoutName,
      newExerciseName,
      reps,
      sets,
    );

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
  }

  void clear() {
    exerciseNameController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.grey[900],
          title: Text(
            widget.workoutName.toUpperCase(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 2,
          backgroundColor: Colors.grey[900],
          onPressed: createNewExercise,
          child: const Icon(Icons.add, size: 30),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: value.numberOfExercisesInWorkout(widget.workoutName),
            itemBuilder: (context, index) => ExerciseTile(
              exerciseName: value
                  .getRelevantWorkout(widget.workoutName)
                  .exercises[index]
                  .name,
              reps: value
                  .getRelevantWorkout(widget.workoutName)
                  .exercises[index]
                  .reps,
              sets: value
                  .getRelevantWorkout(widget.workoutName)
                  .exercises[index]
                  .sets,
              isCompleted: value
                  .getRelevantWorkout(widget.workoutName)
                  .exercises[index]
                  .isCompleted,
              onCheckBoxChanged: (val) => onCheckBoxChanged(
                widget.workoutName,
                value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .name,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
