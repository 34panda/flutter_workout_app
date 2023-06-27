import 'package:flutter/material.dart';
import 'package:workout_app/datetime/date_time.dart';
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
      Exercise(name: "Bench Press", weight: "50", reps: "12", sets: "4"),
      Exercise(name: "Military Press", weight: "30", reps: "12", sets: "4"),
      Exercise(name: "Chest Flys", weight: "55", reps: "8", sets: "4"),
      Exercise(name: "Dips", weight: "0", reps: "6", sets: "3"),
    ]),
    Workout(name: "Pull", exercises: [
      Exercise(name: "Pull Up", weight: "0", reps: "4", sets: "4"),
      Exercise(name: "Chin Up", weight: "0", reps: "8", sets: "3"),
      Exercise(name: "Cable Row", weight: "45", reps: "12", sets: "4"),
      Exercise(name: "Biceps Curls", weight: "25", reps: "10", sets: "3"),
    ]),
    Workout(name: "Legs", exercises: [
      Exercise(name: "Bulgarian Squats", weight: "12", reps: "6", sets: "4"),
      Exercise(name: "Split Squats", weight: "30", reps: "8", sets: "4"),
      Exercise(name: "Abduction", weight: "70", reps: "12", sets: "3"),
      Exercise(name: "Adduction", weight: "70", reps: "12", sets: "3"),
    ]),
  ];

  // if there are workouts already in database, then get the workout list, otherwise use default workouts
  void initializeWorkoutList() {
    if (db.previousDateExists()) {
      workoutList = db.readFromDatabase();
    } else {
      db.saveToDatabase(workoutList);
    }

    // load the heat map
    loadHeatMap();
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

    // save to database
    db.saveToDatabase(workoutList);
  }

  // remove workout *************************************************************
  void removeWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    workoutList.remove(relevantWorkout);

    notifyListeners();

    // save to database
    db.saveToDatabase(workoutList);
  }

  // change workout name
  void changeWorkoutName(String workoutName, String newWorkoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.name = newWorkoutName;

    notifyListeners();

    // save to database
    db.saveToDatabase(workoutList);
  }

  // change exercise info
  void changeExerciseInfo(
      String workoutName,
      String exerciseName,
      String newExerciseName,
      String newWeight,
      String newReps,
      String newSets) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    Exercise relevantExercise =
        getRelevantExercise(relevantWorkout.name, exerciseName);

    relevantExercise.name = newExerciseName;
    relevantExercise.weight = newWeight;
    relevantExercise.reps = newReps;
    relevantExercise.sets = newSets;

    notifyListeners();

    // save to database
    db.saveToDatabase(workoutList);
  }

  // remove an exercise from a workout : maybe put relevant workout instead of workout name into get relevant exercise
  void removeExercise(String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    Exercise relevantExercise =
        getRelevantExercise(relevantWorkout.name, exerciseName);
    relevantWorkout.exercises.remove(relevantExercise);

    notifyListeners();

    // save to database
    db.saveToDatabase(workoutList);
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

    // save to database
    db.saveToDatabase(workoutList);
  }

  // check off exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    // find relevant workout and relevant exercise in that workout
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    // check off boolean to show user compled the exercise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    print('tapped');

    notifyListeners();

    // save to database
    db.saveToDatabase(workoutList);

    // load the heat map
    loadHeatMap();
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

  // get start date
  String getStartDate() {
    return db.getStartDate();
  }

  /*

  HEAT MAP

  */

  Map<DateTime, int> heatMapDataSet = {};

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());

    // count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    // go from start date to today, and each completion ststus to the dataset
    //"COMPLETION_STATUS_ddmmyyyy" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String ddmmyyyy =
          convertDateTimeToDDMMYYYY(startDate.add(Duration(days: i)));
      // completion ststus = 0 or 1
      int completionStatus = db.getCompletionStatus(ddmmyyyy);

      // year
      int year = startDate.add(Duration(days: i)).year;

      // month
      int month = startDate.add(Duration(days: i)).month;

      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(day, month, year): completionStatus
      };

      // add to the heat map dataset
      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}
