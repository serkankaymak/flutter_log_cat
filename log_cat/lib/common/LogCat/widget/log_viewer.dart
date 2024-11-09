// lib/common/LogCat/widget/log_list_screen.dart
import 'package:flutter/material.dart';

import '../log_cat.dart';
import '../log_cat_entry.dart';
import 'log_card.dart';

class LogViewer extends StatefulWidget {
  const LogViewer({super.key});

  @override
  LogViewerState createState() => LogViewerState();
}

class LogViewerState extends State<LogViewer> {
  late Future<List<LogCatEntry>> _logEntriesFuture;

  @override
  void initState() {
    super.initState();
    _logEntriesFuture = LogCat.readLogEntries();
  }

  Future<void> refresh() async {
    setState(() {
      _logEntriesFuture = LogCat.readLogEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: FutureBuilder<List<LogCatEntry>>(
        future: _logEntriesFuture,
        builder: (context, snapshot) {
          return getWidgetFromSnapshot(snapshot);
        },
      ),
    );
  }

  Widget getWidgetFromSnapshot(AsyncSnapshot<List<LogCatEntry>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return const Center(child: Text('Logları yüklerken bir hata oluştu.'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      // Log bulunmadığında kaydırılabilir bir ListView ile mesaj göster
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(), // Her durumda kaydırılabilir yap
        children: const [
          SizedBox(
            height: 400, // Mesajın görünmesi için yeterli boşluk ekle
            child: Center(
              child: Text('Hiç log kaydı bulunmuyor.'),
            ),
          ),
        ],
      );
    } else {
      List<LogCatEntry> logEntries = snapshot.data!;
      return ListView.builder(
        itemCount: logEntries.length,
        itemBuilder: (context, index) {
          LogCatEntry entry = logEntries[index];
          return LogCard(entry: entry);
        },
      );
    }
  }
}
