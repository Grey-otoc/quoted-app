//
//  WriteView.swift
//  Quoted
//
//  Created by Dawson McCall on 10/13/23.
//

import CoreData
import SwiftUI

struct WriteView: View {
    @Environment(\.dismiss) var dismiss
    
    let book: Book
    let moc: NSManagedObjectContext
    let selectedColor: Color
    @Binding var tabSelection: Int
    @Binding var scannedText: String
    
    @State private var quote = "Enter quote here."
    @State private var placeholderQuote = "Enter quote here."
    @FocusState private var anyTxtField
    @State private var pageNumber = ""
    @State private var isFavorite = false
    
    private var isSaveEnabled: Bool {
        if !quote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && quote != placeholderQuote {
            return true
        } else { return false }
    }
    
    @State private var viewSize: CGSize = .zero
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        // quote text editor
                        TextEditor(text: $quote)
                            .font(.custom("Helvetica Neue", size: 19, relativeTo: .body))
                            .foregroundStyle(quote == placeholderQuote ? .mainGray.opacity(0.35) : .mainGray)
                            .lineSpacing(3)
                            .tint(.mainGray)
                            .scrollContentBackground(.hidden)
                            .frame(maxWidth: .infinity)
                            .frame(height: viewSize.height * 0.68)
                            .background(.mutedWhite)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.horizontal, 20)
                            .onAppear {
                                if scannedText != "" {
                                    quote = scannedText
                                    scannedText = ""
                                }
                            }
                            .onTapGesture {
                                withAnimation {
                                    if quote == placeholderQuote {
                                        quote = ""
                                    }
                                }
                            }
                            .onChange(of: anyTxtField) {
                                if !anyTxtField && quote.isEmpty {
                                    quote = placeholderQuote
                                }
                            }
                            .focused($anyTxtField)
                        
                        Spacer()
                        
                        // quote info fields
                        HStack {
                            // page count
                            HStack {
                                Text("Page #:")
                                    .foregroundStyle(selectedColor)
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
                                    .focused($anyTxtField)
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
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                    .padding(.vertical, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.mainGray)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    // navbar title
                    ToolbarItem(placement: .principal) {
                        Text("Write Quote")
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
                        .animation(.easeIn, value: selectedColor)
                    }
                    
                    // save button
                    ToolbarItem(placement: .topBarTrailing) {
                        Button() {
                            saveQuote(
                                moc: moc,
                                originBook: book,
                                quote: quote,
                                pageNumber: pageNumber,
                                isFavorite: isFavorite
                            )
                            
                            dismiss()
                        } label: {
                            Text("Save")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(isSaveEnabled ? selectedColor : selectedColor.opacity(0.40))
                        }
                        .disabled(!isSaveEnabled)
                    }
                }
                .scrollIndicators(.hidden)
                
                // keyboard tbar
                if anyTxtField {
                    Button {
                        anyTxtField = false
                    } label: {
                        KeyboardToolBar()
                    }
                }
            }
            .background(selectedColor)
        }
        .readSize { newSize in
            viewSize = newSize
        }
    }
}
