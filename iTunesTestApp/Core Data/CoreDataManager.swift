import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static var shared: CoreDataManager = {
        let instance = CoreDataManager()
        return instance
    }()
    
    func context() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func searchRequestSaver(searchRequest: String) {
        
        if searchRequest != "" {
            
            let context = context()
            
            guard let entity = NSEntityDescription.entity(forEntityName: "SearchRequests", in: context) else { return }
            
            let request = SearchRequests(entity: entity, insertInto: context)
            
            request.request = searchRequest
            
            do {
                
                try context.save()
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else { return }
    }
    
    func searchRequestsData() -> [SearchRequests] {
        
        let context = context()
        
        var requests: [SearchRequests] = []
        
        let fetchRequest: NSFetchRequest<SearchRequests> = SearchRequests.fetchRequest()
        
        do {
            
            requests = try context.fetch(fetchRequest)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return requests.reversed()
        
    }
    
}
