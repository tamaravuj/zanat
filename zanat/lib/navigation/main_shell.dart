import 'package:flutter/material.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  // Zamenjujemo placeholdere pravim ekranima u narednim commitovima.
  final List<Widget> _pages = const [
    _Placeholder('Početna'),
    _Placeholder('Pretraga'),
    _Placeholder('Moji termini'),
    _Placeholder('Omiljeno'),
    _Placeholder('Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Početna',
          ),
          NavigationDestination(icon: Icon(Icons.search), label: 'Pretraga'),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Termini',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Omiljeno',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String title;
  const _Placeholder(this.title);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text(title)),
  );
}
