class Exercise{
  String name;
  String weight;
  String reps;
  String sets;
  bool isCompleted;

  Exercise({
    required this.name,
    required this.weight,
    required this.reps,
    required this.sets,
    this.isCompleted = false,
    });
}