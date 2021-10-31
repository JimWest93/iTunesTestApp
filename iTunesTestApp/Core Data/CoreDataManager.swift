import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static var shared: CoreDataManager = {
        let instance = CoreDataManager()
        return instance
    }()
    
    private func context() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    //сохранение запроса
    func searchRequestSaver(searchRequest: String) {
        
        var isAlreadySaved: Bool = false
        
        isAlreadySaved = searchRequestsData().filter { request in
            request.request == searchRequest
        }.isEmpty ? false : true
        
        let context = context()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "SearchRequests", in: context) else { return }
        
        if searchRequest != "" && !isAlreadySaved { //если такого запроса еще не было, сохраняем
            
            let request = SearchRequests(entity: entity, insertInto: context)
            
            request.request = searchRequest
            
            do {
                
                try context.save()
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        } else if isAlreadySaved { //если запрос был то поднимаем на первую позицию
            
            guard let index: Int = {
                searchRequestsData().firstIndex(where: {$0.request == searchRequest} )
            }() else { return }
            
            let object = searchRequestsData()[index]
            
            let request = SearchRequests(entity: entity, insertInto: context)
            
            request.request = searchRequest
            
            context.delete(object)
            
            do {
                
                try context.save()
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
    }
    
    //получение всех запросов
    func searchRequestsData() -> [SearchRequests] {
        
        let context = context()
        
        let fetchRequest: NSFetchRequest<SearchRequests> = SearchRequests.fetchRequest()
        
        do {
            
            return try context.fetch(fetchRequest).reversed()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return []
        
    }
    
}
