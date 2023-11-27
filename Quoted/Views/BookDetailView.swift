//
//  BookDetailView.swift
//  Quoted
//
//  Created by Dawson McCall on 10/11/23.
//

import CoreData
import SwiftUI

struct BookDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var book: Book
    let moc: NSManagedObjectContext
    
    @State private var showingAddQuoteView = false
    @State private var showingEditBookView = false
    @State private var showingDeleteAlert = false
    @State private var showingSortMenu = false
    
    @AppStorage("quoteSortMethod") private var selectedSortMethod = "Newest First"
    @State private var sortMethods = [
        "Newest First",
        "Oldest First",
        "Page Number Ascending",
        "Page Number Descending",
        "Favorites First"
    ]
    
    @State private var viewSize: CGSize = .zero
    
    var body: some View {
        let selectedColor = book.unwrappedSelectedColor.asColor
        let screenHeight = UIScreen.current?.bounds.height ?? .zero
        
        NavigationStack {
            ScrollView {
                VStack {
                    // title
                    Text(book.unwrappedTitle)
                        .foregroundStyle(selectedColor)
                        .font(.custom("Alte Haas Grotesk Bold", size: 30))
                        .padding(.leading, 3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.mutedWhite)
                        .padding(.bottom, -4)
                        .padding(.horizontal, 10)
                        .animation(.easeIn, value: book.unwrappedTitle)
                    
                    // author
                    Text(book.unwrappedAuthor)
                        .font(.headline)
                        .foregroundStyle(.mutedWhite)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                        .animation(.easeIn, value: book.unwrappedAuthor)
                    
                    Rectangle()
                        .foregroundStyle(selectedColor)
                        .frame(height: 3)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 10)
                    
                    // quote cards
                    if book.quotesArray.isEmpty {
                        VStack(alignment: .center) {
                            EmptyArrayMessage(
                                message: "Nothing to show. \nTry adding a quote!"
                            )
                        }
                        .frame(alignment: .center)
                    } else {
                        ForEach(book.quotesArray.sorted(by: { (quote1, quote2) -> Bool in
                            let method = QuoteSortingMethod(rawValue: selectedSortMethod) ?? .newestFirst
                            return method.compare(quote1, quote2)
                        }), id: \.self) { quote in
                            NavigationLink(
                                destination: QuoteDetailView(quote: quote, book: book, moc: moc),
                                label: {
                                    QuoteCard(
                                        quote: quote,
                                        selectedColor: selectedColor,
                                        moc: moc,
                                        selectedSortMethod: $selectedSortMethod
                                    )
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            deleteQuote(book, quote, moc: moc)
                                        } label: {
                                            HStack {
                                                Text("Delete")
                                                
                                                Image(systemName: "trash.fill")
                                            }
                                        }
                                        
                                        let message = "\"\(quote.unwrappedQuote)\"\n\n- \(book.unwrappedAuthor): \(book.unwrappedTitle)"
                                        ShareLink(item: message) {
                                            HStack {
                                                Text("Share")
                                                
                                                Image(systemName: "square.and.arrow.up.fill")
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 12)
                                }
                            )
                            .navigationBarTitle("", displayMode: .inline) // removes "back" text from navbar
                            .animation(.easeIn, value: quote.isFavorite)
                        }
                        .animation(.easeIn, value: selectedSortMethod)
                    }
                }
                .padding(.vertical, 15)
            }
            .frame(maxWidth: .infinity)
            .background(.mainGray)
            .toolbarBackground(selectedColor, for: .navigationBar)
            .toolbar {
                
                // navbar title
                ToolbarItem(placement: .principal) {
                    Text(book.unwrappedTitle)
                        .font(.custom("Alte Haas Grotesk Bold", size: 21))
                        .foregroundStyle(.mainGray)
                }
                
                // sort menu
                ToolbarItem(placement: .topBarTrailing) {
                    SortMenu(
                        selectedSortMethod: $selectedSortMethod,
                        sortMethods: sortMethods,
                        collectionSortNeeded: false
                    )
                    .onTapGesture {
                        showingSortMenu = true
                    }
                    .onChange(of: selectedSortMethod) {
                        showingSortMenu = false
                    }
                }
                
                // trash can button
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingDeleteAlert = true
                    } label: {
                        Image(systemName: "trash.fill")
                            .foregroundStyle(.mutedWhite)
                            .font(.headline)
                    }
                    .padding(.leading, -20)
                    .alert(
                        "Delete Book?",
                        isPresented: $showingDeleteAlert
                    ) {
                        Button(role: .cancel) {} label: {
                            Text("Cancel")
                        }
                        Button(role: .destructive) {
                            deleteBook(book, moc: moc)
                            dismiss()
                        } label: {
                            Text("Delete")
                        }
                    } message: {
                        Text("Are you sure you want to delete this book. This action cannot be undone.")
                    }
                }
            }
            .scrollIndicators(.hidden)
            
            // bottom tBar
            HStack {
                Spacer()
                
                Button("Add Quote") {
                    showingAddQuoteView = true
                }
                .padding(.vertical, screenHeight == 667.0 ? 10 : 14)
                .frame(width: viewSize.width * 0.32)
                .background(.mutedWhite)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.bottom, screenHeight == 667.0 ? 15 : 0)
                .padding(.top, 8)
                
                Spacer()
                
                Button("Edit Book") {
                    showingEditBookView = true
                }
                .padding(.vertical, screenHeight == 667.0 ? 10 : 14)
                .frame(width: viewSize.width * 0.32)
                .background(.mutedWhite)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.bottom, screenHeight == 667.0 ? 15 : 0)
                .padding(.top, 8)
                
                Spacer()
            }
            .foregroundStyle(.mainGray)
            .font(.custom("Helvetica Neue Bold", size: 18, relativeTo: .body))
            .frame(width: viewSize.width * 1, height: viewSize.height * 0.08)
            .sheet(isPresented: $showingAddQuoteView) {
                AddQuoteView(book: book, moc: moc, selectedColor: selectedColor)
            }
            .sheet(isPresented: $showingEditBookView) {
                EditBookView(book: book, moc: moc)
            }
        }
        .background(selectedColor)
        .overlay {
            if showingSortMenu {
                FocusedOverlay()
                    .onTapGesture {
                    showingSortMenu = false
                    }
            }
        }
        .animation(.easeIn, value: selectedColor)
        .readSize { newSize in
            viewSize = newSize
        }
    }
}
