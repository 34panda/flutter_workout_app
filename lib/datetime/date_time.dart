// return todays date as ddmmyyyy
String todaysDateDDMMYYYY() {
  // today
  var dateTimeObject = DateTime.now();

  // day in the format dd
  String day = dateTimeObject.day.toString();
  if (day.length == 1){
    day = '0$day';
  }

  // month in the format mm
  String month = dateTimeObject.month.toString();
    if (month.length == 1){
    month = '0$month';
  }

  // year in the format yy
  String year = dateTimeObject.year.toString();

  // final format
  String ddmmyyyy = day + month + year;

  return ddmmyyyy;
}

// convert string ddmmyyyy into a DateTime object
DateTime createDateTimeObject(String ddmmyyyy) {
  int dd = int.parse(ddmmyyyy.substring(0, 2));
  int mm = int.parse(ddmmyyyy.substring(2, 4));
  int yyyy = int.parse(ddmmyyyy.substring(4, 8));

  DateTime dateTimeObject = DateTime(dd, mm, yyyy);
  return dateTimeObject;
}

// convert DateTime object into a string ddmmyyyy
String convertDateTimeToDDMMYYYY(DateTime dateTime) {
  // day in the format dd
  String day = dateTime.day.toString();
   if (day.length == 1){
    day = '0$day';
  }

  // month in the format mm
  String month = dateTime.month.toString();
   if (month.length == 1){
    month = '0$day';
  }

  // year in the format yyy
  String year = dateTime.year.toString();
  
  // final format
  String ddmmyyyy = day + month + year;

  return ddmmyyyy;
}