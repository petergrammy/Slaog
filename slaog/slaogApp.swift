//
//  slaogApp.swift
//  slaog
//
//  Created by 董梓涵 on 2025/3/25.
//

import SwiftUI

@main
struct slaogApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
