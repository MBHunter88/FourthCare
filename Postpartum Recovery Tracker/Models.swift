//
//  Models.swift
//  Postpartum Recovery Tracker
//
//  MVP data models for SwiftData
//

import Foundation
import SwiftData

// MARK: - Enums

enum BleedingLevel: String, Codable, CaseIterable {
    case none, light, moderate, heavy
}

enum LochiaColor: String, Codable, CaseIterable {
    case rubra, serosa, alba
}

enum SymptomType: String, Codable, CaseIterable {
    case chestPain
    case shortnessOfBreath
    case heavyBleeding
    case severeHeadache
    case legPainSwelling
    case fever
    case other
}

enum AlertLevel: String, Codable, CaseIterable {
    case info
    case attention
    case urgent
}

// MARK: - Models

@Model
final class DailyCheckIn {
    @Attribute(.unique) var id: UUID
    var date: Date
    var painScore: Int
    var bleedingLevelRaw: BleedingLevel
    var lochiaColorRaw: LochiaColor
    var moodScore: Int
    var phq2Q1: Bool
    var phq2Q2: Bool
    var temperatureF: Double?
    var notes: String?

    init(
        id: UUID = UUID(),
        date: Date,
        painScore: Int,
        bleedingLevel: BleedingLevel,
        lochiaColor: LochiaColor,
        moodScore: Int,
        phq2Q1: Bool,
        phq2Q2: Bool,
        temperatureF: Double? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.date = date
        self.painScore = painScore
        self.bleedingLevelRaw = bleedingLevel
        self.lochiaColorRaw = lochiaColor
        self.moodScore = moodScore
        self.phq2Q1 = phq2Q1
        self.phq2Q2 = phq2Q2
        self.temperatureF = temperatureF
        self.notes = notes
    }

    var bleedingLevel: BleedingLevel { bleedingLevelRaw }
    var lochiaColor: LochiaColor { lochiaColorRaw }
}

@Model
final class SymptomEvent {
    @Attribute(.unique) var id: UUID
    var timestamp: Date
    var typeRaw: SymptomType
    var notes: String?

    init(
        id: UUID = UUID(),
        timestamp: Date,
        type: SymptomType,
        notes: String? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.typeRaw = type
        self.notes = notes
    }

    var type: SymptomType { typeRaw }
}

@Model
final class Alert {
    @Attribute(.unique) var id: UUID
    var timestamp: Date
    var levelRaw: AlertLevel
    var reason: String
    var resolved: Bool

    init(
        id: UUID = UUID(),
        timestamp: Date,
        level: AlertLevel,
        reason: String,
        resolved: Bool = false
    ) {
        self.id = id
        self.timestamp = timestamp
        self.levelRaw = level
        self.reason = reason
        self.resolved = resolved
    }

    var level: AlertLevel { levelRaw }
}
