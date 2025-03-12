//
//  Book+CoreDataProperties.swift
//  Quoted
//
//  Created by Dawson McCall on 10/27/23.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var author: String?
    @NSManaged public var authorTitle: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var dateFinished: Date?
    @NSManaged public var dateStarted: Date?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var pageCount: String?
    @NSManaged public var quoteCount: Int64
    @NSManaged public var selectedColor: String?
    @NSManaged public var title: String?
    @NSManaged public var quotes: NSSet?
    @NSManaged public var collections: NSSet?

    public var unwrappedAuthor: String {
        author ?? "Unknown"
    }
    
    public var unwrappedATPC: String {
        authorTitle ?? "Unknown"
    }
    
    public var unwrappedDateAdded: Date {
        dateAdded ?? Date.now
    }
    
    public var unwrappedPageCount: String {
        pageCount ?? ""
    }
    
    public var intPageCount: Int {
        Int(unwrappedPageCount) ?? 0
    }
    
    public var unwrappedSelectedColor: String {
        selectedColor ?? "Unknown"
    }
    
    public var unwrappedTitle: String {
        title ?? "Unknown"
    }
    
    // sorting a set automatically returns an array
    public var quotesArray: [Quote] {
        let set = quotes as? Set<Quote> ?? []
        
        return set.sorted {
            $0.unwrappedDateAdded < $1.unwrappedDateAdded
        }
    }
    
    public var collectionsArray: [Collection] {
        let set = collections as? Set<Collection> ?? []
        
        return set.sorted {
            $0.unwrappedName < $1.unwrappedName
        }
    }
}

// MARK: Generated accessors for quotes
extension Book {

    @objc(addQuotesObject:)
    @NSManaged public func addToQuotes(_ value: Quote)

    @objc(removeQuotesObject:)
    @NSManaged public func removeFromQuotes(_ value: Quote)

    @objc(addQuotes:)
    @NSManaged public func addToQuotes(_ values: NSSet)

    @objc(removeQuotes:)
    @NSManaged public func removeFromQuotes(_ values: NSSet)

}

// MARK: Generated accessors for collections
extension Book {

    @objc(addCollectionsObject:)
    @NSManaged public func addToCollections(_ value: Collection)

    @objc(removeCollectionsObject:)
    @NSManaged public func removeFromCollections(_ value: Collection)

    @objc(addCollections:)
    @NSManaged public func addToCollections(_ values: NSSet)

    @objc(removeCollections:)
    @NSManaged public func removeFromCollections(_ values: NSSet)
    
    @objc
    public func deleteAllCollections() {
        if let allCollections = self.collections?.allObjects as? [Collection] {
            for collection in allCollections {
                removeFromCollections(collection)
            }
        }
    }

}

extension Book : Identifiable {

}
