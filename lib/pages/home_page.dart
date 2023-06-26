import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/data/workout_data.dart';

import 'workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newWorkoutNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create new workout"),
        content: TextField(
          controller: newWorkoutNameController,
          decoration: const InputDecoration(
            hintText: 'Workout name',
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: const Text('save'),
          ),
          MaterialButton(
            onPressed: cancel,
            child: const Text('cancel'),
          ),
        ],
      ),
    );
  }

  // Edit workout name dialog
  void editWorkoutName(String workoutName) {
    newWorkoutNameController.text = workoutName; // Set the previous name as the default input
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New workout name:"),
        content: TextField(
          controller: newWorkoutNameController,
          decoration: const InputDecoration(
            hintText: 'Workout name',
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () => change(workoutName),
            child: const Text('save'),
          ),
          MaterialButton(
            onPressed: cancel,
            child: const Text('cancel'),
          ),
        ],
      ),
    );
  }

  // Confirm workout removal dialog
  void areYouSureToRemove(String workoutName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure to remove workout?"),
        actions: [
        // remove button
          MaterialButton(
            onPressed: () => remove(workoutName),
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
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);
    Navigator.pop(context);
  }

  // Change workout name
  void change(String workoutName) {
    String newWorkoutName = newWorkoutNameController.text;
    Provider.of<WorkoutData>(context, listen: false).changeWorkoutName(
      workoutName,
      newWorkoutName,
    );
    Navigator.pop(context);
  }

  // cancel
  void cancel() {
    //pop dialog box
    Navigator.pop(context);
    clear();
  }

  // Clear text field
  void clear() {
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[800],
        appBar: AppBar(
          title: const Text("Workout tracker"),
          backgroundColor: Colors.green[600],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green[600],
          onPressed: createNewWorkout,
          child: const Icon(Icons.add_sharp),
        ),
        body: Container(
          color: Colors.grey[700],
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: value.getWorkoutlist().length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                color: Colors.grey[800],
                child: ListTile(
                  title: Text(
                    value.getWorkoutlist()[index].name,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontWeight: FontWeight.bold, // Set font weight to bold
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 24.0),
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.grey[400]),
                          onPressed: () => areYouSureToRemove(
                            value.getWorkoutlist()[index].name,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 24.0),
                        child: IconButton(
                          icon: Icon(Icons.border_color, color: Colors.grey[400]),
                          onPressed: () => editWorkoutName(
                            value.getWorkoutlist()[index].name,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
                        onPressed: () => goToWorkoutPage(
                          value.getWorkoutlist()[index].name,
                        ),
                      ),
                    ],
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
