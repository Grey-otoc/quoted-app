//
//  Quote+CoreDataProperties.swift
//  Quoted
//
//  Created by Dawson McCall on 10/6/23.
//
//

import Foundation
import CoreData


extension Quote {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quote> {
        return NSFetchRequest<Quote>(entityName: "Quote")
    }

    @NSManaged public var quote: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var notes: String?
    @NSManaged public var pageNumber: String?
    @NSManaged public var originBook: Book?

    public var unwrappedQuote: String {
        quote ?? ""
    }
    
    public var unwrappedDateAdded: Date {
        dateAdded ?? Date.now
    }
    
    public var unwrappedNotes: String {
        notes ?? ""
    }
    
    public var unwrappedPageNumber: String {
        pageNumber ?? ""
    }
    
    public var intPageNumber: Int {
        return Int(unwrappedPageNumber) ?? 0
    }
}

extension Quote : Identifiable {

}
