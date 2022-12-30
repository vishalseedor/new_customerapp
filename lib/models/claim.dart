 import 'package:flutter/cupertino.dart';
class ClaimModel with ChangeNotifier {
  final String id;
  final String subject;
  final String claimType;
  final String date;
  final String deadlineDate;
  final String description;
  final String modelrefer;
  final String priority;
  final String resolution;


  ClaimModel({
    @required this.id,
    @required this.subject,
    @required this.claimType,
    @required this.date,
    @required this.deadlineDate,
    @required this.description,
    @required this.modelrefer,
    @required this.priority,
    @required this.resolution,
    
  });
}
