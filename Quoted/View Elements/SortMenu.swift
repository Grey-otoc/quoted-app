//
//  SortMenu.swift
//  Quoted
//
//  Created by Dawson McCall on 10/26/23.
//

import SwiftUI

struct SortMenu: View {
    @Binding var selectedSortMethod: String
    var selectedCollection: Binding<String>? = nil
    let sortMethods: [String]
    let collectionSortNeeded: Bool
    @FetchRequest(sortDescriptors: []) var collections: FetchedResults<Collection>
    
    var body: some View {
        Menu {
            Menu {
                Picker("Select Sort Method", selection: $selectedSortMethod) {
                    ForEach(sortMethods, id: \.self) { method in
                        Text(method)
                    }
                }
                .labelsHidden()
            } label: {
                Label("Sort By:", systemImage: "arrow.up.arrow.down")
            }
            
            if collectionSortNeeded {
                Menu {
                    Picker("Select Collection", selection: selectedCollection!) {
                        Text("None").tag("None")
                        
                        ForEach(collections, id: \.self) { collection in
                            Text(collection.unwrappedName).tag(collection.unwrappedName)
                        }
                    }
                    .labelsHidden()
                } label: {
                    Label("Filter by:", systemImage: "line.3.horizontal.decrease")
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.headline)
        }
    }
}

enum BookSortingMethod: String {
    case newestFirst = "Newest First"
    case oldestFirst = "Oldest First"
    case titleAscending = "Title Ascending"
    case titleDescending = "Title Descending"
    case authorAscending = "Author Ascending"
    case authorDescending = "Author Descending"
    case favoritesFirst = "Favorites First"
    case pageCountAscending = "Page Count Ascending"
    case pageCountDescending = "Page Count Descending"

    func compare(_ book1: Book, _ book2: Book) -> Bool {
        switch self {
        case .newestFirst:
            return book1.unwrappedDateAdded > book2.unwrappedDateAdded
        case .oldestFirst:
            return book1.unwrappedDateAdded < book2.unwrappedDateAdded
        case .titleAscending:
            return book1.unwrappedTitle < book2.unwrappedTitle
        case .titleDescending:
            return book1.unwrappedTitle > book2.unwrappedTitle
        case .authorAscending:
            return book1.unwrappedAuthor < book2.unwrappedAuthor
        case .authorDescending:
            return book1.unwrappedAuthor > book2.unwrappedAuthor
        case .favoritesFirst:
            return book1.isFavorite && !book2.isFavorite
        case .pageCountAscending:
            return book1.intPageCount < book2.intPageCount
        case .pageCountDescending:
            return book1.intPageCount > book2.intPageCount
        }
    }
}

enum QuoteSortingMethod: String {
    case newestFirst = "Newest First"
    case oldestFirst = "Oldest First"
    case pageNumberAscending = "Page Number Ascending"
    case pageNumberDescending = "Page Number Descending"
    case favoritesFirst = "Favorites First"

    func compare(_ quote1: Quote, _ quote2: Quote) -> Bool {
        switch self {
        case .newestFirst:
            return quote1.unwrappedDateAdded > quote2.unwrappedDateAdded
        case .oldestFirst:
            return quote1.unwrappedDateAdded < quote2.unwrappedDateAdded
        case .pageNumberAscending:
            return quote1.intPageNumber < quote2.intPageNumber
        case .pageNumberDescending:
            return quote1.intPageNumber > quote2.intPageNumber
        case .favoritesFirst:
            return quote1.isFavorite && !quote2.isFavorite
        }
    }
}

