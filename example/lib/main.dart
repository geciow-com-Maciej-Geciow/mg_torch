import 'package:flutter/material.dart';
import 'package:mg_torch/mg_torch.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool available = false;
  bool enabled = false;

  @override
  void initState() {
    super.initState();
    MgTorch.isAvailable().then((v) => setState(() => available = v));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('mg_torch example')),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Torch available: $available'),
            const SizedBox(height: 12),
            Switch(
              value: enabled,
              onChanged: available ? (v) async {
                setState(() => enabled = v);
                await MgTorch.set(v);
              } : null,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: available ? () async {
                setState(() => enabled = !enabled);
                await MgTorch.set(enabled);
              } : null,
              child: Text(enabled ? 'Turn off' : 'Turn on'),
            ),
          ]),
        ),
      ),
    );
  }
}
