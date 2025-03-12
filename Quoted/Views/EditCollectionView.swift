//
//  EditCollectionView.swift
//  Quoted
//
//  Created by Dawson McCall on 10/31/23.
//

import CoreData
import SwiftUI

struct EditCollectionView: View {
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)]) var books: FetchedResults<Book>
    let collection: Collection
    let moc: NSManagedObjectContext
    
    @State private var name = ""
    @State private var selectedBooks: [Book] = []
    @State private var showingDeleteAlert = false
    @State private var deleted = false
    
    private var isUpdateEnabled: Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        return !trimmedName.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    // collection name
                    AddBookTextField(
                        headline: "Collection Name",
                        mainInfo: $name,
                        placeholder: "Romance",
                        selectedColor: .mainGray,
                        needsNumpad: false
                    )
                    
                    Rectangle()
                        .frame(maxWidth:.infinity)
                        .frame(height: 5)
                        .foregroundStyle(.mutedWhite)
                        .padding(15)
                }
                .padding(.top, 10)
                .padding(.bottom, -28)
                
                // selectable books list
                List(books, id: \.self) { book in
                    SelectableListRow(book: book, selectedBooks: $selectedBooks)
                        .listRowBackground(Color.mutedWhite)
                }
                .scrollContentBackground(.hidden)
                .padding(.bottom, -6.5)
                
                Spacer()
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 8)
                    .foregroundStyle(.black)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.mainGray)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                // navbar title
                ToolbarItem(placement: .principal) {
                    Text("Edit Collection")
                        .font(.custom("Alte Haas Grotesk Bold", size: 20))
                        .foregroundStyle(.mutedWhite)
                }
                
                // delete button
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingDeleteAlert = true
                    } label: {
                        Image(systemName: "trash.fill")
                            .foregroundStyle(.mutedWhite)
                            .font(.headline)
                    }
                    .alert(
                        "Delete Collection?",
                        isPresented: $showingDeleteAlert
                    ) {
                        Button(role: .cancel) {} label: {
                            Text("Cancel")
                        }
                        Button(role: .destructive) {
                            deleted = true
                            deleteCollection(collection, moc: moc)
                            dismiss()
                        } label: {
                            Text("Delete")
                        }
                    } message: {
                        Text("Are you sure you want to delete this collection. This action cannot be undone.")
                    }
                }
            }
        }
        .background(.mainGray)
        .onAppear {
            name = collection.unwrappedName
            selectedBooks = collection.booksArray
        }
        .onDisappear {
            if deleted == false {
                editCollection(selectedBooks, moc: moc, name: name, collection: collection)
            }
        }
    }
}

