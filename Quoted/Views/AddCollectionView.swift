//
//  AddCollectionView.swift
//  Quoted
//
//  Created by Dawson McCall on 10/27/23.
//

import CoreData
import SwiftUI

struct AddCollectionView: View {
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)]) var books: FetchedResults<Book>
    let moc: NSManagedObjectContext
    var tabSelection: Binding<Int>? = nil
    
    @State private var name = ""
    @State private var selectedBooks: [Book] = []
    @FocusState private var txtField
    @State private var showingAddedAlert = false
    
    private var isSaveEnabled: Bool {
        if name == "None" || name == "none"{
            return false
        } else {
            let trimmedName = name.trimmingCharacters(in: .whitespaces)
            return !trimmedName.isEmpty
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    // collection name
                    AddBookTextField(
                        headline: "Collection Name",
                        mainInfo: $name,
                        placeholder: ContentView.chosenTempGenre ?? "Fiction",
                        selectedColor: .mainGray,
                        needsNumpad: false
                    )
                    .focused($txtField)
                    
                    Rectangle()
                        .frame(maxWidth:.infinity)
                        .frame(height: 5)
                        .foregroundStyle(.mutedWhite)
                        .padding(15)
                }
                .padding(.top, 10)
                .padding(.bottom, -28)
                
                // book selectable list
                if books.isEmpty {
                    EmptyArrayMessage(
                        message: "No books to add to collection."
                    )
                } else {
                    List(books, id: \.self) { book in
                        SelectableListRow(book: book, selectedBooks: $selectedBooks)
                            .listRowBackground(Color.mutedWhite)
                    }
                    .scrollContentBackground(.hidden)
                    .padding(.bottom, -6.5)
                }
                
                Spacer()
    
                if tabSelection != nil {
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 8)
                        .foregroundStyle(.black)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.mainGray)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                // navbar title
                ToolbarItem(placement: .principal) {
                    Text("Add a Collection")
                        .font(.custom("Alte Haas Grotesk Bold", size: 20))
                        .foregroundStyle(.mutedWhite)
                }
                
                // dismiss button
                ToolbarItem(placement: .topBarLeading) {
                    Button() {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .foregroundStyle(.mutedWhite)
                    .font(.title2)
                }
                
                // save button
                ToolbarItem(placement: .topBarTrailing) {
                    Button() {
                        saveCollection(selectedBooks, moc: moc, name: name)
                        name = ""
                        selectedBooks = []
                        txtField = false
                        
                        if tabSelection != nil {
                            showingAddedAlert = true
                        } else {
                            dismiss()
                        }
                    } label: {
                        Text("Save")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(isSaveEnabled ? .mutedWhite : .mutedWhite.opacity(0.40))
                    }
                    .disabled(!isSaveEnabled)
                }
            }
            .alert(
                "Added Collection.",
                isPresented: $showingAddedAlert
            ) {
                Button(role: .cancel) {} label: {
                    Text("Ok")
                }
            }
        }
        .background(.mainGray)
    }
}
