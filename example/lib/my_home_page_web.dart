import 'package:ali_auth_spm/ali_auth.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _accessTokenController = TextEditingController();
  final _jwtTokenController = TextEditingController();
  String _sdkVersion = 'Loading...';
  String _result = 'Ready';

  @override
  void initState() {
    super.initState();
    _loadSdkVersion();
  }

  Future<void> _loadSdkVersion() async {
    try {
      final version = await AliAuth.sdkVersion;
      if (mounted) setState(() => _sdkVersion = version ?? 'Unknown');
    } catch (error) {
      if (mounted) setState(() => _sdkVersion = 'Failed: $error');
    }
  }

  void _setResult(Object? value) {
    if (mounted) setState(() => _result = value.toString());
  }

  Future<void> _authenticate() async {
    await AliAuth.checkAuthAvailable(
      _accessTokenController.text,
      _jwtTokenController.text,
      success: (status) {
        _setResult(status);
        AliAuth.getVerifyToken(
          success: _setResult,
          error: _setResult,
        );
      },
      error: _setResult,
    );
  }

  @override
  void dispose() {
    _accessTokenController.dispose();
    _jwtTokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ali Auth Web Example')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Web SDK version: $_sdkVersion'),
          const SizedBox(height: 16),
          TextField(
            controller: _accessTokenController,
            decoration: const InputDecoration(labelText: 'Access token'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _jwtTokenController,
            decoration: const InputDecoration(labelText: 'JWT token'),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _authenticate,
            child: const Text('Authenticate and get verify token'),
          ),
          const SizedBox(height: 20),
          SelectableText('Result: $_result'),
        ],
      ),
    );
  }
}
