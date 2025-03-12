//
//  BookHelpers.swift
//  Quoted
//
//  Created by Dawson McCall on 10/12/23.
//

import CoreData
import SwiftUI

func deleteBook(_ book: Book, moc: NSManagedObjectContext) {
    moc.delete(book)

    if moc.hasChanges {
        do {
            try moc.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

func saveBook(moc: NSManagedObjectContext, title: String, author: String, authorTitle: String, pageCount: String, dateAdded: Date, dateStarted: Date, dateFinished: Date?, isFavorite: Bool, selectedCollections: [Collection], selectedColor: String) {
    let book = Book(context: moc)
    book.title = title
    if author.trimmingCharacters(in: .whitespaces) == "" {
        book.author = "Unknown"
    } else {
        book.author = author
    }
    book.authorTitle = "\(author)\(title)"
    book.pageCount = pageCount
    book.dateAdded = Date.now
    book.dateStarted = dateStarted
    book.dateFinished = dateFinished
    book.isFavorite = isFavorite
    for collection in selectedCollections {
        book.addToCollections(collection)
    }
    book.selectedColor = selectedColor
    book.quoteCount = 0

    if moc.hasChanges {
        do {
            try moc.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

func editBook(book: Book, moc: NSManagedObjectContext, title: String, author: String, authorTitle: String, pageCount: String, dateStarted: Date, dateFinished: Date?, isFavorite: Bool, selectedCollections: [Collection], selectedColor: String) {
    book.title = title
    if author.trimmingCharacters(in: .whitespaces) == "" {
        book.author = "Unknown"
    } else {
        book.author = author
    }
    book.authorTitle = "\(author)\(title)"
    book.pageCount = pageCount
    book.dateStarted = dateStarted
    book.dateFinished = dateFinished
    book.selectedColor = selectedColor
    book.isFavorite = isFavorite
    book.deleteAllCollections()
    for collection in selectedCollections {
        book.addToCollections(collection)
    }

    if moc.hasChanges {
        do {
            try moc.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

func saveQuote(moc: NSManagedObjectContext, originBook: Book, quote: String, pageNumber: String, isFavorite: Bool) {
    let newQuote = Quote(context: moc)
    newQuote.dateAdded = Date.now
    newQuote.originBook = originBook
    newQuote.quote = quote
    newQuote.pageNumber = pageNumber
    newQuote.isFavorite = isFavorite
    originBook.quoteCount += 1
    
    if moc.hasChanges {
        do {
            try moc.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

func deleteQuote(_ book: Book, _ quote: Quote, moc: NSManagedObjectContext) {
    book.quoteCount -= 1
    moc.delete(quote)
    
    if moc.hasChanges {
        do {
            try moc.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

func editQuote(_ quote: Quote, moc: NSManagedObjectContext, quoteContent: String, pageNumber: String, isFavorite: Bool, notes: String) {
    quote.quote = quoteContent
    quote.pageNumber = pageNumber
    quote.isFavorite = isFavorite
    if notes.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        quote.notes = ""
    } else {
        quote.notes = notes
    }
    
    if moc.hasChanges {
        do {
            try moc.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

func saveCollection(_ books: [Book], moc: NSManagedObjectContext, name: String) {
    let newCollection = Collection(context: moc)
    newCollection.name = name
    for book in books {
        newCollection.addToBooks(book)
    }
    
    if moc.hasChanges {
        do {
            try moc.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

func editCollection(_ books: [Book], moc: NSManagedObjectContext, name: String, collection: Collection) {
    collection.name = name
    collection.deleteAllBooks()
    for book in books {
        collection.addToBooks(book)
    }
    
    if moc.hasChanges {
        do {
            try moc.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

func deleteCollection(_ collection: Collection, moc: NSManagedObjectContext) {
    moc.delete(collection)
    
    if moc.hasChanges {
        do {
            try moc.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
