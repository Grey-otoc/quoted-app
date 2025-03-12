//
//  AddQuoteView.swift
//  Quoted
//
//  Created by Dawson McCall on 10/12/23.
//

import CoreData
import SwiftUI
import UIKit

struct AddQuoteView: View {
    let book: Book
    let moc: NSManagedObjectContext
    let selectedColor: Color
    
    @State private var tabSelection = 0
    @State private var scannedText = ""
    
    var body: some View {
        TabView(selection: $tabSelection) {
            WriteView(book: book, moc: moc, selectedColor: selectedColor, tabSelection: $tabSelection, scannedText: $scannedText)
                .tabItem {
                    Label("Write", systemImage: "square.and.pencil")
                }
                .tag(0)
            
            ScanView(book: book, moc: moc, selectedColor: selectedColor, tabSelection: $tabSelection, scannedText: $scannedText)
                .tabItem {
                    Label("Scan", systemImage: "text.viewfinder")
                }
                .tag(1)
        }
        .tint(.mutedWhite)
        .onAppear() {
            UITabBar.appearance().backgroundColor = UIColor(selectedColor)
            UITabBar.appearance().unselectedItemTintColor = UIColor(.mutedWhite.opacity(0.6))
        }
    }
}
