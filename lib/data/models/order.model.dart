import 'dart:convert';
import 'sync_status.enum.dart';

class Order {
  // --- DATABASE & SYNC MANAGEMENT ---
  final int? localId;
  final String? supabaseId;
  final SyncStatus syncStatus;

  // --- ORDER DETAILS (NEW FIELDS ADDED) ---
  final String? clientFileNumber;
  final String? firmFileNumber;
  final String? address;
  final String? applicantName;
  final String? appointment;
  final String? client;
  final String? lender;
  final String? serviceType;
  final String? loanType;
  final String? contactName;
  final String? contactEmail;
  final String? contactPhone1;
  final String? contactPhone2;

  // --- NEIGHBOURHOOD ---
  final String? natureOfDistrict;
  final String? developmentType;

  // --- SITE ---
  final String? configuration;
  final String? topography;
  final String? waterSupplyType;
  final String? streetscape;
  final String? siteInfluence;
  final String? siteImprovements;
  final String? driveway;
  final String? parking;
  final String? occupancy;

  // --- STRUCTURAL DETAILS (TYPES CHANGED) ---
  final bool builtInPast10Years;
  final String? propertyType;
  final String? designStyle;
  final String? construction;
  final List<String> sidingType;
  final List<String> roofType;
  final List<String> windowType;

  // --- MECHANICAL (TYPES CHANGED) ---
  final List<String> heatingType;
  final List<String> electricalType;
  final List<String> waterType;

  // --- BASEMENT (TYPES CHANGED) ---
  final String? basementType;
  final String? basementFinish;
  final List<String> foundationType;
  final String? basementRooms;
  final List<String> basementFeatures;
  final String? basementFlooring;
  final List<String> basementCeilingType;

  // --- LEVEL DETAILS (TYPES CHANGED) ---
  final String? mainLevelRooms;
  final List<String> mainLevelFeatures;
  final String? mainLevelFlooring;
  final String? secondLevelRooms;
  final List<String> secondLevelFeatures;
  final String? secondLevelFlooring;
  final String? thirdLevelRooms;
  final List<String> thirdLevelFeatures;
  final String? thirdLevelFlooring;
  final String? fourthLevelRooms;
  final List<String> fourthLevelFeatures;
  final String? fourthLevelFlooring;

  // --- Other fields are unchanged ---
  final String? roofAge, windowAge, furnaceAge, kitchenAge, bathAge;
  final String? roofNotes, windowNotes, kitchenNotes, bathNotes, furnaceNotes;
  final String? bankValue, ownerValue, purchasePrice, purchaseDate;
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
    this.contactName,
    this.contactEmail,
    this.contactPhone1,
    this.contactPhone2,
    // Neighbourhood
    this.natureOfDistrict,
    this.developmentType,
    // Site
    this.configuration,
    this.topography,
    this.waterSupplyType,
    this.streetscape,
    this.siteInfluence,
    this.siteImprovements,
    this.driveway,
    this.parking,
    this.occupancy,
    // Structural Details
    this.builtInPast10Years = false,
    this.propertyType,
    this.designStyle,
    this.construction,
    this.sidingType = const [],
    this.roofType = const [],
    this.windowType = const [],
    // Mechanical
    this.heatingType = const [],
    this.electricalType = const [],
    this.waterType = const [],
    // Basement
    this.basementType,
    this.basementFinish,
    this.foundationType = const [],
    this.basementRooms,
    this.basementFeatures = const [],
    this.basementFlooring,
    this.basementCeilingType = const [],
    // Levels
    this.mainLevelRooms,
    this.mainLevelFeatures = const [],
    this.mainLevelFlooring,
    this.secondLevelRooms,
    this.secondLevelFeatures = const [],
    this.secondLevelFlooring,
    this.thirdLevelRooms,
    this.thirdLevelFeatures = const [],
    this.thirdLevelFlooring,
    this.fourthLevelRooms,
    this.fourthLevelFeatures = const [],
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

  // copyWith method is now updated for all the new and changed fields
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
    String? contactName,
    String? contactEmail,
    String? contactPhone1,
    String? contactPhone2,
    String? natureOfDistrict,
    String? developmentType,
    String? configuration,
    String? topography,
    String? waterSupplyType,
    String? streetscape,
    String? siteInfluence,
    String? siteImprovements,
    String? driveway,
    String? parking,
    String? occupancy,
    bool? builtInPast10Years,
    String? propertyType,
    String? designStyle,
    String? construction,
    List<String>? sidingType,
    List<String>? roofType,
    List<String>? windowType,
    List<String>? heatingType,
    List<String>? electricalType,
    List<String>? waterType,
    String? basementType,
    String? basementFinish,
    List<String>? foundationType,
    String? basementRooms,
    List<String>? basementFeatures,
    String? basementFlooring,
    List<String>? basementCeilingType,
    String? mainLevelRooms,
    List<String>? mainLevelFeatures,
    String? mainLevelFlooring,
    String? secondLevelRooms,
    List<String>? secondLevelFeatures,
    String? secondLevelFlooring,
    String? thirdLevelRooms,
    List<String>? thirdLevelFeatures,
    String? thirdLevelFlooring,
    String? fourthLevelRooms,
    List<String>? fourthLevelFeatures,
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
      contactName: contactName ?? this.contactName,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone1: contactPhone1 ?? this.contactPhone1,
      contactPhone2: contactPhone2 ?? this.contactPhone2,
      natureOfDistrict: natureOfDistrict ?? this.natureOfDistrict,
      developmentType: developmentType ?? this.developmentType,
      configuration: configuration ?? this.configuration,
      topography: topography ?? this.topography,
      waterSupplyType: waterSupplyType ?? this.waterSupplyType,
      streetscape: streetscape ?? this.streetscape,
      siteInfluence: siteInfluence ?? this.siteInfluence,
      siteImprovements: siteImprovements ?? this.siteImprovements,
      driveway: driveway ?? this.driveway,
      parking: parking ?? this.parking,
      occupancy: occupancy ?? this.occupancy,
      builtInPast10Years: builtInPast10Years ?? this.builtInPast10Years,
      propertyType: propertyType ?? this.propertyType,
      designStyle: designStyle ?? this.designStyle,
      construction: construction ?? this.construction,
      sidingType: sidingType ?? this.sidingType,
      roofType: roofType ?? this.roofType,
      windowType: windowType ?? this.windowType,
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

  // toDbMap and fromDbMap methods are now updated
  Map<String, dynamic> toDbMap() {
    return {
      'localId': localId,
      'supabaseId': supabaseId,
      'syncStatus': syncStatus.name,
      'clientFileNumber': clientFileNumber,
      'firmFileNumber': firmFileNumber,
      'address': address,
      'applicantName': applicantName,
      'appointment': appointment,
      'client': client,
      'lender': lender,
      'serviceType': serviceType,
      'loanType': loanType,
      'contactName': contactName,
      'contactEmail': contactEmail,
      'contactPhone1': contactPhone1,
      'contactPhone2': contactPhone2,
      'natureOfDistrict': natureOfDistrict,
      'developmentType': developmentType,
      'configuration': configuration,
      'topography': topography,
      'waterSupplyType': waterSupplyType,
      'streetscape': streetscape,
      'siteInfluence': siteInfluence,
      'siteImprovements': siteImprovements,
      'driveway': driveway,
      'parking': parking,
      'occupancy': occupancy,
      'builtInPast10Years': builtInPast10Years ? 1 : 0,
      'propertyType': propertyType,
      'designStyle': designStyle,
      'construction': construction,
      'sidingType': jsonEncode(sidingType),
      'roofType': jsonEncode(roofType),
      'windowType': jsonEncode(windowType),
      'heatingType': jsonEncode(heatingType),
      'electricalType': jsonEncode(electricalType),
      'waterType': jsonEncode(waterType),
      'basementType': basementType,
      'basementFinish': basementFinish,
      'foundationType': jsonEncode(foundationType),
      'basementRooms': basementRooms,
      'basementFeatures': jsonEncode(basementFeatures),
      'basementFlooring': basementFlooring,
      'basementCeilingType': jsonEncode(basementCeilingType),
      'mainLevelRooms': mainLevelRooms,
      'mainLevelFeatures': jsonEncode(mainLevelFeatures),
      'mainLevelFlooring': mainLevelFlooring,
      'secondLevelRooms': secondLevelRooms,
      'secondLevelFeatures': jsonEncode(secondLevelFeatures),
      'secondLevelFlooring': secondLevelFlooring,
      'thirdLevelRooms': thirdLevelRooms,
      'thirdLevelFeatures': jsonEncode(thirdLevelFeatures),
      'thirdLevelFlooring': thirdLevelFlooring,
      'fourthLevelRooms': fourthLevelRooms,
      'fourthLevelFeatures': jsonEncode(fourthLevelFeatures),
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
      'photoPaths': jsonEncode(photoPaths),
    };
  }

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
      contactName: map['contactName'],
      contactEmail: map['contactEmail'],
      contactPhone1: map['contactPhone1'],
      contactPhone2: map['contactPhone2'],
      natureOfDistrict: map['natureOfDistrict'],
      developmentType: map['developmentType'],
      configuration: map['configuration'],
      topography: map['topography'],
      waterSupplyType: map['waterSupplyType'],
      streetscape: map['streetscape'],
      siteInfluence: map['siteInfluence'],
      siteImprovements: map['siteImprovements'],
      driveway: map['driveway'],
      parking: map['parking'],
      occupancy: map['occupancy'],
      builtInPast10Years: map['builtInPast10Years'] == 1,
      propertyType: map['propertyType'],
      designStyle: map['designStyle'],
      construction: map['construction'],
      sidingType: List<String>.from(jsonDecode(map['sidingType'])),
      roofType: List<String>.from(jsonDecode(map['roofType'])),
      windowType: List<String>.from(jsonDecode(map['windowType'])),
      heatingType: List<String>.from(jsonDecode(map['heatingType'])),
      electricalType: List<String>.from(jsonDecode(map['electricalType'])),
      waterType: List<String>.from(jsonDecode(map['waterType'])),
      basementType: map['basementType'],
      basementFinish: map['basementFinish'],
      foundationType: List<String>.from(jsonDecode(map['foundationType'])),
      basementRooms: map['basementRooms'],
      basementFeatures: List<String>.from(jsonDecode(map['basementFeatures'])),
      basementFlooring: map['basementFlooring'],
      basementCeilingType: List<String>.from(
        jsonDecode(map['basementCeilingType']),
      ),
      mainLevelRooms: map['mainLevelRooms'],
      mainLevelFeatures: List<String>.from(
        jsonDecode(map['mainLevelFeatures']),
      ),
      mainLevelFlooring: map['mainLevelFlooring'],
      secondLevelRooms: map['secondLevelRooms'],
      secondLevelFeatures: List<String>.from(
        jsonDecode(map['secondLevelFeatures']),
      ),
      secondLevelFlooring: map['secondLevelFlooring'],
      thirdLevelRooms: map['thirdLevelRooms'],
      thirdLevelFeatures: List<String>.from(
        jsonDecode(map['thirdLevelFeatures']),
      ),
      thirdLevelFlooring: map['thirdLevelFlooring'],
      fourthLevelRooms: map['fourthLevelRooms'],
      fourthLevelFeatures: List<String>.from(
        jsonDecode(map['fourthLevelFeatures']),
      ),
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
      photoPaths: List<String>.from(jsonDecode(map['photoPaths'])),
    );
  }
}
