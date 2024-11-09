// lib/main.dart
import 'package:flutter/material.dart';
import 'common/LogCat/widget/log_viewer.dart';

import 'common/LogCat/log_cat.dart';
import 'common/app_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppManager.initialize(applicationName: "MyLogApplication",isDevelopingMode: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Log Viewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Log Viewer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // LogViewer widget'ını kontrol etmek için GlobalKey
  final GlobalKey<LogViewerState> _logViewerKey = GlobalKey<LogViewerState>();

  /// Rastgele bir hata logu eklemek için kullanılan metod
  void _addRandomError() async {
    String className = 'MyHomePage';
    String methodName = '_addRandomError';
    String message = 'Rastgele hata oluştu: ${DateTime.now()}';
    Exception exception =
    Exception('RastgeleException_${DateTime.now().millisecondsSinceEpoch}');

    await LogCat.error(
      className: className,
      methodName: methodName,
      message: message,
      exception: exception,
    );

    // LogViewer'ı yenileme
    _logViewerKey.currentState?.refresh();

    // Kullanıcıya bildirim gösterme
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rastgele hata logu eklendi.')),
    );
  }

  /// Log dosyasını temizlemek için kullanılan metod
  void _clearLogs() async {
    await LogCat.clearLogFile();

    // LogViewer'ı yenileme
    _logViewerKey.currentState?.refresh();

    // Kullanıcıya bildirim gösterme
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Log dosyası temizlendi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          // Logları temizlemek için AppBar'da bir buton ekleyebilirsiniz
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Log Dosyasını Temizle',
            onPressed: () async {
              bool? confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Log Dosyasını Temizle'),
                  content: const Text('Tüm log kayıtlarını silmek istediğinizden emin misiniz?'),
                  actions: [
                    TextButton(
                      child: const Text('İptal'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: const Text('Evet'),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await LogCat.clearLogFile();
                await _logViewerKey.currentState?.refresh();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Log dosyası temizlendi.')),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Rastgele hata eklemek ve logları temizlemek için butonlar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _addRandomError,
              child: const Text('Rastgele Hata Ekle'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _clearLogs,
              child: const Text('Logları Temizle'),
            ),
          ),

          // LogViewer widget'ını gösterme
          Expanded(
            child: LogViewer(key: _logViewerKey),
          ),
        ],
      ),
    );
  }
}
