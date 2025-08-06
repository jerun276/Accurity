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
        contactName TEXT,
        contactEmail TEXT,
        contactPhone1 TEXT,
        contactPhone2 TEXT,
        natureOfDistrict TEXT,
        developmentType TEXT,
        configuration TEXT,
        topography TEXT,
        waterSupplyType TEXT,
        streetscape TEXT, -- Correctly a TEXT field now
        siteInfluence TEXT,
        siteImprovements TEXT,
        driveway TEXT,
        parking TEXT,
        occupancy TEXT,
        builtInPast10Years INTEGER NOT NULL,
        propertyType TEXT,
        designStyle TEXT,
        construction TEXT,
        sidingType TEXT NOT NULL,
        roofType TEXT NOT NULL,
        windowType TEXT NOT NULL,
        heatingType TEXT NOT NULL,
        electricalType TEXT NOT NULL,
        waterType TEXT NOT NULL,
        basementType TEXT,
        basementFinish TEXT,
        foundationType TEXT NOT NULL,
        basementRooms TEXT,
        basementFeatures TEXT NOT NULL,
        basementFlooring TEXT,
        basementCeilingType TEXT NOT NULL,
        mainLevelRooms TEXT,
        mainLevelFeatures TEXT NOT NULL,
        mainLevelFlooring TEXT,
        secondLevelRooms TEXT,
        secondLevelFeatures TEXT NOT NULL,
        secondLevelFlooring TEXT,
        thirdLevelRooms TEXT,
        thirdLevelFeatures TEXT NOT NULL,
        thirdLevelFlooring TEXT,
        fourthLevelRooms TEXT,
        fourthLevelFeatures TEXT NOT NULL,
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
        photoPaths TEXT NOT NULL
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
  /// Inserts the initial data for all dropdown menus into the database.
  /// This data comes directly from the "Inspection App Fields.csv".
  Future<void> _seedDropdowns(Database db) async {
    final batch = db.batch();

    // --- Order Details ---
    _addDropdownToBatch(batch, 'ServiceType', [
      'Full Appraisal',
      'Drive-by',
      'Desktop',
      'Progress Inspection',
    ]);
    _addDropdownToBatch(batch, 'LoanType', [
      'Purchase',
      'Refinance',
      'New Construction',
    ]);

    // --- Neighbourhood ---
    _addDropdownToBatch(batch, 'NatureOfDistrict', [
      'Urban',
      'Suburban',
      'Rural',
      'Recreational',
    ]);
    _addDropdownToBatch(batch, 'DevelopmentType', [
      'Resedential',
      'Commercial',
      'Industrial',
      'Agricultural',
    ]);

    // --- Site ---
    _addDropdownToBatch(batch, 'Configuration', [
      'More or Less Rectangular',
      'Pie-Shaped',
      'Irregular',
    ]);
    _addDropdownToBatch(batch, 'Topography', [
      'More or Less Level',
      'Slopes Down to Rear',
      'Slopes up to Rear',
    ]);
    _addDropdownToBatch(batch, 'WaterSupplyType', [
      'Municipal',
      'Well',
      'Cistern',
      'Dugout',
    ]);
    _addDropdownToBatch(batch, 'Streetscape', [
      'Curbs',
      'Lights',
      'Sidewalks',
      'Overhead Wires',
      'Underground Wires',
      'Open Ditch',
    ]);
    _addDropdownToBatch(batch, 'SiteInfluence', [
      'Fronts',
      'Backs',
      'Sides',
      'Across',
      // ---Location---
      'Access Street',
      'Arterial Street',
      'Park',
      'Path',
      'Greenspace',
      'Ravine',
      'Open Space',
      'School',
      'Golf Course',
      'Lake',
      'River',
      'Pond',
      'Undeveloped Land',
      'Commercial',
      'Industrial',
      'Mountain',
    ]);
    _addDropdownToBatch(batch, 'SiteImprovements', [
      'interlock walkway',
      'concrete walkway',
      'flag stone walkway',
      'concrete veranda',
      'stone patio',
      'tri level deck',
      'composite deck',
      'shed',
      '4 sheds',
      'play structure',
      'heated salt water inground pool',
      'sauna',
      'pool house',
      'retaining walls',
      'fenced rear yard',
      'round about',
      'balcony',
      'roof top patio',
      'synthetic grass',
      'gazeebo',
      'screened patio',
      'outdoor kitchen',
      'irrigation system',
      'asphalt walkway',
      'stone pool apron',
      'flag stone veranda',
      'interlock veranda',
      'paver stone walkway',
      'wood veranda',
      'interlock drivway',
      'concreate patio',
      'deck',
      'bi-level deck',
      '2 sheds',
      '3 sheds',
      'inground pool',
      'heated chlorine inground pool',
      'interlock pool apron',
      'concreate pool apron',
      'above ground pool apron',
      'hot tub',
      'dock',
      'pergolla',
      'pond',
      'part fenced rear yard',
      'stone driveway edging',
      'julliet balcony',
      'semi-inground pool',
      'artifical grass',
      'concreate driveway',
      'putting green',
      'covered porch',
      'covered patio',
      'covered deck',
    ]);
    _addDropdownToBatch(batch, 'Driveway', [
      'Private',
      'Mutual',
      'Single',
      'Double',
      'Circular',
      'None',
      // ---Surface---
      'Asphalt',
      'Concrete',
      'Interlock',
      'Gravel',
      'Heated',
    ]);
    _addDropdownToBatch(batch, 'Parking', [
      'Garage',
      'Carport',
      'Attached',
      'Detached',
      'Single',
      'Double',
      'Triple',
      'Quad',
      'Quad+',
      'Garage Opener',
      'Underground',
      'Underground x 2',
    ]);

    _addDropdownToBatch(batch, 'Occupancy', [
      'Owner',
      'Tenant',
      'Vacant',
      'Owner/Tenant',
    ]);

    // --- Structural Details ---
    _addDropdownToBatch(batch, 'PropertyType', [
      'Detached',
      'Semi-detached',
      'Townhouse',
      'side-by-side double',
      'front-to-back double',
      'long semi-detach',
      'condominium townhouse',
      'condominium apartment',
    ]);
    _addDropdownToBatch(batch, 'DesignStyle', [
      'Bungalow',
      '2 storey',
      '2.5 storey',
      '3 storey',
      'split level',
      'lower-level stacked',
      'upper-level stacked',
      'one level',
      'two levels',
    ]);
    _addDropdownToBatch(batch, 'Construction', [
      'Wood Frame',
      'Concrete',
      'Steel Frame',
    ]);
    _addDropdownToBatch(batch, 'SidingType', [
      'Brick',
      'stone',
      'siding',
      'stucco',
    ]);
    _addDropdownToBatch(batch, 'RoofType', [
      'Asphalt Shingle',
      'Metal',
      'Membrane',
      'Tar & Gravel',
      'Clay Tile',
    ]);
    _addDropdownToBatch(batch, 'WindowType', [
      'Vinyl',
      'Wood',
      'Aluminium',
      'Aluminium Clad Vinyl',
      'Aluminium Clad Wood',
    ]);

    // --- Mechanical ---
    _addDropdownToBatch(batch, 'HeatingType', [
      'Forced Air',
      'Basedboard',
      'Boiler',
      'Radiant In-floor',
      'Radiator',
      'Hydronic',
      'Heat Pump',
      // --- FUEL SOURCE ---
      'Gas',
      'Electric',
      'Oil',
      'Geo Thermal',
      // ---EXTRAS---
      'X2',
      'X3',
      'HRV',
      'Central Air',
      'Humidifier',
      'Air Cleaner',
    ]);
    _addDropdownToBatch(batch, 'ElectricalType', [
      '60',
      '100',
      '125',
      '150',
      '200',
      '300',
      '400',
      // ---TYPE---
      'Breaker',
      'Fuses',
      // ---OTHER---
      'X2',
      'X3',
      'X4',
      'X5',
      'Solar',
      'Backup Generator',
      'Secuirty',
      'Networked',
      'Intercom',
      'Video Surveilance',
    ]);
    _addDropdownToBatch(batch, 'WaterType', [
      'Tankless',
      '40',
      '50',
      '60',
      '80',
      '115',
      '151',
      '189',
      '227',
      'Gallons',
      'liters',
    ]);

    // --- Basement ---
    _addDropdownToBatch(batch, 'BasementType', [
      'Full',
      'Low',
      'Crawl',
      'None',
      'Walkout',
    ]);
    _addDropdownToBatch(batch, 'BasementFinish', [
      'Unfinished',
      'Finished',
      'Partially',
      'Unit',
    ]);
    _addDropdownToBatch(batch, 'FoundationType', [
      'Poured Concrete',
      'Block',
      'Stone',
      'Rubble',
      'Piles',
      'Wood',
      'Slab on Grade',
      'None',
    ]);
    _addDropdownToBatch(batch, 'BasementRooms', [
      '2 pc bath',
      '2 pc bath with laundry',
      '2 pc cheater bath',
      '2pc ensuite bath',
      '3 season sunroom',
    ]);
    _addDropdownToBatch(batch, 'BasementFeatures', [
      '9 foot ceilings',
      'archways',
      'automated blinds',
      'barn doors',
      'built in cabinets',
      'built in esperesson machine',
      'built in shelving',
      'built-in microwave',
      'built-in oven',
      'built-in stove',
      'catherderal ceiling',
      'chair rails',
      'closet',
      'coffered ceiling',
      'concreate counter tops',
      'control 4',
      'cove ceiling',
      'crown molding',
      'custom window shutters',
      'decorative pillars',
      'double sided fireplace',
      'Electric fireplace',
      'exposed beams',
      'French doors',
      'gas fireplace',
      'glass cabinet doors',
      'glass walls',
      'heated floors',
      'heated towl racks',
      'integrated sound',
      'laundry shoot',
      'massage shower',
      'networked',
      'palladian window',
      'pocket doors',
      'pot lighting',
      'round corner beads',
      'self closing cabinets',
      'skylight',
      'solid core doors',
      'solid surface bathroom counter tops',
      'Solid surface kitchen and bathroom counter tops',
      'solid surface kitchen counter tops',
      'steam shower',
      'stone wall',
      'texured wall',
      'transom window',
      'tray ceiling',
      'vault ceiling',
      'wainscoting',
      'walk-in closet',
      'wall mounted faucets',
      'waterfall island',
      'wood fireplace',
    ]);
    _addDropdownToBatch(batch, 'BasementFlooring', [
      'carpet',
      'ceramic',
      'cork',
      'cushion',
      'engineered hardwood',
      'laminate',
      'linoleum',
      'marble',
      'plank',
      'plywood',
      'polished concreate',
      'travetine',
      'vinyl plank',
      'vinyl title',
    ]);
    _addDropdownToBatch(batch, 'BasementCeilingType', [
      'dry-wall',
      'Ceiling tiile',
      'T bar',
      'Plaster',
    ]);

    // --- Component Age ---
    final ageRanges = [
      '0-5 yrs',
      '6-10 yrs',
      '11-15 yrs',
      '16-20 yrs',
      '21+ yrs',
    ];
    _addDropdownToBatch(batch, 'RoofAge', ageRanges);
    _addDropdownToBatch(batch, 'WindowAge', ageRanges);
    _addDropdownToBatch(batch, 'FurnaceAge', ageRanges);
    _addDropdownToBatch(batch, 'KitchenAge', ageRanges);
    _addDropdownToBatch(batch, 'BathAge', ageRanges);

    // Commit all the inserts in a single transaction.
    await batch.commit(noResult: true);
  }

  /// Helper to add a list of items for a specific category to a batch operation.
  void _addDropdownToBatch(Batch batch, String category, List<String> values) {
    for (final value in values) {
      batch.insert(_dropdownItemsTable, {'category': category, 'value': value});
    }
  }

  /// Saves an order to the database.
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
