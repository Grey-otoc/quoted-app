//
//  ManageCollectionsView.swift
//  Quoted
//
//  Created by Dawson McCall on 10/31/23.
//

import CoreData
import SwiftUI

struct ManageCollectionsView: View {
    let moc: NSManagedObjectContext
    
    @State private var tabSelection = 0
    
    var body: some View {        
        TabView(selection: $tabSelection) {
            CollectionsView(moc: moc, tabSelection: $tabSelection)
                .tabItem {
                    Label("Manage", systemImage: "checklist")
                }
                .tag(0)
            
            AddCollectionView(moc: moc, tabSelection: $tabSelection)
                .tabItem {
                    Label("Add", systemImage: "plus.app.fill")
                }
                .tag(1)
        }
        .tint(.mutedWhite)
        .onAppear() {
            UITabBar.appearance().backgroundColor = UIColor(.mainGray)
            UITabBar.appearance().unselectedItemTintColor = UIColor(.mutedWhite.opacity(0.6))
        }
    }
}
