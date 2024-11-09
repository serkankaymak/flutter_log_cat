import 'package:flutter/material.dart';

import '../log_cat_entry.dart';

class LogCard extends StatefulWidget {
  final LogCatEntry entry;

  const LogCard({super.key, required this.entry});

  @override
  LogCardState createState() => LogCardState();
}

class LogCardState extends State<LogCard> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color:   widget.entry.logEntryType == LogEntryType.error ?  Colors.redAccent : Colors.white12,
      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: InkWell(
        onTap: _toggleExpanded,
        splashColor: Colors.lightBlue,
        focusColor: Colors.deepPurple,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.entry.timestamp.toLocal().toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '${widget.entry.className} - ${widget.entry.message ?? 'No message'}',
                  style: TextStyle(color: widget.entry.logEntryType==LogEntryType.error ? Colors.black : Colors.blue),
                ),
                if (_isExpanded) ...[
                  const SizedBox(height: 8.0),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Method'),
                    subtitle: Text(widget.entry.methodName ?? 'N/A'),
                  ),
                  if (widget.entry.exception != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Exception'),
                      subtitle: Text(widget.entry.exception!),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
