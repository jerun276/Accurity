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
      'client_file_number': clientFileNumber,
      'firm_file_number': firmFileNumber,
      'address': address,
      'applicant_name': applicantName,
      'appointment': appointment,
      'client': client,
      'lender': lender,
      'service_type': serviceType,
      'loan_type': loanType,
      'contact_name': contactName,
      'contact_email': contactEmail,
      'contact_phone1': contactPhone1,
      'contact_phone2': contactPhone2,
      'nature_of_district': natureOfDistrict,
      'development_type': developmentType,
      'configuration': configuration,
      'topography': topography,
      'water_supply_type': waterSupplyType,
      'streetscape': streetscape,
      'site_influence': siteInfluence,
      'site_improvements': siteImprovements,
      'driveway': driveway,
      'parking': parking,
      'occupancy': occupancy,
      'built_in_past_10_years': builtInPast10Years ? 1 : 0,
      'property_type': propertyType,
      'design_style': designStyle,
      'construction': construction,
      'siding_type': jsonEncode(sidingType),
      'roof_type': jsonEncode(roofType),
      'window_type': jsonEncode(windowType),
      'heating_type': jsonEncode(heatingType),
      'electrical_type': jsonEncode(electricalType),
      'water_type': jsonEncode(waterType),
      'basement_type': basementType,
      'basement_finish': basementFinish,
      'foundation_type': jsonEncode(foundationType),
      'basement_rooms': basementRooms,
      'basement_features': jsonEncode(basementFeatures),
      'basement_flooring': basementFlooring,
      'basement_ceiling_type': jsonEncode(basementCeilingType),
      'main_level_rooms': mainLevelRooms,
      'main_level_features': jsonEncode(mainLevelFeatures),
      'main_level_flooring': mainLevelFlooring,
      'second_level_rooms': secondLevelRooms,
      'second_level_features': jsonEncode(secondLevelFeatures),
      'second_level_flooring': secondLevelFlooring,
      'third_level_rooms': thirdLevelRooms,
      'third_level_features': jsonEncode(thirdLevelFeatures),
      'third_level_flooring': thirdLevelFlooring,
      'fourth_level_rooms': fourthLevelRooms,
      'fourth_level_features': jsonEncode(fourthLevelFeatures),
      'fourth_level_flooring': fourthLevelFlooring,
      'roof_age': roofAge,
      'window_age': windowAge,
      'furnace_age': furnaceAge,
      'kitchen_age': kitchenAge,
      'bath_age': bathAge,
      'roof_notes': roofNotes,
      'window_notes': windowNotes,
      'kitchen_notes': kitchenNotes,
      'bath_notes': bathNotes,
      'furnace_notes': furnaceNotes,
      'bank_value': bankValue,
      'owner_value': ownerValue,
      'purchase_price': purchasePrice,
      'purchase_date': purchaseDate,
      'photo_paths': jsonEncode(photoPaths),
    };
  }

  Map<String, dynamic> toSupabaseMap() {
    return {
      // 'localId' is NOT included
      // 'supabaseId' is NOT included (Supabase handles its own ID)
      // 'syncStatus' is NOT included
      'client_file_number': clientFileNumber,
      'firm_file_number': firmFileNumber,
      'address': address,
      'applicant_name': applicantName,
      'appointment': appointment,
      'client': client,
      'lender': lender,
      'service_type': serviceType,
      'loan_type': loanType,
      'contact_name': contactName,
      'contact_email': contactEmail,
      'contact_phone1': contactPhone1,
      'contact_phone2': contactPhone2,
      'nature_of_district': natureOfDistrict,
      'development_type': developmentType,
      'configuration': configuration,
      'topography': topography,
      'water_supply_type': waterSupplyType,
      'streetscape': streetscape,
      'site_influence': siteInfluence,
      'site_improvements': siteImprovements,
      'driveway': driveway,
      'parking': parking,
      'occupancy': occupancy,
      'built_in_past_10_years': builtInPast10Years, // Supabase can handle bools directly
      'property_type': propertyType,
      'design_style': designStyle,
      'construction': construction,
      'siding_type': sidingType, // Supabase can handle lists directly (as jsonb)
      'roof_type': roofType,
      'window_type': windowType,
      'heating_type': heatingType,
      'electrical_type': electricalType,
      'water_type': waterType,
      'basement_type': basementType,
      'basement_finish': basementFinish,
      'foundation_type': foundationType,
      'basement_rooms': basementRooms,
      'basement_features': basementFeatures,
      'basement_flooring': basementFlooring,
      'basement_ceiling_type': basementCeilingType,
      'main_level_rooms': mainLevelRooms,
      'main_level_features': mainLevelFeatures,
      'main_level_flooring': mainLevelFlooring,
      'second_level_rooms': secondLevelRooms,
      'second_level_features': secondLevelFeatures,
      'second_level_flooring': secondLevelFlooring,
      'third_level_rooms': thirdLevelRooms,
      'third_level_features': thirdLevelFeatures,
      'third_level_flooring': thirdLevelFlooring,
      'fourth_level_rooms': fourthLevelRooms,
      'fourth_level_features': fourthLevelFeatures,
      'fourth_level_flooring': fourthLevelFlooring,
      'roof_age': roofAge,
      'window_age': windowAge,
      'furnace_age': furnaceAge,
      'kitchen_age': kitchenAge,
      'bath_age': bathAge,
      'roof_notes': roofNotes,
      'window_notes': windowNotes,
      'kitchen_notes': kitchenNotes,
      'bath_notes': bathNotes,
      'furnace_notes': furnaceNotes,
      'bank_value': bankValue,
      'owner_value': ownerValue,
      'purchase_price': purchasePrice,
      'purchase_date': purchaseDate,
      'photo_paths': photoPaths,
    };
  }

  factory Order.fromDbMap(Map<String, dynamic> map) {
    return Order(
      localId: map['localId'],
      supabaseId:
          map['supabaseId'] ?? map['id'], // Supabase uses 'id' for primary key
      syncStatus: SyncStatus.values.firstWhere(
        (e) => e.name == map['syncStatus'],
        orElse: () => SyncStatus.synced,
      ),
      clientFileNumber: map['client_file_number'],
      firmFileNumber: map['firm_file_number'],
      address: map['address'],
      applicantName: map['applicant_name'],
      appointment: map['appointment'],
      client: map['client'],
      lender: map['lender'],
      serviceType: map['service_type'],
      loanType: map['loan_type'],
      contactName: map['contact_name'],
      contactEmail: map['contact_email'],
      contactPhone1: map['contact_phone1'],
      contactPhone2: map['contact_phone2'],
      natureOfDistrict: map['nature_of_district'],
      developmentType: map['development_type'],
      configuration: map['configuration'],
      topography: map['topography'],
      waterSupplyType: map['water_supply_type'],
      streetscape: map['streetscape'],
      siteInfluence: map['site_influence'],
      siteImprovements: map['site_improvements'],
      driveway: map['driveway'],
      parking: map['parking'],
      occupancy: map['occupancy'],
      builtInPast10Years: (map['built_in_past_10_years'] is bool)
          ? map['built_in_past_10_years']
          : map['built_in_past_10_years'] == 1,
      propertyType: map['property_type'],
      designStyle: map['design_style'],
      construction: map['construction'],
      sidingType: List<String>.from(jsonDecode(map['siding_type'])),
      roofType: List<String>.from(jsonDecode(map['roof_type'])),
      windowType: List<String>.from(jsonDecode(map['window_type'])),
      heatingType: List<String>.from(jsonDecode(map['heating_type'])),
      electricalType: List<String>.from(jsonDecode(map['electrical_type'])),
      waterType: List<String>.from(jsonDecode(map['water_type'])),
      basementType: map['basement_type'],
      basementFinish: map['basement_finish'],
      foundationType: List<String>.from(jsonDecode(map['foundation_type'])),
      basementRooms: map['basement_rooms'],
      basementFeatures: List<String>.from(jsonDecode(map['basement_features'])),
      basementFlooring: map['basement_flooring'],
      basementCeilingType: List<String>.from(
        jsonDecode(map['basement_ceiling_type']),
      ),
      mainLevelRooms: map['main_level_rooms'],
      mainLevelFeatures: List<String>.from(
        jsonDecode(map['main_level_features']),
      ),
      mainLevelFlooring: map['main_level_flooring'],
      secondLevelRooms: map['second_level_rooms'],
      secondLevelFeatures: List<String>.from(
        jsonDecode(map['second_level_features']),
      ),
      secondLevelFlooring: map['second_level_flooring'],
      thirdLevelRooms: map['third_level_rooms'],
      thirdLevelFeatures: List<String>.from(
        jsonDecode(map['third_level_features']),
      ),
      thirdLevelFlooring: map['third_level_flooring'],
      fourthLevelRooms: map['fourth_level_rooms'],
      fourthLevelFeatures: List<String>.from(
        jsonDecode(map['fourth_level_features']),
      ),
      fourthLevelFlooring: map['fourth_level_flooring'],
      roofAge: map['roof_age'],
      windowAge: map['window_age'],
      furnaceAge: map['furnace_age'],
      kitchenAge: map['kitchen_age'],
      bathAge: map['bath_age'],
      roofNotes: map['roof_notes'],
      windowNotes: map['window_notes'],
      kitchenNotes: map['kitchen_notes'],
      bathNotes: map['bath_notes'],
      furnaceNotes: map['furnace_notes'],
      bankValue: map['bank_value'],
      ownerValue: map['owner_value'],
      purchasePrice: map['purchase_price'],
      purchaseDate: map['purchase_date'],
      photoPaths: List<String>.from(jsonDecode(map['photo_paths'])),
    );
  }
}
