import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuracoes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SharedPreferences',
              style: TextStyle(fontSize: 12, letterSpacing: 1.5),
            ),
            const SizedBox(height: 24),
            _SettingRow(
              label: 'Modo escuro',
              child: Switch(
                value: settings.darkMode,
                onChanged: settings.setDarkMode,
              ),
            ),
            const Divider(height: 1),
            _SettingRow(
              label: 'Notificacoes',
              child: Switch(
                value: settings.notifications,
                onChanged: settings.setNotifications,
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 24),
            const Text('Idioma'),
            const SizedBox(height: 12),
            Row(
              children: [
                _LangButton(
                  label: 'Portugues',
                  selected: settings.language == 'pt',
                  onTap: () => settings.setLanguage('pt'),
                ),
                const SizedBox(width: 12),
                _LangButton(
                  label: 'Ingles',
                  selected: settings.language == 'en',
                  onTap: () => settings.setLanguage('en'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Idioma atual: ${settings.language == 'pt' ? 'Portugues' : 'Ingles'}',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _SettingRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          child,
        ],
      ),
    );
  }
}

class _LangButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LangButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? (isDark ? Colors.white : Colors.black)
              : Colors.transparent,
          border: Border.all(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected
                ? (isDark ? Colors.black : Colors.white)
                : (isDark ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
