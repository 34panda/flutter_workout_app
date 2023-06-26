import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/components/exercise_tile.dart';

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
            ),

            // weight
            TextField(
              controller: weightController,
            ),

            // reps
            TextField(
              controller: repsController,
            ),

            // sets
            TextField(
              controller: setsController,
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
            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              color: Color(0xFF2D2D2D), // Dark gray color
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.white, // White color for delete button
                      onPressed: () {
                        // Remove the exercise here
                        areYouSureToRemoveExercise(
                            widget.workoutName, exercise.name);
                      },
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[
                            300], // Light gray color for exercise name container
                      ),
                      child: Text(
                        exercise.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16, // Exercise name font size
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    _buildCircularContainer(
                        'Weight',
                        exercise.weight + ' kg',
                        Color(
                            0xFF4F4F4F)), // Weight label with normal font size
                    SizedBox(width: 4),
                    _buildCircularContainer('Reps', exercise.reps,
                        Color(0xFF4F4F4F)), // Reps label with normal font size
                    SizedBox(width: 4),
                    _buildCircularContainer('Sets', exercise.sets,
                        Color(0xFF4F4F4F)), // Sets label with normal font size
                  ],
                ),
                trailing: Checkbox(
                  value: exercise.isCompleted,
                  onChanged: (val) =>
                      onCheckboxChanged(widget.workoutName, exercise.name),
                  activeColor:
                      Colors.green, // Set the active (checked) color to green
                  checkColor:
                      Colors.white, // Set the color of the check icon to white
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCircularContainer(
      String label, String value, Color containerColor) {
    return Container(
      width: 70,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: containerColor, // Use the provided container color
      ),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
