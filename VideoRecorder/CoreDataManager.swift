//
//  CoreDataManager.swift
//  VideoRecorder
//
//  Created by 엄철찬 on 2022/10/15.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VideoTitle")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError?{
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context : NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func fetch<T:NSManagedObject>(request:NSFetchRequest<T>) -> [T]{
        do{
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        }catch{
            print(error.localizedDescription)
            return []
        }
    }
    
    @discardableResult
    func insert(title:String) -> Bool{
        let entity = NSEntityDescription.entity(forEntityName: "Title", in: self.context)
        if let entity = entity{
            let managedObject = NSManagedObject(entity: entity, insertInto: self.context)
            managedObject.setValue(title, forKey: "title")
            do{
                try self.context.save()
                return true
            }catch{
                print(error.localizedDescription)
                return false
            }
        }else{
            return false
        }
    }
    
    @discardableResult
    func delete(object:NSManagedObject) -> Bool{
        self.context.delete(object)
        do{
            try self.context.save()
            return true
        }catch{
            print(error.localizedDescription)
            return false
        }
    }
}
