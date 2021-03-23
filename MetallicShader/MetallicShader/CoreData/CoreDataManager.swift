//
//  CoreDataManager.swift
//  MetallicShader
//
//  Created by Aleks on 22.03.2021.
//

import Foundation
import CoreData

class CoreDataManager {
    static var shared: CoreDataManager = {
        let instance = CoreDataManager()
        return instance
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let modelName = "MetallicShader"

        var container: NSPersistentContainer!

        if #available(iOS 13.0, *) {
            container = NSPersistentContainer(name: modelName)
        } else {
            var modelURL = Bundle(for: type(of: self)).url(forResource: modelName, withExtension: "momd")!
            let versionInfoURL = modelURL.appendingPathComponent("VersionInfo.plist")
            if let versionInfoNSDictionary = NSDictionary(contentsOf: versionInfoURL),
                let version = versionInfoNSDictionary.object(forKey: "NSManagedObjectModel_CurrentVersionName") as? String {
                modelURL.appendPathComponent("\(version).mom")
                let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
                container = NSPersistentContainer(name: modelName, managedObjectModel: managedObjectModel!)
            } else {
                //fall back solution; runs fine despite "Failed to load optimized model" warning
                container = NSPersistentContainer(name: modelName)
            }
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    lazy var viewContext = persistentContainer.viewContext
    
    func saveContext () {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createProject(name: String) {
        let project = Project(context: viewContext)
        project.name = name
        project.createdAt = Date()
        
        do {
            try viewContext.save()
        } catch {
            fatalError("\(error)")
        }
    }
    
    func fetchProjectList() -> [Project] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
        if let projects = try? viewContext.fetch(fetchRequest) as? [Project] {
            return projects
        }
        return []
    }
}

extension CoreDataManager {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
