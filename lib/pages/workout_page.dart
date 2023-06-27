import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/workout_data.dart';
import '../models/exercise.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({Key? key, required this.workoutName}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  // Checkbox was tapped
  void onCheckboxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  // Text controllers
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  // Create a new exercise
  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add a new exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Exercise name
            TextField(
              controller: exerciseNameController,
              decoration: const InputDecoration(
                hintText: 'Exercise Name',
              ),
            ),

            // Weight
            TextField(
              controller: weightController,
              decoration: const InputDecoration(
                hintText: 'Weight',
              ),
            ),

            // Reps
            TextField(
              controller: repsController,
              decoration: const InputDecoration(
                hintText: 'Reps',
              ),
            ),

            // Sets
            TextField(
              controller: setsController,
              decoration: const InputDecoration(
                hintText: 'Sets',
              ),
            ),
          ],
        ),
        actions: [
          // Save button
          MaterialButton(
            onPressed: save,
            child: const Text('Save'),
          ),

          // Cancel button
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Edit exercise info
  void editExerciseInfo(String workoutName, String exerciseName) {
    Exercise exercise = Provider.of<WorkoutData>(context, listen: false)
        .getRelevantExercise(workoutName, exerciseName);

    exerciseNameController.text = exercise.name;
    weightController.text = exercise.weight;
    repsController.text = exercise.reps;
    setsController.text = exercise.sets;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Input changes:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Exercise name
            TextField(
              controller: exerciseNameController,
              decoration: const InputDecoration(
                hintText: 'Exercise Name',
              ),
            ),

            // Weight
            TextField(
              controller: weightController,
              decoration: const InputDecoration(
                hintText: 'Weight',
              ),
            ),

            // Reps
            TextField(
              controller: repsController,
              decoration: const InputDecoration(
                hintText: 'Reps',
              ),
            ),

            // Sets
            TextField(
              controller: setsController,
              decoration: const InputDecoration(
                hintText: 'Sets',
              ),
            ),
          ],
        ),
        actions: [
          // Save button
          MaterialButton(
            onPressed: () => change(
              workoutName,
              exerciseName,
              exerciseNameController.text,
              weightController.text,
              repsController.text,
              setsController.text,
            ),
            child: const Text('Save'),
          ),

          // Cancel button
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Save workout
  void save() {
    // Get exercise details from text controllers
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;

    // Add exercise to workout
    Provider.of<WorkoutData>(context, listen: false).addExercise(
      widget.workoutName,
      newExerciseName,
      weight,
      reps,
      sets,
    );

    // Pop dialog box
    Navigator.pop(context);
    clear();
  }

  // Change exercise info
  void change(
    String workoutName,
    String exerciseName,
    String newExerciseName,
    String newWeight,
    String newReps,
    String newSets,
  ) {
    // Update exercise info in workout
    Provider.of<WorkoutData>(context, listen: false).changeExerciseInfo(
      workoutName,
      exerciseName,
      newExerciseName,
      newWeight,
      newReps,
      newSets,
    );

    // Pop dialog box
    Navigator.pop(context);
    clear();
  }

  // Prompt for exercise removal confirmation
  void areYouSureToRemoveExercise(String workoutName, String exerciseName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure you want to remove this exercise?"),
        actions: [
          // Remove button
          MaterialButton(
            onPressed: () => remove(workoutName, exerciseName),
            child: const Text('Remove'),
          ),

          // Cancel button
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Remove exercise
  void remove(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .removeExercise(workoutName, exerciseName);
    Navigator.pop(context);
  }

  // Cancel action
  void cancel() {
    // Pop dialog box
    Navigator.pop(context);
    clear();
  }

  // Clear text controllers
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises
                    .map((exercise) {
                  bool isChecked = exercise.isCompleted;
                  return Card(
                    elevation: 2,
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
                              areYouSureToRemoveExercise(widget.workoutName, exercise.name);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.border_color,
                              color: isChecked ? Colors.white : Colors.grey[300],
                            ),
                            onPressed: () {
                              editExerciseInfo(widget.workoutName, exercise.name);
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
                          (states) => isChecked ? Colors.green : Colors.grey,
                        ),
                      ),
                    ),
                  );
                }).toList(),
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