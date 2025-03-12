//
//  SelectCollectionsView.swift
//  Quoted
//
//  Created by Dawson McCall on 11/2/23.
//

import CoreData
import SwiftUI

struct SelectCollectionsView: View {
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var collections: FetchedResults<Collection>
    
    @Binding var selectedCollections: [Collection]
    let moc: NSManagedObjectContext
    
    @State private var showingAddCollectionView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // if no collections to show
                if collections.isEmpty {
                    EmptyArrayMessage(
                        message: "No collections to add to."
                    )
                    
                    Spacer()
                } else {
                    // selectable collections list
                    List(collections, id: \.self) { collection in
                        SelectableListRowCollections(collection: collection, selectedCollections: $selectedCollections)
                            .listRowBackground(Color.mutedWhite)
                            .onTapGesture {
                                print(selectedCollections)
                            }
                    }
                    .scrollContentBackground(.hidden)
                    .padding(.top, -26)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.mainGray)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            // navbar title
            ToolbarItem(placement: .principal) {
                Text("Select Collections")
                    .font(.custom("Alte Haas Grotesk Bold", size: 20))
                    .foregroundStyle(.mutedWhite)
            }
            
            // add button
            ToolbarItem(placement: .topBarTrailing) {
                Button() {
                    showingAddCollectionView = true
                } label: {
                    Text("Add")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.mutedWhite)
                }
                .sheet(isPresented: $showingAddCollectionView) {
                    AddCollectionView(moc: moc)
                }
            }
        }
    }
}
