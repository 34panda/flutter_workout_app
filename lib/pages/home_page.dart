import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/data/workout_data.dart';

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

    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  // text controller
  final newWorkoutNameController = TextEditingController();

  // create a new workout
  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create new workout"),
        content: TextField(
          controller: newWorkoutNameController,
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: save,
            child: const Text('save'),
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

 void areYouSureToRemove(String workoutName) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Are you sure to remove workout?"),
      actions: [
        // remove button
        MaterialButton(
          onPressed: () => remove(workoutName), // Fix: Provide a callback function
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


  // go to workout page
  void goToWorkoutPage(String workoutName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPage(
          workoutName: workoutName,
        ),
      ),
    );
  }

  // remove workout
  void remove(String workoutName) {
     Provider.of<WorkoutData>(context, listen: false).removeWorkout(workoutName);
     Navigator.pop(context);
  }

  // save workout
  void save() {
    // get workout name from text controller
    String newWorkoutName = newWorkoutNameController.text;
    // add workout to workdata list
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

    //pop dialog box
    Navigator.pop(context);
  }

  // cancel
  void cancel() {
    //pop dialog box
    Navigator.pop(context);
    clear();
  }

  // clear controller
  void clear() {
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[700],
        appBar: AppBar(
          title: const Text("Workout tracker"),
          backgroundColor: Colors.green[600],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.getWorkoutlist().length,
          itemBuilder: (context, index) => ListTile(
            textColor: Colors.grey[300],
            title: Text(value.getWorkoutlist()[index].name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.grey[300],),
                  onPressed: () => areYouSureToRemove(value.getWorkoutlist()[index].name)// Call removeWorkout method
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: Colors.grey[300],),
                  onPressed: () =>
                      goToWorkoutPage(value.getWorkoutlist()[index].name),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
