//
//  BookCard.swift
//  Quoted
//
//  Created by Dawson McCall on 10/7/23.
//

import CoreData
import SwiftUI

struct BookCard: View {
    @ObservedObject var book: Book
    @Binding var selectedSortMethod: String
    let moc: NSManagedObjectContext
    
    let author: String
    let title: String
    let pageCount: String
    let quoteCount: Int64
    let dateStarted: Date
    let dateFinished: Date?
    let currentDate = Date.now.formatted(date: .numeric, time: .omitted)
    let selectedColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // title and author
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.custom("Alte Haas Grotesk Bold", size: 32))
                        .fontWeight(.bold)
                        .foregroundStyle(.mutedWhite)
                        .lineLimit(2)
                        .padding(.leading, 10)
                        .multilineTextAlignment(.leading) // fixes weird NavigationLink alignment issues
                    
                    Text(author)
                        .font(.headline)
                        .padding(.leading, 11.5)
                        .foregroundStyle(.mainGray)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .padding(.top, 15)
                .frame(alignment: .leading)
                
                Spacer()
                
                // quote count
                Text("\(quoteCount)")
                    .foregroundStyle(selectedColor)
                    .font(.title)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .background(.mutedWhite)
                    .clipShape(Capsule())
                    .padding(.horizontal, 10)
            }
            
            Spacer()
            
            HStack() {
                // favorite button
                Button {
                    book.isFavorite.toggle()
                    
                    // only way I could find to make CV sort refresh sort on change of isFavorite
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
                    Image(systemName: book.isFavorite ? "star.fill" : "star")
                        .foregroundStyle(selectedColor)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 5)
                        .background(.white.opacity(0.70))
                        .clipShape(Capsule())
                        .padding(.leading, 10)
                }
                
                // dates read
                if dateFinished != nil {
                    Text("\(formattedDate(dateStarted)) - \(formattedDate(dateFinished!))")
                        .padding(.horizontal, 7)
                        .padding(.vertical, 5)
                        .background(.white.opacity(0.70))
                        .clipShape(Capsule())
                } else {
                    Text("\(formattedDate(dateStarted)) -")
                        .padding(.horizontal, 7)
                        .padding(.vertical, 5)
                        .background(.white.opacity(0.70))
                        .clipShape(Capsule())
                }
                
                // page count
                if pageCount != "" {
                    Text("\(pageCount) pp.")
                        .padding(.horizontal, 7)
                        .padding(.vertical, 5)
                        .background(.white.opacity(0.70))
                        .clipShape(Capsule())
                }
            }
            .foregroundStyle(.mainGray)
        }
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity)
        .frame(height: 190)
        .background(selectedColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        return dateFormatter.string(from: date)
    }
}
