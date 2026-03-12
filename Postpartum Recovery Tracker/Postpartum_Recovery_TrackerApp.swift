//
//  Postpartum_Recovery_TrackerApp.swift
//  Postpartum Recovery Tracker
//
//  Created by Michelle Hunter on 3/12/26.
//

import SwiftUI
import SwiftData

@main
struct Postpartum_Recovery_TrackerApp: App {
    // Shared SwiftData container configured for MVP models
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            DailyCheckIn.self,
            SymptomEvent.self,
            Alert.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
