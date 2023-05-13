import 'package:drift/drift.dart';
import 'package:authex/src/core/database/connection/open_connection_stub.dart'
    if (dart.library.io) 'package:authex/src/core/database/connection/open_connection_io.dart'
    if (dart.library.html) 'package:authex/src/core/database/connection/open_connection_html.dart'
    as connection;

part 'app_database.g.dart';

@DriftDatabase()
class AppDatabase extends _$AppDatabase {
  AppDatabase({required String name}) : super(connection.openConnection(name));

  @override
  int get schemaVersion => 1;
}
