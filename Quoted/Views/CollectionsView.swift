//
//  CollectionsView.swift
//  Quoted
//
//  Created by Dawson McCall on 10/31/23.
//

import CoreData
import SwiftUI

struct CollectionsView: View {
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var collections: FetchedResults<Collection>
    let moc: NSManagedObjectContext
    @Binding var tabSelection: Int
    
    @State private var name = ""
    @State private var selectedBooks: [Book] = []
    
    @State private var viewSize: CGSize = .zero
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    // if no collections to show
                    if collections.isEmpty {
                        EmptyArrayMessage(
                            message: "Nothing to show.\nTry adding a collection!"
                        )
                    } else {
                        // collection cards
                        ForEach(collections, id: \.self) { collection in
                            NavigationLink(
                                destination: EditCollectionView(collection: collection, moc: moc),
                                label: {
                                    HStack {
                                        Rectangle()
                                            .frame(width: 5)
                                            .background(.mutedWhite)
                                            .padding(.trailing, 2)
                                        
                                        Text(collection.unwrappedName)
                                            .animation(.easeIn, value: collection.name)
                                            .font(.custom("Alte Haas Grotesk Bold", size: 24))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.forward")
                                            .font(.title3)
                                    }
                                    .foregroundStyle(.mutedWhite)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: viewSize.height * 0.09)
                                    .background(.mutedWhite.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .padding(.horizontal, 12)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            deleteCollection(collection, moc: moc)
                                        } label: {
                                            HStack {
                                                Text("Delete")
                                                
                                                Image(systemName: "trash.fill")
                                            }
                                        }
                                    }
                                }
                            )
                            .navigationBarTitle("", displayMode: .inline)
                        }
                        .padding(.top, 10)
                    }
                }
                .scrollIndicators(.hidden)
                
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
                    Text("Manage Collections")
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
                
                // add button
                ToolbarItem(placement: .topBarTrailing) {
                    Button() {
                        tabSelection = 1
                    } label: {
                        Text("Add")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.mutedWhite)
                    }
                }
            }
        }
        .background(.mainGray)
        .readSize { newSize in
            viewSize = newSize
        }
    }
}
