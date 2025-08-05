import 'dart:convert';
import 'sync_status.enum.dart';

/// The primary data model for an entire inspection order.
///
/// This class represents all the data points collected during an inspection,
/// from order details to structural notes. It is designed to be immutable.
class Order {
  // --- DATABASE & SYNC MANAGEMENT ---
  final int? localId; // Local SQLite auto-incrementing primary key
  final String? supabaseId; // Cloud DB primary key (used for future sync)
  final SyncStatus syncStatus;

  // --- ORDER DETAILS ---
  final String? clientFileNumber;
  final String? firmFileNumber;
  final String? address;
  final String? applicantName;
  final String? appointment;
  final String? client;
  final String? lender;
  final String? serviceType;
  final String? loanType;

  // --- NEIGHBOURHOOD ---
  final String? natureOfDistrict;
  final String? developmentType;
  final bool isGatedCommunity;

  // --- SITE ---
  final String? configuration;
  final String? topography;
  final String? waterSupplyType;
  final bool isSepticWell;
  final List<String> streetscape; // Checkbox List
  final String? siteInfluence;
  final String? siteImprovements;
  final String? driveway;

  // --- STRUCTURAL DETAILS ---
  final bool builtInPast10Years;
  final String? propertyType;
  final String? designStyle;
  final String? construction;
  final String? sidingType;
  final String? roofType;
  final String? windowType;
  final String? parking;
  final String? garage;
  final String? occupancy;

  // --- MECHANICAL ---
  final String? heatingType;
  final String? electricalType;
  final String? waterType;

  // --- BASEMENT ---
  final String? basementType;
  final String? basementFinish;
  final String? foundationType;
  final String? basementRooms;
  final String? basementFeatures;
  final String? basementFlooring;
  final String? basementCeilingType;

  // --- LEVEL DETAILS (MAIN, SECOND, THIRD, FOURTH) ---
  // Using separate fields for simplicity, can be refactored to a Level model later if needed.
  final String? mainLevelRooms;
  final String? mainLevelFeatures;
  final String? mainLevelFlooring;
  final String? secondLevelRooms;
  final String? secondLevelFeatures;
  final String? secondLevelFlooring;
  final String? thirdLevelRooms;
  final String? thirdLevelFeatures;
  final String? thirdLevelFlooring;
  final String? fourthLevelRooms;
  final String? fourthLevelFeatures;
  final String? fourthLevelFlooring;

  // --- COMPONENT AGE ---
  final String? roofAge;
  final String? windowAge;
  final String? furnaceAge;
  final String? kitchenAge;
  final String? bathAge;

  // --- NOTES ---
  final String? roofNotes;
  final String? windowNotes;
  final String? kitchenNotes;
  final String? bathNotes;
  final String? furnaceNotes;

  // --- VALUE INDICATORS ---
  final String? bankValue;
  final String? ownerValue;
  final String? purchasePrice;
  final String? purchaseDate;

  // --- PHOTO ATTACHMENTS ---
  final List<String> photoPaths;

  Order({
    // DB & Sync
    this.localId,
    this.supabaseId,
    this.syncStatus = SyncStatus.localOnly,
    // Order Details
    this.clientFileNumber,
    this.firmFileNumber,
    this.address,
    this.applicantName,
    this.appointment,
    this.client,
    this.lender,
    this.serviceType,
    this.loanType,
    // Neighbourhood
    this.natureOfDistrict,
    this.developmentType,
    this.isGatedCommunity = false,
    // Site
    this.configuration,
    this.topography,
    this.waterSupplyType,
    this.isSepticWell = false,
    this.streetscape = const [],
    this.siteInfluence,
    this.siteImprovements,
    this.driveway,
    // Structural Details
    this.builtInPast10Years = false,
    this.propertyType,
    this.designStyle,
    this.construction,
    this.sidingType,
    this.roofType,
    this.windowType,
    this.parking,
    this.garage,
    this.occupancy,
    // Mechanical
    this.heatingType,
    this.electricalType,
    this.waterType,
    // Basement
    this.basementType,
    this.basementFinish,
    this.foundationType,
    this.basementRooms,
    this.basementFeatures,
    this.basementFlooring,
    this.basementCeilingType,
    // Levels
    this.mainLevelRooms,
    this.mainLevelFeatures,
    this.mainLevelFlooring,
    this.secondLevelRooms,
    this.secondLevelFeatures,
    this.secondLevelFlooring,
    this.thirdLevelRooms,
    this.thirdLevelFeatures,
    this.thirdLevelFlooring,
    this.fourthLevelRooms,
    this.fourthLevelFeatures,
    this.fourthLevelFlooring,
    // Component Age
    this.roofAge,
    this.windowAge,
    this.furnaceAge,
    this.kitchenAge,
    this.bathAge,
    // Notes
    this.roofNotes,
    this.windowNotes,
    this.kitchenNotes,
    this.bathNotes,
    this.furnaceNotes,
    // Value Indicators
    this.bankValue,
    this.ownerValue,
    this.purchasePrice,
    this.purchaseDate,
    // Photos
    this.photoPaths = const [],
  });

  /// Creates a copy of this Order instance with the given fields replaced
  /// with new values. Essential for immutable state management with BLoC.
  Order copyWith({
    int? localId,
    String? supabaseId,
    SyncStatus? syncStatus,
    String? clientFileNumber,
    String? firmFileNumber,
    String? address,
    String? applicantName,
    String? appointment,
    String? client,
    String? lender,
    String? serviceType,
    String? loanType,
    String? natureOfDistrict,
    String? developmentType,
    bool? isGatedCommunity,
    String? configuration,
    String? topography,
    String? waterSupplyType,
    bool? isSepticWell,
    List<String>? streetscape,
    String? siteInfluence,
    String? siteImprovements,
    String? driveway,
    bool? builtInPast10Years,
    String? propertyType,
    String? designStyle,
    String? construction,
    String? sidingType,
    String? roofType,
    String? windowType,
    String? parking,
    String? garage,
    String? occupancy,
    String? heatingType,
    String? electricalType,
    String? waterType,
    String? basementType,
    String? basementFinish,
    String? foundationType,
    String? basementRooms,
    String? basementFeatures,
    String? basementFlooring,
    String? basementCeilingType,
    String? mainLevelRooms,
    String? mainLevelFeatures,
    String? mainLevelFlooring,
    String? secondLevelRooms,
    String? secondLevelFeatures,
    String? secondLevelFlooring,
    String? thirdLevelRooms,
    String? thirdLevelFeatures,
    String? thirdLevelFlooring,
    String? fourthLevelRooms,
    String? fourthLevelFeatures,
    String? fourthLevelFlooring,
    String? roofAge,
    String? windowAge,
    String? furnaceAge,
    String? kitchenAge,
    String? bathAge,
    String? roofNotes,
    String? windowNotes,
    String? kitchenNotes,
    String? bathNotes,
    String? furnaceNotes,
    String? bankValue,
    String? ownerValue,
    String? purchasePrice,
    String? purchaseDate,
    List<String>? photoPaths,
  }) {
    return Order(
      localId: localId ?? this.localId,
      supabaseId: supabaseId ?? this.supabaseId,
      syncStatus: syncStatus ?? this.syncStatus,
      clientFileNumber: clientFileNumber ?? this.clientFileNumber,
      firmFileNumber: firmFileNumber ?? this.firmFileNumber,
      address: address ?? this.address,
      applicantName: applicantName ?? this.applicantName,
      appointment: appointment ?? this.appointment,
      client: client ?? this.client,
      lender: lender ?? this.lender,
      serviceType: serviceType ?? this.serviceType,
      loanType: loanType ?? this.loanType,
      natureOfDistrict: natureOfDistrict ?? this.natureOfDistrict,
      developmentType: developmentType ?? this.developmentType,
      isGatedCommunity: isGatedCommunity ?? this.isGatedCommunity,
      configuration: configuration ?? this.configuration,
      topography: topography ?? this.topography,
      waterSupplyType: waterSupplyType ?? this.waterSupplyType,
      isSepticWell: isSepticWell ?? this.isSepticWell,
      streetscape: streetscape ?? this.streetscape,
      siteInfluence: siteInfluence ?? this.siteInfluence,
      siteImprovements: siteImprovements ?? this.siteImprovements,
      driveway: driveway ?? this.driveway,
      builtInPast10Years: builtInPast10Years ?? this.builtInPast10Years,
      propertyType: propertyType ?? this.propertyType,
      designStyle: designStyle ?? this.designStyle,
      construction: construction ?? this.construction,
      sidingType: sidingType ?? this.sidingType,
      roofType: roofType ?? this.roofType,
      windowType: windowType ?? this.windowType,
      parking: parking ?? this.parking,
      garage: garage ?? this.garage,
      occupancy: occupancy ?? this.occupancy,
      heatingType: heatingType ?? this.heatingType,
      electricalType: electricalType ?? this.electricalType,
      waterType: waterType ?? this.waterType,
      basementType: basementType ?? this.basementType,
      basementFinish: basementFinish ?? this.basementFinish,
      foundationType: foundationType ?? this.foundationType,
      basementRooms: basementRooms ?? this.basementRooms,
      basementFeatures: basementFeatures ?? this.basementFeatures,
      basementFlooring: basementFlooring ?? this.basementFlooring,
      basementCeilingType: basementCeilingType ?? this.basementCeilingType,
      mainLevelRooms: mainLevelRooms ?? this.mainLevelRooms,
      mainLevelFeatures: mainLevelFeatures ?? this.mainLevelFeatures,
      mainLevelFlooring: mainLevelFlooring ?? this.mainLevelFlooring,
      secondLevelRooms: secondLevelRooms ?? this.secondLevelRooms,
      secondLevelFeatures: secondLevelFeatures ?? this.secondLevelFeatures,
      secondLevelFlooring: secondLevelFlooring ?? this.secondLevelFlooring,
      thirdLevelRooms: thirdLevelRooms ?? this.thirdLevelRooms,
      thirdLevelFeatures: thirdLevelFeatures ?? this.thirdLevelFeatures,
      thirdLevelFlooring: thirdLevelFlooring ?? this.thirdLevelFlooring,
      fourthLevelRooms: fourthLevelRooms ?? this.fourthLevelRooms,
      fourthLevelFeatures: fourthLevelFeatures ?? this.fourthLevelFeatures,
      fourthLevelFlooring: fourthLevelFlooring ?? this.fourthLevelFlooring,
      roofAge: roofAge ?? this.roofAge,
      windowAge: windowAge ?? this.windowAge,
      furnaceAge: furnaceAge ?? this.furnaceAge,
      kitchenAge: kitchenAge ?? this.kitchenAge,
      bathAge: bathAge ?? this.bathAge,
      roofNotes: roofNotes ?? this.roofNotes,
      windowNotes: windowNotes ?? this.windowNotes,
      kitchenNotes: kitchenNotes ?? this.kitchenNotes,
      bathNotes: bathNotes ?? this.bathNotes,
      furnaceNotes: furnaceNotes ?? this.furnaceNotes,
      bankValue: bankValue ?? this.bankValue,
      ownerValue: ownerValue ?? this.ownerValue,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      photoPaths: photoPaths ?? this.photoPaths,
    );
  }

  /// Converts this Order object into a map for SQLite insertion.
  Map<String, dynamic> toDbMap() {
    return {
      'localId': localId,
      'supabaseId': supabaseId,
      'syncStatus': syncStatus.name, // Store enum as string
      'clientFileNumber': clientFileNumber,
      'firmFileNumber': firmFileNumber,
      'address': address,
      'applicantName': applicantName,
      'appointment': appointment,
      'client': client,
      'lender': lender,
      'serviceType': serviceType,
      'loanType': loanType,
      'natureOfDistrict': natureOfDistrict,
      'developmentType': developmentType,
      'isGatedCommunity': isGatedCommunity ? 1 : 0, // bool to int
      'configuration': configuration,
      'topography': topography,
      'waterSupplyType': waterSupplyType,
      'isSepticWell': isSepticWell ? 1 : 0, // bool to int
      'streetscape': jsonEncode(streetscape), // list to json string
      'siteInfluence': siteInfluence,
      'siteImprovements': siteImprovements,
      'driveway': driveway,
      'builtInPast10Years': builtInPast10Years ? 1 : 0, // bool to int
      'propertyType': propertyType,
      'designStyle': designStyle,
      'construction': construction,
      'sidingType': sidingType,
      'roofType': roofType,
      'windowType': windowType,
      'parking': parking,
      'garage': garage,
      'occupancy': occupancy,
      'heatingType': heatingType,
      'electricalType': electricalType,
      'waterType': waterType,
      'basementType': basementType,
      'basementFinish': basementFinish,
      'foundationType': foundationType,
      'basementRooms': basementRooms,
      'basementFeatures': basementFeatures,
      'basementFlooring': basementFlooring,
      'basementCeilingType': basementCeilingType,
      'mainLevelRooms': mainLevelRooms,
      'mainLevelFeatures': mainLevelFeatures,
      'mainLevelFlooring': mainLevelFlooring,
      'secondLevelRooms': secondLevelRooms,
      'secondLevelFeatures': secondLevelFeatures,
      'secondLevelFlooring': secondLevelFlooring,
      'thirdLevelRooms': thirdLevelRooms,
      'thirdLevelFeatures': thirdLevelFeatures,
      'thirdLevelFlooring': thirdLevelFlooring,
      'fourthLevelRooms': fourthLevelRooms,
      'fourthLevelFeatures': fourthLevelFeatures,
      'fourthLevelFlooring': fourthLevelFlooring,
      'roofAge': roofAge,
      'windowAge': windowAge,
      'furnaceAge': furnaceAge,
      'kitchenAge': kitchenAge,
      'bathAge': bathAge,
      'roofNotes': roofNotes,
      'windowNotes': windowNotes,
      'kitchenNotes': kitchenNotes,
      'bathNotes': bathNotes,
      'furnaceNotes': furnaceNotes,
      'bankValue': bankValue,
      'ownerValue': ownerValue,
      'purchasePrice': purchasePrice,
      'purchaseDate': purchaseDate,
      'photoPaths': jsonEncode(photoPaths), // list to json string
    };
  }

  /// Creates an Order object from a map retrieved from SQLite.
  factory Order.fromDbMap(Map<String, dynamic> map) {
    return Order(
      localId: map['localId'],
      supabaseId: map['supabaseId'],
      syncStatus: SyncStatus.values.firstWhere(
        (e) => e.name == map['syncStatus'],
      ),
      clientFileNumber: map['clientFileNumber'],
      firmFileNumber: map['firmFileNumber'],
      address: map['address'],
      applicantName: map['applicantName'],
      appointment: map['appointment'],
      client: map['client'],
      lender: map['lender'],
      serviceType: map['serviceType'],
      loanType: map['loanType'],
      natureOfDistrict: map['natureOfDistrict'],
      developmentType: map['developmentType'],
      isGatedCommunity: map['isGatedCommunity'] == 1, // int to bool
      configuration: map['configuration'],
      topography: map['topography'],
      waterSupplyType: map['waterSupplyType'],
      isSepticWell: map['isSepticWell'] == 1, // int to bool
      streetscape: List<String>.from(
        jsonDecode(map['streetscape']),
      ), // json string to list
      siteInfluence: map['siteInfluence'],
      siteImprovements: map['siteImprovements'],
      driveway: map['driveway'],
      builtInPast10Years: map['builtInPast10Years'] == 1, // int to bool
      propertyType: map['propertyType'],
      designStyle: map['designStyle'],
      construction: map['construction'],
      sidingType: map['sidingType'],
      roofType: map['roofType'],
      windowType: map['windowType'],
      parking: map['parking'],
      garage: map['garage'],
      occupancy: map['occupancy'],
      heatingType: map['heatingType'],
      electricalType: map['electricalType'],
      waterType: map['waterType'],
      basementType: map['basementType'],
      basementFinish: map['basementFinish'],
      foundationType: map['foundationType'],
      basementRooms: map['basementRooms'],
      basementFeatures: map['basementFeatures'],
      basementFlooring: map['basementFlooring'],
      basementCeilingType: map['basementCeilingType'],
      mainLevelRooms: map['mainLevelRooms'],
      mainLevelFeatures: map['mainLevelFeatures'],
      mainLevelFlooring: map['mainLevelFlooring'],
      secondLevelRooms: map['secondLevelRooms'],
      secondLevelFeatures: map['secondLevelFeatures'],
      secondLevelFlooring: map['secondLevelFlooring'],
      thirdLevelRooms: map['thirdLevelRooms'],
      thirdLevelFeatures: map['thirdLevelFeatures'],
      thirdLevelFlooring: map['thirdLevelFlooring'],
      fourthLevelRooms: map['fourthLevelRooms'],
      fourthLevelFeatures: map['fourthLevelFeatures'],
      fourthLevelFlooring: map['fourthLevelFlooring'],
      roofAge: map['roofAge'],
      windowAge: map['windowAge'],
      furnaceAge: map['furnaceAge'],
      kitchenAge: map['kitchenAge'],
      bathAge: map['bathAge'],
      roofNotes: map['roofNotes'],
      windowNotes: map['windowNotes'],
      kitchenNotes: map['kitchenNotes'],
      bathNotes: map['bathNotes'],
      furnaceNotes: map['furnaceNotes'],
      bankValue: map['bankValue'],
      ownerValue: map['ownerValue'],
      purchasePrice: map['purchasePrice'],
      purchaseDate: map['purchaseDate'],
      photoPaths: List<String>.from(
        jsonDecode(map['photoPaths']),
      ), // json string to list
    );
  }
}
