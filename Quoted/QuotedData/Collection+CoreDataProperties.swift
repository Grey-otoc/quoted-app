//
//  Collection+CoreDataProperties.swift
//  Quoted
//
//  Created by Dawson McCall on 10/27/23.
//
//

import Foundation
import CoreData


extension Collection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Collection> {
        return NSFetchRequest<Collection>(entityName: "Collection")
    }

    @NSManaged public var name: String?
    @NSManaged public var books: NSSet?

    public var unwrappedName: String {
        name ?? ""
    }
    
    public var booksArray: [Book] {
        let set = books as? Set<Book> ?? []
        
        return set.sorted {
            $0.unwrappedTitle < $1.unwrappedTitle
        }
    }
}

// MARK: Generated accessors for books
extension Collection {

    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: Book)

    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: Book)

    @objc(addBooks:)
    @NSManaged public func addToBooks(_ values: NSSet)

    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ values: NSSet)

    @objc
    public func deleteAllBooks() {
        if let allBooks = self.books?.allObjects as? [Book] {
            for book in allBooks {
                removeFromBooks(book)
            }
        }
    }
}

extension Collection : Identifiable {

}
