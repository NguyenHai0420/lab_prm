import 'dart:math';
import 'package:flutter/material.dart';
import '../models/student_record.dart';
import '../services/storage_service_9_3.dart';

class Lab93CrudScreen extends StatefulWidget {
  const Lab93CrudScreen({super.key});

  @override
  State<Lab93CrudScreen> createState() => _Lab93CrudScreenState();
}

class _Lab93CrudScreenState extends State<Lab93CrudScreen> {
  final StorageService93 _storageService = StorageService93();
  final TextEditingController _searchController = TextEditingController();

  List<StudentRecord> _allStudents = [];
  List<StudentRecord> _filteredStudents = [];
  bool _isLoading = true;
  String _storagePath = '';

  final List<String> _majors = [
    'Software Engineering',
    'Artificial Intelligence',
    'Information Assurance',
    'Data Science',
    'Digital Art & Design',
  ];

  @override
  void initState() {
    super.initState();
    _loadDatabase();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDatabase() async {
    setState(() => _isLoading = true);
    final path = await _storageService.getFilePath();
    final students = await _storageService.loadStudents();
    setState(() {
      _storagePath = path;
      _allStudents = students;
      _isLoading = false;
      _filterStudents();
    });
  }

  void _onSearchChanged() {
    _filterStudents();
  }

  void _filterStudents() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredStudents = List.from(_allStudents);
      } else {
        _filteredStudents = _allStudents.where((student) {
          return student.fullName.toLowerCase().contains(query) ||
              student.studentId.toLowerCase().contains(query) ||
              student.email.toLowerCase().contains(query) ||
              student.major.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  // Crud actions with auto-save

  int _generateNextId() {
    if (_allStudents.isEmpty) return 1;
    return _allStudents.map((s) => s.id).reduce(max) + 1;
  }

  Future<void> _addStudent(StudentRecord student) async {
    setState(() {
      _allStudents.add(student);
      _filterStudents();
    });

    // Auto-save JSON after addition
    await _storageService.saveStudents(_allStudents);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added "${student.fullName}" and auto-saved to JSON database!'),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _updateStudent(StudentRecord updatedStudent) async {
    final index = _allStudents.indexWhere((s) => s.id == updatedStudent.id);
    if (index != -1) {
      setState(() {
        _allStudents[index] = updatedStudent;
        _filterStudents();
      });

      // Auto-save JSON after update
      await _storageService.saveStudents(_allStudents);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Updated "${updatedStudent.fullName}" and auto-saved!'),
            backgroundColor: Colors.blue.shade700,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _deleteStudent(StudentRecord student) async {
    // Confirmation dialog before delete
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Confirm Deletion'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${student.fullName}" (${student.studentId}) from the local JSON database?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _allStudents.removeWhere((s) => s.id == student.id);
        _filterStudents();
      });

      // Auto-save JSON after deletion
      await _storageService.saveStudents(_allStudents);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted "${student.fullName}" and updated database file.'),
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // Dialogs for add anh edit

  void _showStudentFormDialog({StudentRecord? studentToEdit}) {
    final isEditing = studentToEdit != null;
    final idController = TextEditingController(text: studentToEdit?.studentId ?? '');
    final nameController = TextEditingController(text: studentToEdit?.fullName ?? '');
    final emailController = TextEditingController(text: studentToEdit?.email ?? '');
    final gpaController = TextEditingController(text: studentToEdit?.gpa.toString() ?? '3.5');
    String selectedMajor = studentToEdit?.major ?? _majors.first;

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(isEditing ? 'Edit Student Record' : 'Add New Student'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: idController,
                        decoration: const InputDecoration(
                          labelText: 'Student ID',
                          hintText: 'e.g. SE170123',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        validator: (val) =>
                            (val == null || val.trim().isEmpty) ? 'Please enter student ID' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'e.g. Le Van Cuong',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (val) =>
                            (val == null || val.trim().isEmpty) ? 'Please enter full name' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          hintText: 'e.g. cuonglv@fpt.edu.vn',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter email';
                          }
                          if (!val.contains('@')) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: selectedMajor,
                        decoration: const InputDecoration(
                          labelText: 'Major',
                          prefixIcon: Icon(Icons.school_outlined),
                        ),
                        items: _majors.map((major) {
                          return DropdownMenuItem(value: major, child: Text(major));
                        }).toList(),
                        onChanged: (newMajor) {
                          if (newMajor != null) {
                            setDialogState(() => selectedMajor = newMajor);
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: gpaController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'GPA (0.0 - 4.0)',
                          hintText: '3.50',
                          prefixIcon: Icon(Icons.grade_outlined),
                        ),
                        validator: (val) {
                          final parsed = double.tryParse(val ?? '');
                          if (parsed == null || parsed < 0.0 || parsed > 4.0) {
                            return 'Enter GPA between 0.0 and 4.0';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final newRecord = StudentRecord(
                        id: isEditing ? studentToEdit.id : _generateNextId(),
                        studentId: idController.text.trim().toUpperCase(),
                        fullName: nameController.text.trim(),
                        email: emailController.text.trim(),
                        major: selectedMajor,
                        gpa: double.parse(gpaController.text.trim()),
                      );

                      Navigator.pop(ctx);
                      if (isEditing) {
                        _updateStudent(newRecord);
                      } else {
                        _addStudent(newRecord);
                      }
                    }
                  },
                  child: Text(isEditing ? 'Save Changes' : 'Add Student'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // View Raw JSON Dialog
  Future<void> _showRawJsonDialog() async {
    final rawJson = await _storageService.getRawJson();
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.data_object, color: Colors.indigo),
            SizedBox(width: 8),
            Text('Raw JSON Database Content'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                rawJson,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.greenAccent,
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getGpaColor(double gpa) {
    if (gpa >= 3.6) return Colors.green.shade700;
    if (gpa >= 3.2) return Colors.blue.shade700;
    if (gpa >= 2.5) return Colors.orange.shade700;
    return Colors.red.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadDatabase,
        child: Column(
          children: [
            // Top Mini-Database Header Card
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.indigo.shade50,
                    Colors.deepPurple.shade50,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.indigo.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.indigo.shade700,
                        foregroundColor: Colors.white,
                        radius: 20,
                        child: const Icon(Icons.storage_rounded, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Lab 9.3: JSON CRUD Mini Database',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Auto-saving CRUD operations to students_database.json',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.data_object, color: Colors.indigo),
                        tooltip: 'View Raw JSON in Storage',
                        onPressed: _showRawJsonDialog,
                      ),
                    ],
                  ),
                  if (_storagePath.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Storage: $_storagePath',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10.5,
                        color: Colors.blueGrey.shade700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name, ID, major, or email...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Result Counter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Showing ${_filteredStudents.length} of ${_allStudents.length} student(s)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final reset = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Reset Sample Data?'),
                          content: const Text(
                            'This will restore the initial sample students in students_database.json.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Reset', style: TextStyle(color: Colors.indigo)),
                            ),
                          ],
                        ),
                      );
                      if (reset == true) {
                        final seed = await _storageService.resetDatabase();
                        setState(() {
                          _allStudents = seed;
                          _filterStudents();
                        });
                      }
                    },
                    child: Text(
                      'Reset Samples',
                      style: TextStyle(fontSize: 12, color: Colors.indigo.shade700),
                    ),
                  ),
                ],
              ),
            ),

            // List of Students
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredStudents.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 54, color: Colors.grey.shade400),
                              const SizedBox(height: 12),
                              Text(
                                _searchController.text.isEmpty
                                    ? 'No students in database yet.'
                                    : 'No students matched "${_searchController.text}".',
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                onPressed: () => _showStudentFormDialog(),
                                icon: const Icon(Icons.add),
                                label: const Text('Add Student'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          itemCount: _filteredStudents.length,
                          itemBuilder: (context, index) {
                            final student = _filteredStudents[index];
                            final initials = student.fullName.isNotEmpty
                                ? student.fullName.trim().split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join()
                                : 'S';

                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    // Avatar
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: theme.colorScheme.primaryContainer,
                                      child: Text(
                                        initials,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  student.fullName,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  student.studentId,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            student.email,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Text(
                                                student.major,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.blueGrey.shade700,
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _getGpaColor(student.gpa).withValues(alpha: 0.12),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      size: 14,
                                                      color: _getGpaColor(student.gpa),
                                                    ),
                                                    const SizedBox(width: 2),
                                                    Text(
                                                      'GPA: ${student.gpa.toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.bold,
                                                        color: _getGpaColor(student.gpa),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    // Actions
                                    Column(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                                          tooltip: 'Edit Student',
                                          visualDensity: VisualDensity.compact,
                                          onPressed: () => _showStudentFormDialog(studentToEdit: student),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                          tooltip: 'Delete Student',
                                          visualDensity: VisualDensity.compact,
                                          onPressed: () => _deleteStudent(student),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showStudentFormDialog(),
        icon: const Icon(Icons.person_add),
        label: const Text('Add Student'),
      ),
    );
  }
}
