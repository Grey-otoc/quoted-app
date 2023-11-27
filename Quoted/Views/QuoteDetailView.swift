//
//  QuoteDetailView.swift
//  Quoted
//
//  Created by Dawson McCall on 10/25/23.
//

import CoreData
import SwiftUI

struct QuoteDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var quote: Quote
    let book: Book
    let moc: NSManagedObjectContext
    
    @FocusState private var quoteTxtField
    @FocusState private var pageNumTxtField
    @FocusState private var notesTxtField
    @State private var placeholderQuote = "Enter quote here."
    @State private var quoteContent = ""
    @State private var pageNumber = ""
    @State private var isFavorite = false
    @State private var notes = "Tap here."
    @State private var placeHolderNote = "Tap here."
    @State private var showingDeleteAlert = false
    
    @State private var viewSize: CGSize = .zero
    
    var body: some View {
        let selectedColor = book.unwrappedSelectedColor.asColor

        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        // edit quote section
                        VStack {
                            Text("Edit Quote:")
                                .foregroundStyle(.mutedWhite)
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            TextEditor(text: $quoteContent)
                                .font(.custom("Helvetica Neue", size: 18, relativeTo: .body))
                                .foregroundStyle(quoteContent == placeholderQuote ? .mainGray.opacity(0.35) : .mainGray)
                                .lineSpacing(3)
                                .tint(.mainGray)
                                .scrollContentBackground(.hidden)
                                .frame(height: 300)
                                .background(.mutedWhite)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .onTapGesture {
                                    withAnimation {
                                        if quoteContent == placeholderQuote {
                                            quoteContent = ""
                                        }
                                    }
                                }
                                .onChange(of: quoteTxtField) {
                                    if !quoteTxtField && quoteContent.isEmpty {
                                        quoteContent = placeholderQuote
                                    }
                                }
                                .focused($quoteTxtField)
                            
                            // quote info fields
                            HStack {
                                HStack {
                                    Text("Page #:")
                                        .foregroundStyle(selectedColor)
                                        .lineLimit(1)
                                        .padding(.leading, 5)
                                    
                                    TextField("", text: $pageNumber)
                                        .onChange(of: pageNumber) {
                                            if pageNumber.count > 5 {
                                                let index = pageNumber.index(pageNumber.startIndex, offsetBy: 5)
                                                pageNumber = String(pageNumber[..<index])
                                            }
                                        }
                                        .keyboardType(.numberPad)
                                        .foregroundStyle(.mainGray)
                                        .tint(.mainGray)
                                        .focused($pageNumTxtField)
                                }
                                .font(.title3)
                                .fontWeight(.bold)
                                .frame(height: viewSize.height * 0.08)
                                .frame(width: viewSize.width * 0.53)
                                .background(.mutedWhite)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                
                                Spacer()
                                
                                // favorite button
                                HStack {
                                    Button {
                                        withAnimation {
                                            isFavorite.toggle()
                                        }
                                    } label: {
                                        Image(systemName: isFavorite ? "star.fill" : "star")
                                            .foregroundStyle(selectedColor)
                                            .font(.largeTitle)
                                    }
                                }
                                .frame(height: viewSize.height * 0.08)
                                .frame(maxWidth: .infinity)
                                .background(.mutedWhite)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                            .padding(.vertical, 10)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        
                        // divider
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 3)
                            .foregroundStyle(selectedColor)
                            .padding(.bottom, 15)
                            .padding(.horizontal, 15)
                        
                        // notes section
                        VStack {
                            Text("Notes:")
                                .foregroundStyle(.mutedWhite)
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, -5)
                            
                            TextEditor(text: $notes)
                                .font(.custom("Helvetica Neue", size: 18, relativeTo: .body))
                                .foregroundStyle(notes == placeHolderNote ? .mutedWhite.opacity(0.45) : .mutedWhite)
                                .tint(selectedColor)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: viewSize.height * 0.23, maxHeight: .infinity)
                                .onTapGesture {
                                    withAnimation {
                                        if notes == placeHolderNote {
                                            notes = ""
                                        }
                                    }
                                }
                                .onChange(of: notesTxtField) {
                                    if !notesTxtField && notes.isEmpty {
                                        notes = placeHolderNote
                                    }
                                }
                                .focused($notesTxtField)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 15)
                }
                .frame(maxWidth: .infinity)
                .background(.mainGray)
                .toolbarBackground(selectedColor, for: .navigationBar)
                .toolbar {
                    
                    // share button
                    ToolbarItem(placement: .topBarTrailing) {
                        let message = "\"\(quote.unwrappedQuote)\"\n\n- \(book.unwrappedAuthor): \(book.unwrappedTitle)"
                        ShareLink(item: message) {
                            Image(systemName: "square.and.arrow.up.fill")
                                .foregroundStyle(.mutedWhite)
                                .font(.headline)
                        }
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
                        .padding(.leading, -20)
                        .alert(
                            "Delete Quote?",
                            isPresented: $showingDeleteAlert
                        ) {
                            Button(role: .cancel) {} label: {
                                Text("Cancel")
                            }
                            Button(role: .destructive) {
                                deleteQuote(book, quote, moc: moc)
                                dismiss()
                            } label: {
                                Text("Delete")
                            }
                        } message: {
                            Text("Are you sure you want to delete this quote. This action cannot be undone.")
                        }
                    }
                }
                .scrollIndicators(.hidden)
                
                // keyboard tbar
                if quoteTxtField || notesTxtField || pageNumTxtField {
                    Button {
                        quoteTxtField = false
                        notesTxtField = false
                        pageNumTxtField = false
                    } label: {
                        KeyboardToolBar()
                    }
                }
            }
            .background(selectedColor)
        }
        .onAppear {
            quoteContent = quote.unwrappedQuote
            pageNumber = quote.unwrappedPageNumber
            isFavorite = quote.isFavorite
            if !quote.unwrappedNotes.isEmpty {
                notes = quote.unwrappedNotes
            }
        }
        .onDisappear {
            editQuote(
                quote,
                moc: moc,
                quoteContent: quoteContent,
                pageNumber: pageNumber,
                isFavorite: isFavorite,
                notes: notes
            )
        }
        .readSize { newSize in
            viewSize = newSize
        }
    }
}
