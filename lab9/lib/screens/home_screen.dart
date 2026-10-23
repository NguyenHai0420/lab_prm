import 'package:flutter/material.dart';
import 'lab9_1_assets_screen.dart';
import 'lab9_2_storage_screen.dart';
import 'lab9_3_crud_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    Lab91AssetsScreen(),
    Lab92StorageScreen(),
    Lab93CrudScreen(),
  ];

  final List<String> _titles = const [
    'Lab 9.1: Assets JSON',
    'Lab 9.2: Local Storage',
    'Lab 9.3: Mini Database CRUD',
  ];

  void _showLabInfo() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.indigo),
            SizedBox(width: 8),
            Text('PRM393 - Lab 9'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Working With Local JSON Storage',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                '1. Lab 9.1: Read JSON From Assets\n'
                '• Uses rootBundle.loadString() to load assets/data/products.json\n'
                '• Decodes JSON into List<Product> and renders via ListView\n\n'
                '2. Lab 9.2: Save & Load Device Storage\n'
                '• Uses path_provider (getApplicationDocumentsDirectory)\n'
                '• Reads & writes notes_storage.json with local persistence across restarts\n\n'
                '3. Lab 9.3: JSON CRUD Mini Database\n'
                '• Local mini-database in students_database.json\n'
                '• Search/filter, Add with unique ID, Edit, and Delete\n'
                '• Auto-save after every change and Raw JSON inspection',
                style: TextStyle(fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _titles[_currentIndex],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Text(
              'Flutter + Local File Persistence',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Lab Overview & Objectives',
            onPressed: _showLabInfo,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.folder_open_outlined),
            selectedIcon: Icon(Icons.folder),
            label: '9.1 Assets',
          ),
          NavigationDestination(
            icon: Icon(Icons.save_outlined),
            selectedIcon: Icon(Icons.save),
            label: '9.2 Storage',
          ),
          NavigationDestination(
            icon: Icon(Icons.storage_outlined),
            selectedIcon: Icon(Icons.storage),
            label: '9.3 CRUD DB',
          ),
        ],
      ),
    );
  }
}
