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
    
    public func fetchCategories(searchQuery: String? = nil) -> [Category] {
        let fetchRequest = Category.fetchRequest()
        
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
    
    public func fetchLandmarks(searchQuery: String? = nil) -> [Landmark] {
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
}
