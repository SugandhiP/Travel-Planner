// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ExpenseDao? _expenseDaoInstance;

  DestinationDao? _destinationDaoInstance;

  AttractionDao? _attractionDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Expense` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `category` TEXT NOT NULL, `amount` REAL NOT NULL, `note` TEXT NOT NULL, `travelDetailsId` TEXT NOT NULL, `date` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Destination` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `country` TEXT NOT NULL, `imageUrl` TEXT NOT NULL, `attractionsJson` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Attraction` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `country` TEXT NOT NULL, `imageUrl` TEXT NOT NULL, `destinationId` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ExpenseDao get expenseDao {
    return _expenseDaoInstance ??= _$ExpenseDao(database, changeListener);
  }

  @override
  DestinationDao get destinationDao {
    return _destinationDaoInstance ??=
        _$DestinationDao(database, changeListener);
  }

  @override
  AttractionDao get attractionDao {
    return _attractionDaoInstance ??= _$AttractionDao(database, changeListener);
  }
}

class _$ExpenseDao extends ExpenseDao {
  _$ExpenseDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _expenseInsertionAdapter = InsertionAdapter(
            database,
            'Expense',
            (Expense item) => <String, Object?>{
                  'id': item.id,
                  'category': item.category,
                  'amount': item.amount,
                  'note': item.note,
                  'travelDetailsId': item.travelDetailsId,
                  'date': _dateTimeConverter.encode(item.date)
                },
            changeListener),
        _expenseUpdateAdapter = UpdateAdapter(
            database,
            'Expense',
            ['id'],
            (Expense item) => <String, Object?>{
                  'id': item.id,
                  'category': item.category,
                  'amount': item.amount,
                  'note': item.note,
                  'travelDetailsId': item.travelDetailsId,
                  'date': _dateTimeConverter.encode(item.date)
                },
            changeListener),
        _expenseDeletionAdapter = DeletionAdapter(
            database,
            'Expense',
            ['id'],
            (Expense item) => <String, Object?>{
                  'id': item.id,
                  'category': item.category,
                  'amount': item.amount,
                  'note': item.note,
                  'travelDetailsId': item.travelDetailsId,
                  'date': _dateTimeConverter.encode(item.date)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Expense> _expenseInsertionAdapter;

  final UpdateAdapter<Expense> _expenseUpdateAdapter;

  final DeletionAdapter<Expense> _expenseDeletionAdapter;

  @override
  Future<List<Expense>> findAllExpenses() async {
    return _queryAdapter.queryList('SELECT * FROM Expense',
        mapper: (Map<String, Object?> row) => Expense(
            id: row['id'] as int?,
            category: row['category'] as String,
            amount: row['amount'] as double,
            note: row['note'] as String,
            date: _dateTimeConverter.decode(row['date'] as int),
            travelDetailsId: row['travelDetailsId'] as String));
  }

  @override
  Stream<Expense?> findExpenseById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Expense WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Expense(
            id: row['id'] as int?,
            category: row['category'] as String,
            amount: row['amount'] as double,
            note: row['note'] as String,
            date: _dateTimeConverter.decode(row['date'] as int),
            travelDetailsId: row['travelDetailsId'] as String),
        arguments: [id],
        queryableName: 'Expense',
        isView: false);
  }

  @override
  Future<List<Expense>> findExpensesByTravelDetailsId(
      String travelDetailsId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Expense WHERE travelDetailsId = ?1',
        mapper: (Map<String, Object?> row) => Expense(
            id: row['id'] as int?,
            category: row['category'] as String,
            amount: row['amount'] as double,
            note: row['note'] as String,
            date: _dateTimeConverter.decode(row['date'] as int),
            travelDetailsId: row['travelDetailsId'] as String),
        arguments: [travelDetailsId]);
  }

  @override
  Future<void> insertExpense(Expense expense) async {
    await _expenseInsertionAdapter.insert(expense, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    await _expenseUpdateAdapter.update(expense, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteExpense(Expense expense) async {
    await _expenseDeletionAdapter.delete(expense);
  }
}

class _$DestinationDao extends DestinationDao {
  _$DestinationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _destinationInsertionAdapter = InsertionAdapter(
            database,
            'Destination',
            (Destination item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'country': item.country,
                  'imageUrl': item.imageUrl,
                  'attractionsJson': item.attractionsJson
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Destination> _destinationInsertionAdapter;

  @override
  Future<List<Destination>> getAllDestinations() async {
    return _queryAdapter.queryList('SELECT * FROM Destination',
        mapper: (Map<String, Object?> row) => Destination(
            id: row['id'] as int?,
            name: row['name'] as String,
            country: row['country'] as String,
            imageUrl: row['imageUrl'] as String,
            attractionsJson: row['attractionsJson'] as String));
  }

  @override
  Future<int> insertDestination(Destination destination) {
    return _destinationInsertionAdapter.insertAndReturnId(
        destination, OnConflictStrategy.abort);
  }
}

class _$AttractionDao extends AttractionDao {
  _$AttractionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _attractionInsertionAdapter = InsertionAdapter(
            database,
            'Attraction',
            (Attraction item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'country': item.country,
                  'imageUrl': item.imageUrl,
                  'destinationId': item.destinationId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Attraction> _attractionInsertionAdapter;

  @override
  Future<List<Attraction>> getAttractionsForDestination(
      int destinationId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Attraction WHERE destinationId = ?1',
        mapper: (Map<String, Object?> row) => Attraction(
            id: row['id'] as int?,
            name: row['name'] as String,
            country: row['country'] as String,
            imageUrl: row['imageUrl'] as String,
            destinationId: row['destinationId'] as int),
        arguments: [destinationId]);
  }

  @override
  Future<void> insertAttraction(Attraction attraction) async {
    await _attractionInsertionAdapter.insert(
        attraction, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
