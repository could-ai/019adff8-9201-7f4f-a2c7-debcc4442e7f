import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/data_model.dart';
import 'entry_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Local state to store entries (simulating Sheet 1 rows)
  final List<SheetEntry> _entries = [];
  
  // Toggle to simulate Admin vs User role
  bool _isAdmin = false;

  void _addOrUpdateEntry(SheetEntry entry) {
    setState(() {
      final index = _entries.indexWhere((e) => e.id == entry.id);
      if (index != -1) {
        _entries[index] = entry;
      } else {
        _entries.add(entry);
      }
    });
  }

  void _deleteEntry(String id) {
    setState(() {
      _entries.removeWhere((e) => e.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sheet Data Manager'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Row(
            children: [
              const Text('Admin Mode'),
              Switch(
                value: _isAdmin,
                onChanged: (value) {
                  setState(() {
                    _isAdmin = value;
                  });
                },
              ),
            ],
          )
        ],
      ),
      body: _entries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.table_chart_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No entries found (Sheet 1 is empty)'),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EntryFormScreen(
                            isAdmin: _isAdmin,
                            onSave: _addOrUpdateEntry,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add First Entry'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 3}'), // Simulating Row number starting from 3
                    ),
                    title: Text(entry.category ?? 'No Category'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${DateFormat('yyyy-MM-dd').format(entry.date)}'),
                        if (entry.assignedEmail != null)
                          Text(
                            'Assigned: ${entry.assignedEmail}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EntryFormScreen(
                                  entry: entry,
                                  isAdmin: _isAdmin,
                                  onSave: _addOrUpdateEntry,
                                ),
                              ),
                            );
                          },
                        ),
                        if (_isAdmin)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteEntry(entry.id),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EntryFormScreen(
                isAdmin: _isAdmin,
                onSave: _addOrUpdateEntry,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
