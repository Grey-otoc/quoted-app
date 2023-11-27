//
//  EditBookView.swift
//  Quoted
//
//  Created by Dawson McCall on 10/16/23.
//

import CoreData
import Foundation
import SwiftUI

struct EditBookView: View {
    @Environment(\.dismiss) var dismiss
    
    let book: Book
    let moc: NSManagedObjectContext
    
    @State private var title = ""
    @State private var author = ""
    @State private var pageCount = ""
    @State private var quoteCount: Int64 = 0
    @State private var dateStarted = Date()
    @State private var dateFinished: Date?
    @State private var hiddenDate = Date()
    @State private var isFavorite = false
    @State private var selectedCollections: [Collection] = []
    @State private var selectedColor = Color.paleMaroon
    
    @FocusState private var numPadFocus
    
    let colors = ColorPalette.colors
    
    private var isUpdateEnabled: Bool {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        return !trimmedTitle.isEmpty
    }
    
    @State private var viewSize: CGSize = .zero
    
    var body: some View {
        let screenHeight = UIScreen.current?.bounds.height ?? .zero
        
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    // title
                    AddBookTextField(
                        headline: "Title",
                        mainInfo: $title,
                        placeholder: ContentView.chosenTempBook["title"]!,
                        selectedColor: selectedColor,
                        needsNumpad: false
                    )
                    
                    // authors
                    AddBookTextField(
                        headline: "Author",
                        mainInfo: $author,
                        placeholder: ContentView.chosenTempBook["author"]!,
                        selectedColor: selectedColor,
                        needsNumpad: false
                    )
                    
                    // page count
                    AddBookTextField(
                        headline: "Page Count",
                        mainInfo: $pageCount,
                        placeholder: ContentView.chosenTempBook["pageCount"]!,
                        selectedColor: selectedColor,
                        needsNumpad: true
                    )
                    .focused($numPadFocus)
                    
                    // dates read
                    HStack {
                        VStack(spacing: 10) {
                            Text("Date Started")
                                .foregroundStyle(selectedColor)
                            
                            DatePicker(
                                "Date Started",
                                selection: $dateStarted,
                                displayedComponents: .date
                            )
                            .labelsHidden()
                            .padding(.vertical, -2.5)
                            .padding(.horizontal, -4)
                            .background(.mainGray)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .tint(selectedColor)
                        }
                        .font(.headline)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: screenHeight == 667.0 ? viewSize.height * 0.12 : viewSize.height * 0.1)
                        .background(.mutedWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.leading, 20)
                        
                        // optional date picker
                        VStack(spacing: 10) {
                            Text("Date Finished")
                                .foregroundStyle(selectedColor)
                            
                            if dateFinished != nil {
                                HStack {
                                    Button {
                                        dateFinished = nil
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(selectedColor)
                                    }
                                    
                                    DatePicker(
                                        "Select a date",
                                        selection: $hiddenDate,
                                        in: dateStarted...,
                                        displayedComponents: .date
                                    )
                                    .onChange(of: hiddenDate) { oldDate, newDate in
                                        dateFinished = newDate
                                    }
                                    .labelsHidden()
                                    .padding(.vertical, -2.5)
                                    .padding(.horizontal, -4)
                                    .background(.mainGray)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .tint(selectedColor)
                                }
                            } else {
                                Button {
                                    dateFinished = dateStarted
                                    hiddenDate = dateFinished!
                                } label: {
                                    Text("Add Date")
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(.mutedWhite)
                                }
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.mainGray)
                                )
                            }
                        }
                        .font(.headline)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: screenHeight == 667.0 ? viewSize.height * 0.12 : viewSize.height * 0.1)
                        .background(.mutedWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.trailing, 20)
                    }
                    
                    // favorite and collections buttons
                    HStack {
                        VStack(spacing: 10) {
                            Text("Collections")
                                .foregroundStyle(selectedColor)
            
                            NavigationLink(
                                destination: SelectCollectionsView(
                                    selectedCollections: $selectedCollections,
                                    moc: moc
                                ),
                                label: {
                                    Text("Select")
                                        .foregroundStyle(.mutedWhite)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 10)
                                        .background(.mainGray)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            )
                            .navigationBarTitle("", displayMode: .inline) // removes "back" text from navbar
                        }
                        .font(.headline)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: screenHeight == 667.0 ? viewSize.height * 0.12 : viewSize.height * 0.1)
                        .background(.mutedWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.leading, 20)
                        
                        VStack {
                            Button {
                                withAnimation {
                                    isFavorite.toggle()
                                }
                            } label: {
                                Image(systemName: isFavorite ? "star.fill" : "star")
                                    .foregroundStyle(selectedColor)
                                    .font(.system(size: 38))
                            }
                        }
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                        .frame(height: screenHeight == 667.0 ? viewSize.height * 0.12 : viewSize.height * 0.1)
                        .background(.mutedWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.trailing, 20)
                    }
                    
                    // book card
                    if isUpdateEnabled {
                        TempBookCard(
                            author: author,
                            title: title,
                            pageCount: pageCount,
                            quoteCount: quoteCount,
                            dateStarted: dateStarted,
                            dateFinished: dateFinished,
                            selectedColor: selectedColor
                        )
                        .padding(.horizontal, 20)
                    } else {
                        // default book card
                        TempBookCard(
                            author: ContentView.chosenTempBook["author"]!,
                            title: ContentView.chosenTempBook["title"]!,
                            pageCount: ContentView.chosenTempBook["pageCount"]!,
                            quoteCount: 9,
                            dateStarted: Date(),
                            dateFinished: nil,
                            selectedColor: selectedColor
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    // card color selector
                    HStack {
                        Text("Select Card Color:")
                            .foregroundStyle(.mainGray)
                        
                        Spacer()
                        
                        Picker("Card Color", selection: $selectedColor) {
                            ForEach(colors, id: \.self) { color in
                                Text(color.name)
                            }
                        }
                        .tint(selectedColor)
                    }
                    .font(.headline)
                    .padding(.leading, 10)
                    .frame(maxWidth: .infinity)
                    .background(.mutedWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.mainGray)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                // navbar title
                ToolbarItem(placement: .principal) {
                    Text("Edit Book")
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
                    .foregroundStyle(selectedColor)
                    .font(.title2)
                }
                
                // update button
                ToolbarItem(placement: .topBarTrailing) {
                    Button() {
                        let authorTitle = "\(author)\(title)"
                        
                        editBook(
                            book: book,
                            moc: moc,
                            title: title,
                            author: author,
                            authorTitle: authorTitle,
                            pageCount: pageCount,
                            dateStarted: dateStarted,
                            dateFinished: dateFinished,
                            isFavorite: isFavorite,
                            selectedCollections: selectedCollections,
                            selectedColor: selectedColor.name
                        )
                        
                        dismiss()
                    } label: {
                        Text("Update")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(isUpdateEnabled ? selectedColor : selectedColor.opacity(0.40))
                    }
                    .disabled(!isUpdateEnabled)
                }
            }
            .overlay {
                if numPadFocus {
                    FocusedOverlay()
                        .onTapGesture {
                            numPadFocus = false
                        }
                }
            }
            .animation(.easeIn, value: selectedColor)
            .scrollIndicators(.hidden)
        }
        .onAppear {
            title = book.unwrappedTitle
            author = book.unwrappedAuthor
            pageCount = book.unwrappedPageCount
            quoteCount = book.quoteCount
            dateStarted = book.dateStarted!
            dateFinished = book.dateFinished
            isFavorite = book.isFavorite
            selectedCollections = book.collectionsArray
            selectedColor = book.unwrappedSelectedColor.asColor
            
            if dateFinished != nil {
                hiddenDate = dateFinished!
            }
        }
        .readSize { newSize in
            viewSize = newSize
        }
    }
}
