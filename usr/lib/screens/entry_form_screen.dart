import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/data_model.dart';

class EntryFormScreen extends StatefulWidget {
  final SheetEntry? entry;
  final bool isAdmin;
  final Function(SheetEntry) onSave;

  const EntryFormScreen({
    super.key,
    this.entry,
    required this.isAdmin,
    required this.onSave,
  });

  @override
  State<EntryFormScreen> createState() => _EntryFormScreenState();
}

class _EntryFormScreenState extends State<EntryFormScreen> {
  late DateTime _selectedDate;
  String? _selectedCategory;
  String? _selectedEmail;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize with existing data or defaults
    // Sheet 1 Column A: Valid date initially as today
    _selectedDate = widget.entry?.date ?? DateTime.now();
    _selectedCategory = widget.entry?.category;
    _selectedEmail = widget.entry?.assignedEmail;
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final newEntry = SheetEntry(
        id: widget.entry?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        date: _selectedDate,
        category: _selectedCategory,
        assignedEmail: _selectedEmail,
      );
      widget.onSave(newEntry);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'New Entry' : 'Edit Entry'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Section: Date (Sheet 1 Column A)
              Card(
                child: ListTile(
                  title: const Text('Date (Column A)'),
                  subtitle: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _pickDate(context),
                ),
              ),
              const SizedBox(height: 16),

              // Section: Category (Sheet 1 Column I)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'User Category (Column I)',
                  border: OutlineInputBorder(),
                  helperText: 'Select from Sheet 2 O2:O10',
                ),
                value: _selectedCategory,
                items: ReferenceData.categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),

              // Section: Admin Assignment (Email from Sheet 2 G2:G10)
              if (widget.isAdmin) ...[
                const Divider(),
                const Text(
                  'Admin Area',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Assign Email (Sheet 2 G2:G10)',
                    border: OutlineInputBorder(),
                    helperText: 'Admin privilege only',
                  ),
                  value: _selectedEmail,
                  items: ReferenceData.availableEmails.map((String email) {
                    return DropdownMenuItem<String>(
                      value: email,
                      child: Text(email),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedEmail = newValue;
                    });
                  },
                ),
              ] else if (_selectedEmail != null) ...[
                // Read-only view for non-admins if email is already assigned
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Assigned Email',
                    border: OutlineInputBorder(),
                    enabled: false,
                  ),
                  child: Text(_selectedEmail!),
                ),
              ],

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
