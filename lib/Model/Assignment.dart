import 'package:flutter/material.dart';

class Assignment extends StatefulWidget {

  final assignmentID;
  final studentNo;
  final projectID;
  final staffNo;

  const Assignment({Key key, this.assignmentID, this.studentNo, this.projectID, this.staffNo}) : super(key: key);

  _AssignmentState createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

