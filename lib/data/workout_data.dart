import 'package:flutter/material.dart';
import 'package:workout_app/models/exercise.dart';

import '../models/workout.dart';
import 'hive_database.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();

  /*

  -This overall list contains the different workouts.
  -Each workout has a name, and list of exercises.

  */

  List<Workout> workoutList = [
    // default workout
    Workout(name: "Push", exercises: [
      Exercise(
        name: "Bench Press", 
        weight: "50", 
        reps: "12", 
        sets: "4"
        )
      ]
    ),
    Workout(name: "Pull", exercises: [
      Exercise(
        name: "Pull Up", 
        weight: "0", 
        reps: "4", 
        sets: "4"
        )
      ]
    )
  ];

  // if there are workouts already in database, then get the workout list, otherwise use default workouts
  void initializeWorkoutList() {
    if (db.previousDateExists()) {
      workoutList = db.readFromDatabase();
    } else {
      db.saveToDatabase(workoutList);
    }
  }

  // get list of workouts
  List<Workout> getWorkoutlist() {
    return workoutList;
  }

  // get length of a given workout
  int numberOfExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }
  
  // add workout
  void addWorkout(String name) {
    // add a new workout with a blank list of exercises
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();
  }

  // add an exercise to a workout
  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    // find the relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
      Exercise(
        name: exerciseName, 
        weight: weight, 
        reps: reps, 
        sets: sets,
      ),
    );
    
    notifyListeners();
  }

  // check off exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    // find relevant workout and relevant exercise in that workout
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    // check off boolean to show user compled the exercise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    
    notifyListeners();
  }

  // return a relevant workout object, given a workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);

    return relevantWorkout;
  }

  // return a relevant exercise object, given a workout name + exercise name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    // find the relevant workout first
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    
    // then find the relevant exercise in that workout
    Exercise relevantExercise = relevantWorkout.exercises
    .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }

}
