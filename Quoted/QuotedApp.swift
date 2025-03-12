//
//  QuotedApp.swift
//  Quoted
//
//  Created by Dawson McCall on 10/6/23.
//

import SwiftUI

@main
struct QuotedApp: App {
    let persistentContainer = DataController.shared.persistentContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
