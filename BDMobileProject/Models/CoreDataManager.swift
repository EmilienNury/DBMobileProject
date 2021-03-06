//
//  CoreDataManager.swift
//  BDMobileProject
//
//  Created by lpiem on 09/02/2022.
//

import Foundation
import CoreData
import UIKit

public class CoreDataManager {
    public static let sharedInstance = CoreDataManager()
    private var container: NSPersistentContainer
    
    private init() {
        container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    public func saveContext() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    public func fetchCategories(ascent: Bool , searchQuery: String? = nil,filter: String? = nil) -> [Category] {
        let fetchRequest = Category.fetchRequest()
        
        switch filter{
        case "create":
            let sortDescriptor = NSSortDescriptor(keyPath: \Category.creationDate, ascending: ascent)
            fetchRequest.sortDescriptors = [sortDescriptor]
        case "edit":
            let sortDescriptor = NSSortDescriptor(keyPath: \Category.modificationDate, ascending: ascent)
            fetchRequest.sortDescriptors = [sortDescriptor]
        default:
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: ascent, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            let predicate = NSPredicate(format: "%K contains[cd] %@", argumentArray: [#keyPath(Category.title),searchQuery])
            fetchRequest.predicate = predicate
        }
        
        do {
            let result: [Category] = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func createCategory(title: String) {
        let category = Category(context: container.viewContext)
        category.title = title
        category.creationDate = Date()
        category.modificationDate = Date()
        
        saveContext()
    }
    
    public func deleteCategory(category: Category) {
        container.viewContext.delete(category)
        saveContext()
    }
    
    public func editCategory(category: Category, newTitle: String) {
        category.title = newTitle
        category.modificationDate = Date()
        saveContext()
    }
    
    public func fetchCoordinates(searchQuery: String? = nil) -> [Coordinate] {
        let fetchRequest = Coordinate.fetchRequest()
        
        do {
            let result: [Coordinate] = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func createCoordinate(longitude: Double, latitude: Double) -> Coordinate{
        let coordinate = Coordinate(context: container.viewContext)
        coordinate.longitude = longitude
        coordinate.latitude = latitude
        
        saveContext()
        
        return coordinate
    }
    
    public func deleteCoordinate(coordinate: Coordinate) {
        container.viewContext.delete(coordinate)
        saveContext()
    }
    
    public func fetchLandmarks(ascent: Bool, searchQuery: String? = nil, category: Category?,filter: String? = nil) -> [Landmark] {
        let fetchRequest = Landmark.fetchRequest()
        
        var predicates: [NSPredicate] = []
        
        switch filter{
            case "create":
                let sortDescriptor = NSSortDescriptor(keyPath: \Landmark.creationDate, ascending: ascent)
                fetchRequest.sortDescriptors = [sortDescriptor]
            case "edit":
                let sortDescriptor = NSSortDescriptor(keyPath: \Landmark.modificationDate, ascending: ascent)
                fetchRequest.sortDescriptors = [sortDescriptor]
            default:
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: ascent, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
                fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            let predicate = NSPredicate(format: "%K contains[cd] %@", argumentArray: [#keyPath(Landmark.title),searchQuery])
            predicates.append(predicate)
        }
        
        if let categoryQuery = category {
            let predicate = NSPredicate(format: "%K == %@",
                                        argumentArray: [#keyPath(Landmark.category), categoryQuery])
            predicates.append(predicate)
        }
        
        let compoundPredicate = NSCompoundPredicate(
            type: .and,
            subpredicates: predicates)
        
        fetchRequest.predicate = compoundPredicate
        
        
        do {
            let result: [Landmark] = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func fetchAllLandmarks() -> [Landmark] {
        let fetchRequest = Landmark.fetchRequest()
        
        do {
            let result: [Landmark] = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func createLandmark(title: String, desc: String?, image: Data?, category: Category, coordinate: Coordinate) {
        let landmark = Landmark(context: container.viewContext)
        landmark.title = title
        landmark.desc = desc
        landmark.image = image
        landmark.creationDate = Date()
        landmark.modificationDate = Date()
        landmark.category = category
        landmark.coordinate = coordinate
        
        saveContext()
    }
    
    public func deleteLandmark(landmark: Landmark) {
        container.viewContext.delete(landmark)
        saveContext()
    }
    
    public func editLandmark(landmark: Landmark, newTitle: String, newDesc: String, newImage: Data, newCoordinate: Coordinate) {
        landmark.title = newTitle
        landmark.desc = newDesc
        landmark.image = newImage
        landmark.coordinate = newCoordinate
        landmark.modificationDate = Date()
        saveContext()
    }
}
