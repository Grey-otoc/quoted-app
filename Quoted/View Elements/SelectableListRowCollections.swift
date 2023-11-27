//
//  SelectableListRowCollections.swift
//  Quoted
//
//  Created by Dawson McCall on 11/2/23.
//

import SwiftUI

struct SelectableListRowCollections: View {
    let collection: Collection
    @Binding var selectedCollections: [Collection]
    
    var isSelected: Bool {
        selectedCollections.contains(collection)
    }

    var body: some View {
        HStack {
            Image(systemName: isSelected ? "checkmark.square.fill" : "checkmark.square")
                .foregroundStyle(.mainGray)
                .font(.title3)
            
            Text(collection.unwrappedName)
                .foregroundStyle(.mainGray)
                .font(.title3)
                .fontWeight(isSelected ? .bold : .regular)
            
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if isSelected {
                let index = selectedCollections.firstIndex(of: collection)
                selectedCollections.remove(at: index!)
            } else {
                selectedCollections.append(collection)
            }
        }
    }
}
