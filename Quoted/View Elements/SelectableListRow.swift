//
//  SelectableListRow.swift
//  Quoted
//
//  Created by Dawson McCall on 10/29/23.
//

import SwiftUI

struct SelectableListRow: View {
    let book: Book
    @Binding var selectedBooks: [Book]
    
    var isSelected: Bool {
        selectedBooks.contains(book)
    }

    var body: some View {
        HStack {
            Image(systemName: isSelected ? "checkmark.square.fill" : "checkmark.square")
                .foregroundStyle(.mainGray)
                .font(.title3)
            
            Text(book.unwrappedTitle)
                .foregroundStyle(.mainGray)
                .font(.title3)
                .fontWeight(isSelected ? .bold : .regular)
            
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if isSelected {
                let index = selectedBooks.firstIndex(of: book)
                selectedBooks.remove(at: index!)
            } else {
                selectedBooks.append(book)
            }
        }
    }
}
