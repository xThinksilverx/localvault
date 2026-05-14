import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SecureScreen extends StatefulWidget {
  const SecureScreen({super.key});

  @override
  State<SecureScreen> createState() => _SecureScreenState();
}

class _SecureScreenState extends State<SecureScreen> {
  final _tokenController = TextEditingController();
  final _service = StorageService();
  String? _retrievedToken;

  Future<void> _save() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) return;
    await _service.saveToken(token);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Token salvo.')));
    }
  }

  Future<void> _read() async {
    final token = await _service.readToken();
    setState(() => _retrievedToken = token);
  }

  Future<void> _delete() async {
    await _service.deleteToken();
    setState(() => _retrievedToken = null);
    _tokenController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Token removido.')));
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Armazenamento Seguro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'flutter_secure_storage',
              style: TextStyle(fontSize: 12, letterSpacing: 1.5),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _tokenController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Token de autenticacao',
                border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: _save,
              child: const Text('Salvar token'),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: _read,
              child: const Text('Recuperar token'),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: _delete,
              child: const Text('Deletar token'),
            ),
            if (_retrievedToken != null) ...[
              const SizedBox(height: 32),
              const Divider(height: 1),
              const SizedBox(height: 24),
              const Text(
                'Token recuperado',
                style: TextStyle(fontSize: 12, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Text(
                  _retrievedToken!,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                  ),
                ),
              ),
            ],
            if (_retrievedToken == null) ...[
              const SizedBox(height: 32),
              Text(
                'Nenhum token recuperado ainda.',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
