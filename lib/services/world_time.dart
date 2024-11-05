import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location; // location name for the UI
  String time; // the time in that location
  String flag; // url to an asset flag icon
  String url; // location url for API endpoint
  bool isDaytime; // true or false if daytime or not

  // Constructor
  WorldTime({
    required this.location,
    required this.flag,
    required this.url,
  })  : time = '',
        isDaytime = true;

  Future<void> getTime() async {
    try {
      // Make the request
      http.Response response = await http.get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));

      if (response.statusCode == 200) {
        // Parse the JSON data
        Map data = jsonDecode(response.body);

        // Get properties from the data
        String dateTime = data['datetime'];
        String utcOffset = data['utc_offset'];

        // Create DateTime object
        DateTime now = DateTime.parse(dateTime);
        int offsetHours = int.parse(utcOffset.substring(1, 3));
        int offsetMinutes = int.parse(utcOffset.substring(4, 6));

        now = now.add(Duration(
          hours: offsetHours,
          minutes: offsetMinutes,
        ));

        // Set the time property
        isDaytime = now.hour > 6 && now.hour < 20 ? true : false;
        time = DateFormat.jm().format(now);
      } else {
        throw 'Could not get time data';
      }
    } catch (e) {
      print('Caught the error: $e');
      time = "Failed to get time data";
      isDaytime = false; // default to false on error
    }
  }
}