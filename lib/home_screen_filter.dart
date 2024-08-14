import 'package:flutter/material.dart';

class HomeScreenFilter extends StatelessWidget {
  const HomeScreenFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(
            width: 30,
          ),
          FilterChip(label: const Text("Action"), onSelected: (selected) {}),
          const SizedBox(
            width: 10,
          ),
          FilterChip(label: const Text("Adventure"), onSelected: (selected) {}),
          const SizedBox(
            width: 10,
          ),
          FilterChip(label: const Text("Sci-Fi"), onSelected: (selected) {}),
          const SizedBox(
            width: 10,
          ),
          FilterChip(label: const Text("Comedy"), onSelected: (selected) {}),
          const SizedBox(
            width: 10,
          ),
          FilterChip(label: const Text("Crime"), onSelected: (selected) {}),
          const SizedBox(
            width: 10,
          ),
          FilterChip(label: const Text("Testing"), onSelected: (selected) {}),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
