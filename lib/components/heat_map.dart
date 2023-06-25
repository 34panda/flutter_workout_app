import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:workout_app/datetime/date_time.dart';

class MyHeatMap extends StatelessWidget{
  const MyHeatMap({
    super.key,
    required this.datasets,
    required this.startDateDDMMYYYY,
    });

  final Map<DateTime, int>? datasets;
  final String startDateDDMMYYYY;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      child: HeatMap(
        startDate: createDateTimeObject(startDateDDMMYYYY),
        endDate: DateTime.now().add(const Duration(days: 0)),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Colors.grey[200],
        textColor: Colors.white,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: const {
          1: Colors.green, // strenght of green
        },
      ),
    );
  }
}