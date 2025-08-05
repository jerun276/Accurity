import 'package:accurity/data/models/sync_status.enum.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../models/dropdown_item.model.dart';
import '../models/order.model.dart';

/// The filename for the SQLite database.
const String _dbFileName = 'accurity_inspection.db';

/// The name of the main orders table.
const String _ordersTable = 'orders';

/// The name of the dropdown options table.
const String _dropdownItemsTable = 'dropdown_items';

/// Manages all direct interactions with the local SQLite database.
///
/// This class is the lowest level of the data layer, responsible for executing
/// raw SQL queries for creating tables, seeding data, and performing CRUD operations.
class DatabaseRepository {
  final String dbPath;
  Database? _database;

  DatabaseRepository({required this.dbPath});

  /// Provides a singleton-like, ready-to-use database instance.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  /// Initializes the database connection.
  ///
  /// This method sets up the database, creates tables if they don't exist,
  /// and seeds the initial dropdown data.
  Future<void> init() async {
    _database = await _initDB();
  }

  Future<Database> _initDB() async {
    final path = p.join(dbPath, _dbFileName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  /// Called when the database is created for the first time.
  ///
  /// This is where the schema creation and initial data seeding happens.
  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
    await _seedDropdowns(db);
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE $_ordersTable (
        localId INTEGER PRIMARY KEY AUTOINCREMENT,
        supabaseId TEXT,
        syncStatus TEXT NOT NULL,
        clientFileNumber TEXT,
        firmFileNumber TEXT,
        address TEXT,
        applicantName TEXT,
        appointment TEXT,
        client TEXT,
        lender TEXT,
        serviceType TEXT,
        loanType TEXT,
        natureOfDistrict TEXT,
        developmentType TEXT,
        isGatedCommunity INTEGER NOT NULL,
        configuration TEXT,
        topography TEXT,
        waterSupplyType TEXT,
        isSepticWell INTEGER NOT NULL,
        streetscape TEXT,
        siteInfluence TEXT,
        siteImprovements TEXT,
        driveway TEXT,
        builtInPast10Years INTEGER NOT NULL,
        propertyType TEXT,
        designStyle TEXT,
        construction TEXT,
        sidingType TEXT,
        roofType TEXT,
        windowType TEXT,
        parking TEXT,
        garage TEXT,
        occupancy TEXT,
        heatingType TEXT,
        electricalType TEXT,
        waterType TEXT,
        basementType TEXT,
        basementFinish TEXT,
        foundationType TEXT,
        basementRooms TEXT,
        basementFeatures TEXT,
        basementFlooring TEXT,
        basementCeilingType TEXT,
        mainLevelRooms TEXT,
        mainLevelFeatures TEXT,
        mainLevelFlooring TEXT,
        secondLevelRooms TEXT,
        secondLevelFeatures TEXT,
        secondLevelFlooring TEXT,
        thirdLevelRooms TEXT,
        thirdLevelFeatures TEXT,
        thirdLevelFlooring TEXT,
        fourthLevelRooms TEXT,
        fourthLevelFeatures TEXT,
        fourthLevelFlooring TEXT,
        roofAge TEXT,
        windowAge TEXT,
        furnaceAge TEXT,
        kitchenAge TEXT,
        bathAge TEXT,
        roofNotes TEXT,
        windowNotes TEXT,
        kitchenNotes TEXT,
        bathNotes TEXT,
        furnaceNotes TEXT,
        bankValue TEXT,
        ownerValue TEXT,
        purchasePrice TEXT,
        purchaseDate TEXT,
        photoPaths TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $_dropdownItemsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        value TEXT NOT NULL
      )
    ''');
  }

  /// Inserts the initial data for all dropdown menus into the database.
  /// This data comes directly from the "Inspection App Fields.csv".
  Future<void> _seedDropdowns(Database db) async {
    final batch = db.batch();

    // Example for PropertyType
    _addDropdownToBatch(batch, 'PropertyType', [
      'Detached',
      'Semi-detached',
      'Townhouse',
      'Stacked Town',
      'Condominium',
      'Apartment',
      'Mobile',
    ]);
    // Example for SidingType
    _addDropdownToBatch(batch, 'SidingType', [
      'Vinyl',
      'Brick',
      'Stone',
      'Cement Board',
      'Aluminum',
      'Wood',
    ]);
    // Example for WaterSupplyType
    _addDropdownToBatch(batch, 'WaterSupplyType', [
      'Municipal',
      'Well',
      'Cistern',
      'Dugout',
    ]);

    // ... ADD ALL OTHER DROPDOWN LISTS FROM YOUR EXCEL SHEET HERE ...
    // Use the `_addDropdownToBatch` helper for each category.

    await batch.commit(noResult: true);
  }

  /// Helper to add a list of items for a specific category to a batch operation.
  void _addDropdownToBatch(Batch batch, String category, List<String> values) {
    for (final value in values) {
      batch.insert(_dropdownItemsTable, {'category': category, 'value': value});
    }
  }

  // --- CRUD OPERATIONS ---

  /// Saves an order to the database.
  ///
  /// This performs an "upsert": if the order has a `localId`, it's an UPDATE.
  /// If `localId` is null, it's an INSERT.
  Future<Order> saveOrder(Order order) async {
    final db = await database;
    final map = order.toDbMap();

    // Remove null id for insert, keep it for update
    if (map['localId'] == null) {
      map.remove('localId');
    }

    final id = await db.insert(
      _ordersTable,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return order.copyWith(localId: id);
  }

  /// Retrieves a single order by its local ID.
  Future<Order> getOrder(int localId) async {
    final db = await database;
    final maps = await db.query(
      _ordersTable,
      where: 'localId = ?',
      whereArgs: [localId],
    );
    if (maps.isNotEmpty) {
      return Order.fromDbMap(maps.first);
    }
    throw Exception('Order with ID $localId not found');
  }

  /// Retrieves all orders from the database.
  Future<List<Order>> getAllOrders() async {
    final db = await database;
    final maps = await db.query(_ordersTable, orderBy: 'localId DESC');
    return maps.map((map) => Order.fromDbMap(map)).toList();
  }

  /// Retrieves a list of orders that match a specific sync status.
  Future<List<Order>> getOrdersWithStatus(List<SyncStatus> statuses) async {
    final db = await database;
    final statusStrings = statuses.map((s) => s.name).toList();
    final maps = await db.query(
      _ordersTable,
      where:
          'syncStatus IN (${List.filled(statusStrings.length, '?').join(',')})',
      whereArgs: statusStrings,
    );
    return maps.map((map) => Order.fromDbMap(map)).toList();
  }

  /// Retrieves all dropdown items for a specific category.
  Future<List<DropdownItem>> getDropdownItems(String category) async {
    final db = await database;
    final maps = await db.query(
      _dropdownItemsTable,
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'value ASC',
    );
    return maps.map((map) => DropdownItem.fromMap(map)).toList();
  }
}
