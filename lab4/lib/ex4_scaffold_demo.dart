import 'package:flutter/material.dart';

class Ex4ScaffoldDemo extends StatefulWidget {
  const Ex4ScaffoldDemo({super.key});

  @override
  State<Ex4ScaffoldDemo> createState() => ScaffoldThemeDemoState();
}

class ScaffoldThemeDemoState extends State<Ex4ScaffoldDemo> {

  bool isDarkMode = false;

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Theme(

      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,

          brightness: isDarkMode
              ? Brightness.dark
              : Brightness.light,
        ),

        useMaterial3: true,
      ),

      child: Builder(
        builder: (context) {
          return Scaffold(

            // App bar
            appBar: AppBar(
              title: const Text(
                'Exercise 4 - Scaffold & Theme',
              ),

              actions: [
                Switch(
                  value: isDarkMode,

                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                  },
                ),
              ],
            ),

            // Body
            body: Center(
              child: Card(
                margin: const EdgeInsets.all(24),

                child: Padding(
                  padding: const EdgeInsets.all(24),

                  child: Column(
                    mainAxisSize:
                    MainAxisSize.min,

                    children: [
                      Icon(
                        isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,

                        size: 64,
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      Text(
                        isDarkMode
                            ? 'Dark Mode'
                            : 'Light Mode',

                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall,
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Text(
                        'Pressed $counter times',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Floating action button
            floatingActionButton:
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  counter++;
                });
              },

              child: const Icon(
                Icons.add,
              ),
            ),
          );
        },
      ),
    );
  }
}