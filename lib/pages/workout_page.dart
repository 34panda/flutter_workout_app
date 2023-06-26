import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({Key? key, required this.workoutName}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  // checkbox was tapped
  void onCheckboxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  // text controllers
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

 // create a new exercise
void createNewExercise() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Add a new exercise'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // exercise name
          TextField(
            controller: exerciseNameController,
            decoration: const InputDecoration(
              hintText: 'Exercise Name',
            ),
          ),

          // weight
          TextField(
            controller: weightController,
            decoration: const InputDecoration(
              hintText: 'Weight',
            ),
          ),

          // reps
          TextField(
            controller: repsController,
            decoration: const InputDecoration(
              hintText: 'Reps',
            ),
          ),

          // sets
          TextField(
            controller: setsController,
            decoration: const InputDecoration(
              hintText: 'Sets',
            ),
          ),
        ],
      ),
      actions: [
        // save button
        MaterialButton(
          onPressed: save,
          child: const Text('Save'),
        ),

        // cancel button
        MaterialButton(
          onPressed: cancel,
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}


  // save workout
  void save() {
    // get exercise name from text controller
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;

    // add exercise to workout
    Provider.of<WorkoutData>(context, listen: false).addExercise(
      widget.workoutName,
      newExerciseName,
      weight,
      reps,
      sets,
    );

    // pop dialog box
    Navigator.pop(context);
  }

  void areYouSureToRemoveExercise(String workoutName, String exerciseName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Are you sure to remove this exercise?",
        ),
        actions: [
          // remove button
          MaterialButton(
            onPressed: () => remove(
                workoutName, exerciseName), // Fix: Provide a callback function
            child: const Text('remove'),
          ),

          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: const Text('cancel'),
          ),
        ],
      ),
    );
  }

  void remove(String workoutName, exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .removeExercise(workoutName, exerciseName);
    Navigator.pop(context);
  }

  // cancel
  void cancel() {
    // pop dialog box
    Navigator.pop(context);
    clear();
  }

  // clear controller
  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.workoutName),
          backgroundColor: Colors.green[600],
        ),
        backgroundColor: Colors.grey[800],
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green[600],
          onPressed: createNewExercise,
          child: const Icon(Icons.add_sharp),
        ),
        body: ListView.builder(
          itemCount: value.numberOfExercisesInWorkout(widget.workoutName),
          itemBuilder: (context, index) {
            final exercise =
                value.getRelevantWorkout(widget.workoutName).exercises[index];
            bool isChecked = exercise.isCompleted;

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              color: isChecked ? Colors.green[700] : const Color(0xFF2D2D2D),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: isChecked ? Colors.white : Colors.grey[300],
                      ),
                      onPressed: () {
                        areYouSureToRemoveExercise(
                            widget.workoutName, exercise.name);
                      },
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: isChecked ? Colors.green : Colors.grey[300],
                      ),
                      child: Text(
                        exercise.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isChecked ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildCircularContainer(
                      'Weight',
                      '${exercise.weight} kg',
                      isChecked,
                    ),
                    const SizedBox(width: 4),
                    _buildCircularContainer(
                      'Reps',
                      exercise.reps,
                      isChecked,
                    ),
                    const SizedBox(width: 4),
                    _buildCircularContainer(
                      'Sets',
                      exercise.sets,
                      isChecked,
                    ),
                  ],
                ),
                trailing: Checkbox(
                  value: isChecked,
                  onChanged: (val) =>
                      onCheckboxChanged(widget.workoutName, exercise.name),
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(
                      (states) => isChecked ? Colors.green : Colors.grey),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCircularContainer(
    String label,
    String value,
    bool isChecked,
  ) {
    Color containerColor =
        isChecked ? Colors.green : const Color.fromARGB(255, 84, 84, 84);
    Color textColor = Colors.white;

    return Container(
      width: 70,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: containerColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
