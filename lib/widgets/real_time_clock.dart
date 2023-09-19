import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RealTimeClock extends StatefulWidget {
  const RealTimeClock({super.key});
  @override
  _RealTimeClockState createState() => _RealTimeClockState();
}

class _RealTimeClockState extends State<RealTimeClock> {

  late Stream<String> _timeStream;

  @override
  void initState() {
    super.initState();
    _timeStream = _createTimeStream();
  }

  @override
  void dispose() {
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _timeStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final time = snapshot.data;
          return Text(
            '$time',
            style: const TextStyle(fontSize: 14),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Stream<String> _createTimeStream() {
    return Stream.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      return DateFormat('HH:mm:ss').format(now);
    });
  }


}