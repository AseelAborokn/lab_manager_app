///@nodoc
import 'package:flutter/material.dart';
import 'package:lab_manager/models/lab_user.dart';
import 'package:lab_manager/shared/widgets/activity_logs.dart';

class MyActivityLogs extends StatefulWidget {
  const MyActivityLogs({
    Key? key,
    required this.labUser
  }) : super(key: key);

  final LabUser labUser;
  @override
  State<MyActivityLogs> createState() => _MyActivityLogsState();
}

class _MyActivityLogsState extends State<MyActivityLogs> {
  @override
  Widget build(BuildContext context) {
    return ActivityLogs(labUser: widget.labUser, title: "My Activities" ,showMyUsagesOnly: true);
  }
}
