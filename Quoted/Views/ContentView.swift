//
//  ContentView.swift
//  Quoted
//
//  Created by Dawson McCall on 10/6/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var collections: FetchedResults<Collection>
    
    var request = FetchRequest<Book>(sortDescriptors: [], predicate: NSPredicate(value: false))
    var books: FetchedResults<Book> {
        if selectedCollection == "None" {
            request.wrappedValue.nsPredicate = nil
        } else {
            request.wrappedValue.nsPredicate = NSPredicate(format: "ANY collections.name == %@", selectedCollection)
        }
        
        request.wrappedValue.sortDescriptors = []
        return request.wrappedValue
    }
    
    @State private var showingAddBookView = false
    @State private var showingManageCollectionsView = false
    @State private var showingDeleteAlert = false
    @State private var showingSortMenu = false
    
    @AppStorage("selectedSortMethod") private var selectedSortMethod = "Newest First"
    @State private var sortMethods = [
        "Newest First",
        "Oldest First",
        "Title Ascending",
        "Title Descending",
        "Author Ascending",
        "Author Descending",
        "Favorites First",
        "Page Count Ascending",
        "Page Count Descending"
    ]
    @AppStorage("selectedCollection") private var selectedCollection = "None"
    
    static let chosenTempBook = TempArrays.tempBooks[Int.random(in: 0..<TempArrays.tempBooks.count)]
    static let chosenTempGenre = TempArrays.tempGenres.randomElement()
    
    @State private var viewSize: CGSize = .zero
    
    var body: some View {
        let screenHeight = UIScreen.current?.bounds.height ?? .zero
        
        NavigationStack {
            ScrollView {
                VStack(spacing: 13) {
                    // if no books or collections to show
                    if selectedCollection == "None" && books.isEmpty {
                        EmptyArrayMessage(
                            message: "Nothing to show.\nTry adding a book!"
                        )
                    } else if selectedCollection != "None" && books.isEmpty {
                        EmptyArrayMessage(
                            message: "Nothing in collection.\nTry adding a book!"
                        )
                    } else {
                        // array of book cards
                        ForEach(books.sorted(by: { (book1, book2) -> Bool in
                            let method = BookSortingMethod(rawValue: selectedSortMethod) ?? .newestFirst
                            return method.compare(book1, book2)
                        }), id: \.self) { book in
                            NavigationLink(
                                destination: BookDetailView(book: book, moc: moc),
                                label: {
                                    BookCard(
                                        book: book,
                                        selectedSortMethod: $selectedSortMethod,
                                        moc: moc,
                                        author: book.unwrappedAuthor,
                                        title: book.unwrappedTitle,
                                        pageCount: book.unwrappedPageCount,
                                        quoteCount: book.quoteCount,
                                        dateStarted: book.dateStarted ?? Date.now,
                                        dateFinished: book.dateFinished ?? nil,
                                        selectedColor: book.unwrappedSelectedColor.asColor
                                    )
                                    .contextMenu {                                        
                                        Button(role: .destructive) {
                                            deleteBook(book, moc: moc)
                                        } label: {
                                            HStack {
                                                Text("Delete")
                                                
                                                Image(systemName: "trash.fill")
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            )
                            .navigationBarTitle("", displayMode: .inline)
                            .animation(.easeIn, value: book.isFavorite)
                        }
                        .animation(.easeIn, value: selectedSortMethod)
                        .animation(.easeOut, value: selectedCollection)
                    }
                }
                .padding(.vertical, 15)
            }
            .frame(maxWidth: .infinity)
            .background(.mainGray)
            .toolbar {
                // logo
                ToolbarItem(placement: .topBarLeading) {
                    Image("LogoPNG")
                        .resizable()
                        .frame(width: viewSize.width * 0.115, height: viewSize.width * 0.115)
                        .scaledToFit()
                }
                
                // sort menu
                ToolbarItem(placement: .topBarTrailing) {
                    SortMenu(
                        selectedSortMethod: $selectedSortMethod,
                        selectedCollection: $selectedCollection,
                        sortMethods: sortMethods,
                        collectionSortNeeded: true
                    )
                    .onTapGesture {
                        showingSortMenu = true
                    }
                    .onChange(of: selectedSortMethod) {
                        showingSortMenu = false
                    }
                    .onChange(of: selectedCollection) {
                        showingSortMenu = false
                    }
                }
                
                // settings/info menu
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(
                        destination: InfoSettingsView(),
                        label: {
                            Image(systemName: "info.square.fill")
                                .foregroundStyle(.mutedWhite)
                                .font(.headline)
                                .padding(.leading, -20)
                        }
                    )
                }
            }
            .scrollIndicators(.hidden)

            // bottom tbar
            HStack(alignment: .center) {
                Spacer()
                
                Button("Add Book") {
                    showingAddBookView = true
                }
                .padding(.vertical, screenHeight == 667.0 ? 10 : 14)
                .frame(width: viewSize.width * 0.32)
                .background(.mutedWhite)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.bottom, screenHeight == 667.0 ? 15 : 0)
                .padding(.top, 15)
                
                Spacer()
                
                Button("Collections") {
                    showingManageCollectionsView = true
                }
                .padding(.vertical, screenHeight == 667.0 ? 10 : 14)
                .frame(width: viewSize.width * 0.32)
                .background(.mutedWhite)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.bottom, screenHeight == 667.0 ? 15 : 0)
                .padding(.top, 15)
                
                Spacer()
            }
            .foregroundStyle(.mainGray)
            .font(.custom("Helvetica Neue Bold", size: 18.5, relativeTo: .body))
            .frame(width: viewSize.width * 1, height: viewSize.height * 0.08)
            .sheet(isPresented: $showingAddBookView) {
                AddBookView(moc: moc)
            }
            .sheet(isPresented: $showingManageCollectionsView) {
                ManageCollectionsView(moc: moc)
            }
            .background(.mainGray)
        }
        .tint(.mutedWhite) // allows for change of NavLink tBar button color
        .preferredColorScheme(.dark)
        .overlay {
            if showingSortMenu {
                FocusedOverlay()
                .onTapGesture {
                    showingSortMenu = false
                }
            }
        }
        .readSize { newSize in
            viewSize = newSize
        }
    }
}
