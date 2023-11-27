//
//  QuoteCard.swift
//  Quoted
//
//  Created by Dawson McCall on 10/15/23.
//

import CoreData
import SwiftUI

struct QuoteCard: View {
    @ObservedObject var quote: Quote
    let selectedColor: Color
    let moc: NSManagedObjectContext
    
    @Binding var selectedSortMethod: String
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 5)
                .background(.mutedWhite)
                .padding(.trailing, 2)
            
            // quote
            VStack(alignment: .leading) {
                Text(quote.unwrappedQuote)
                    .padding(.vertical, 4)
                    .foregroundStyle(.white)
                    .font(.custom("Helvetica Neue", size: 18, relativeTo: .body))
                    .lineSpacing(3)
                    .multilineTextAlignment(.leading)
                    .animation(.easeIn, value: quote.unwrappedQuote)
                
                HStack() {
                    // favorite button
                    Button {
                        quote.isFavorite.toggle()
                        
                        // only way I could find to make BookDetail refresh sort on change of isFavorite
                        if selectedSortMethod == "Favorites First" {
                            selectedSortMethod = ""
                            selectedSortMethod = "Favorites First"
                        }
                        
                        if moc.hasChanges {
                            do {
                                try moc.save()
                            } catch {
                                print("Error saving context: \(error)")
                            }
                        }
                    } label: {
                        Image(systemName: quote.isFavorite ? "star.fill" : "star")
                            .foregroundStyle(selectedColor)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(.white.opacity(0.70))
                            .clipShape(Capsule())
                            .animation(.easeIn, value: quote.isFavorite)
                    }
                    
                    // page number
                    if quote.unwrappedPageNumber != "" {
                        Text("p. \(quote.unwrappedPageNumber)")
                            .foregroundStyle(.mainGray)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(.white.opacity(0.70))
                            .clipShape(Capsule())
                            .animation(.easeIn, value: quote.unwrappedPageNumber)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.mutedWhite)
                .font(.title3)
        }
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .background(selectedColor.opacity(0.095))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .onChange(of: quote.pageNumber) {
            // both on changes are used to prompt sort method to resort
            let ssm = selectedSortMethod
            selectedSortMethod = ""
            selectedSortMethod = ssm
        }
        .onChange(of: quote.isFavorite) {
            let ssm = selectedSortMethod
            selectedSortMethod = ""
            selectedSortMethod = ssm
        }
    }
}
