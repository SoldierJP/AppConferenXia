import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;

  const SearchBar({
    super.key,
    this.hintText = 'Buscar eventos...',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.purple),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 12,
          ),
        ),
      ),
    );
  }
}