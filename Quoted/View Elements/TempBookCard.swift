//
//  TempBookCard.swift
//  Quoted
//
//  Created by Dawson McCall on 11/3/23.
//

import CoreData
import SwiftUI

struct TempBookCard: View {
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
                    
                    Text(author == "" ? "Unknown" : author)
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
                // dates read
                if dateFinished != nil {
                    Text("\(formattedDate(dateStarted)) - \(formattedDate(dateFinished!))")
                        .padding(.horizontal, 7)
                        .padding(.vertical, 5)
                        .background(.white.opacity(0.70))
                        .clipShape(Capsule())
                        .padding(.leading, 5)
                } else {
                    Text("\(formattedDate(dateStarted)) -")
                        .padding(.horizontal, 7)
                        .padding(.vertical, 5)
                        .background(.white.opacity(0.70))
                        .clipShape(Capsule())
                        .padding(.leading, 5)
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
