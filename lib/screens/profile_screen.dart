import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _scoreController = TextEditingController();
  Box<UserProfile>? _box;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    final box = await Hive.openBox<UserProfile>('user_profile');
    setState(() => _box = box);
    final profile = box.get('profile');
    if (profile != null) {
      _nameController.text = profile.name;
      _emailController.text = profile.email;
      _scoreController.text = profile.score.toString();
    }
  }

  Future<void> _save() async {
    final box = _box;
    if (box == null) return;
    final score = int.tryParse(_scoreController.text) ?? 0;
    final profile = UserProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      registrationDate: DateTime.now(),
      score: score,
    );
    await box.put('profile', profile);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil salvo.')),
      );
    }
  }

  Future<void> _clear() async {
    final box = _box;
    if (box == null) return;
    await box.delete('profile');
    _nameController.clear();
    _emailController.clear();
    _scoreController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados removidos.')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuario'),
      ),
      body: _box == null
          ? const Center(child: CircularProgressIndicator())
          : ValueListenableBuilder(
              valueListenable: _box!.listenable(),
              builder: (context, Box<UserProfile> box, _) {
                final profile = box.get('profile');
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hive',
                        style: TextStyle(fontSize: 12, letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 24),
                      _Field(
                        label: 'Nome',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 16),
                      _Field(
                        label: 'E-mail',
                        controller: _emailController,
                        keyboard: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _Field(
                        label: 'Pontuacao',
                        controller: _scoreController,
                        keyboard: TextInputType.number,
                      ),
                      const SizedBox(height: 32),
                      TextButton(
                        onPressed: _save,
                        child: const Text('Salvar perfil'),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: profile != null ? _clear : null,
                        child: const Text('Limpar dados (LGPD)'),
                      ),
                      if (profile != null) ...[
                        const SizedBox(height: 32),
                        const Divider(height: 1),
                        const SizedBox(height: 24),
                        const Text(
                          'Perfil salvo',
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _InfoRow(label: 'Nome', value: profile.name),
                        _InfoRow(label: 'E-mail', value: profile.email),
                        _InfoRow(
                          label: 'Cadastro',
                          value:
                              '${profile.registrationDate.day}/${profile.registrationDate.month}/${profile.registrationDate.year}',
                        ),
                        _InfoRow(
                          label: 'Pontuacao',
                          value: profile.score.toString(),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboard;

  const _Field({
    required this.label,
    required this.controller,
    this.keyboard,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
