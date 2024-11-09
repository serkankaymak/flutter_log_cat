LogCat Entry
Flutter uygulamalarınızda etkin bir şekilde log (kayıt) yönetimi sağlayan bir paket. LogCat Entry, uygulama olaylarını, hataları ve debug bilgilerini yapılandırılmış bir şekilde yakalamak, görüntülemek ve yönetmek için basit ve etkili bir yol sunar.

Özellikler
Yapılandırılmış Loglama: Logları türüne göre (info, debug, error) kategorize edin.
Zaman Damgalı Girişler: Her log girişi otomatik olarak zaman damgasıyla işaretlenir.
Opsiyonel Alanlar: Platform bilgisi, sınıf adı, metod adı ve istisnalar gibi ek bağlam bilgilerini yakalayın.
Log Görüntüleyici Widget: Log girişlerini kullanıcı dostu bir arayüzde görüntüleyin.
Log Kart Widget: Bireysel log girişlerini detaylı bilgilerle sunun.
İşlem Güvenli Loglama: Çoklu iş parçacıklı ortamlarda güvenli loglama için senkronize mekanizmalar kullanın.
Kalıcı Depolama: (Gelecek özellik) Logları yerel depolamada saklayın ve daha sonra geri çağırın.
Kurulum
pubspec.yaml dosyanıza log_cat_entry paketini ekleyin:

yaml
Copy code
dependencies:
  log_cat_entry: ^0.1.0
Daha sonra, paketleri yüklemek için terminalde şu komutu çalıştırın:

bash
Copy code
flutter pub get
Kullanım
Paketi İçe Aktarma
LogCat Entry paketini kullanmak istediğiniz dosyada içe aktarın:

dart
Copy code
import 'package:log_cat_entry/log_cat_entry.dart';
LogManager'ı Başlatma
Log girişlerini yönetmek için bir LogManager örneği oluşturun:

dart
Copy code
final LogManager logManager = LogManager();
Log Girişi Ekleme
LogManager kullanarak log girişleri ekleyebilirsiniz:

dart
Copy code
logManager.addLog(LogCatEntry(
  logEntryType: LogEntryType.info,
  message: 'Uygulama başlatıldı',
  platformInfo: 'Flutter 3.0',
  className: 'MainApp',
  methodName: 'init',
));
Logları Görüntüleme
Log girişlerini kullanıcı arayüzünde görüntülemek için LogViewer widget'ını kullanın:

dart
Copy code
LogViewer(logManager: logManager)
Örnek
İşte LogCat Entry paketini Flutter uygulamanıza entegre etmenin basit bir örneği:

dart
Copy code
import 'package:flutter/material.dart';
import 'package:log_cat_entry/log_cat_entry.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final LogManager logManager = LogManager();

  @override
  Widget build(BuildContext context) {
    logManager.addLog(LogCatEntry(
      message: 'Uygulama başlatıldı',
    ));

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('LogCat Entry Örneği'),
        ),
        body: LogViewer(logManager: logManager),
      ),
    );
  }
}
Widget'lar
LogViewer
Log girişlerini listeleyen bir widget.

dart
Copy code
LogViewer({
  required LogManager logManager,
});
LogCard
Bireysel log girişlerini detaylı bilgilerle sunan bir widget.

dart
Copy code
LogCard({
  required LogCatEntry logEntry,
});
API Dokümantasyonu
LogCatEntry
Tek bir log girişini temsil eder.

dart
Copy code
enum LogEntryType { error, debug, info }

class LogCatEntry {
  final LogEntryType logEntryType;
  final DateTime timestamp;
  final String? platformInfo;
  final String? className;
  final String? methodName;
  final String message;
  final String? exception;

  LogCatEntry({
    LogEntryType? logEntryType,
    DateTime? timestamp,
    this.platformInfo,
    this.className,
    this.methodName,
    required this.message,
    this.exception,
  });
  
  factory LogCatEntry.fromJson(Map<String, dynamic> json) =>
      _$LogCatEntryFromJson(json);
  
  Map<String, dynamic> toJson() => _$LogCatEntryToJson(this);
}
LogManager
Log girişlerini yöneten sınıf.

dart
Copy code
class LogManager {
  final List<LogCatEntry> _logs = [];
  final Lock _lock = Lock();
  late final PackageInfo packageInfo;

  LogManager() {
    _initialize();
  }

  Future<void> _initialize() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  Future<void> addLog(LogCatEntry entry) async {
    await _lock.synchronized(() async {
      _logs.add(entry);
      // Örneğin, logları dosyaya kaydedebilirsiniz.
      // await _saveLogsToFile();
    });
  }

  List<LogCatEntry> get logs => List.unmodifiable(_logs);
}
Katkıda Bulunma
Katkılarınız hoş karşılanır! Herhangi bir geliştirme, hata düzeltmesi veya özellik eklemek isterseniz, lütfen bir issue açın veya bir pull request gönderin.

Lisans
(c) Onur. Tüm hakları saklıdır.

Ek Bilgiler
.gitignore Dosyası
Projede, .gitignore dosyasının Flutter ve genel geliştirme için uygun olduğundan emin olun. İşte temel bir .gitignore örneği:

bash
Copy code
# Flutter/Dart/Pub related
.dart_tool/
.packages
.pub-cache/
build/
.flutter-plugins
.flutter-plugins-dependencies
.idea/
.vscode/
*.iml

# OS related
.DS_Store
Thumbs.db
pubspec.yaml Dosyası
Paketinizin pubspec.yaml dosyasının doğru yapılandırıldığından emin olun. İşte sizin projenize uygun bir örnek:

yaml
Copy code
name: log_cat_entry
description: A Flutter package for logging entries with various details.
version: 0.1.0
homepage: https://github.com/onur/log_cat_entry
repository: https://github.com/onur/log_cat_entry
environment:
  sdk: ">=2.17.0 <3.0.0"
  flutter: ">=2.5.0"

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  path_provider: ^2.0.11
  synchronized: ^3.0.0
  package_info_plus: ^4.0.0
  json_annotation: ^4.8.0

dev_dependencies:
  build_runner: ^2.4.0
  json_serializable: ^6.6.1
  flutter_test:
    sdk: flutter
  test: ^1.21.0

publish_to: 'https://pub.dev' # Bu satır paketin pub.dev'e yayınlanmasını sağlar
