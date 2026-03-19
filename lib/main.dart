import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

// 1. Define the Native bindings
// The 'asset' name here must match what you put in hook/build.dart
@Native<Pointer<Utf8> Function()>(
  symbol: 'generate_ulid_string',
  assetId: 'package:flutter_rust/flutter_rust',
)
external Pointer<Utf8> _generate();

@Native<Void Function(Pointer<Utf8>)>(
  symbol: 'free_ulid_string',
  assetId: 'package:flutter_rust/flutter_rust',
)
external void _free(Pointer<Utf8> ptr);

// 2. The Logic Wrapper
String getNewUlid() {
  final ptr = _generate();
  final str = ptr.toDartString();
  _free(ptr); // Critical: Tells Rust to drop the string memory
  return str;
}

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: RustUlidApp()),
  );
}

class RustUlidApp extends StatefulWidget {
  const RustUlidApp({super.key});

  @override
  State<RustUlidApp> createState() => _RustUlidAppState();
}

class _RustUlidAppState extends State<RustUlidApp> {
  String _ulid = "Tap the button to start";
  final List<String> _history = [];

  void _generateAndRefresh() {
    setState(() {
      final newUlid = getNewUlid();
      _ulid = newUlid;
      _history.insert(0, newUlid); // Add to top of list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rust ⇄ Flutter (Native Assets)"),
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Latest ULID from Rust:",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            SelectableText(
              _ulid,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier', // ULIDs look best in mono
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _generateAndRefresh,
              icon: const Icon(Icons.bolt),
              label: const Text("Generate in Rust"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
            ),
            const Divider(height: 50),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "History:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.history, size: 16),
                    title: Text(
                      _history[index],
                      style: const TextStyle(fontFamily: 'Courier'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
