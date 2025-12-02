import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Mock Data from "Sheet 2"
class ReferenceData {
  // Sheet 2 O2:O10 - User Categories
  static const List<String> categories = [
    'Management',
    'Sales Team',
    'IT Support',
    'Human Resources',
    'Finance Dept',
    'Operations',
    'Marketing',
    'Legal Team',
    'External Consultant',
  ];

  // Sheet 2 G2:G10 - Available Emails for assignment
  static const List<String> availableEmails = [
    'director@company.com',
    'sales.lead@company.com',
    'tech.support@company.com',
    'hr.manager@company.com',
    'accounts@company.com',
    'ops.lead@company.com',
    'marketing@company.com',
    'legal@company.com',
    'consultant@external.com',
  ];
}

class SheetEntry {
  String id;
  DateTime date; // Sheet 1 Column A
  String? category; // Sheet 1 Column I
  String? assignedEmail; // Assigned from Sheet 2 G2:G10

  SheetEntry({
    required this.id,
    required this.date,
    this.category,
    this.assignedEmail,
  });
}
