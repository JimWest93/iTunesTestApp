import Foundation
import UIKit

class APIManager {
    
    static var shared: APIManager = {
        let instance = APIManager()
        return instance
    }()
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    func fetchAlbumsList(searchRequest: String, complition: @escaping ([Results]) -> ()) {
        
        guard let searchString = searchRequest.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.lowercased() else { return }
        let urlString = "https://itunes.apple.com/search?term=\(searchString)&entity=album"
        guard let url = URL(string: urlString) else {
            print("Wrong URL")
            return }
        
        print(url)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print(error)
            }
            
            guard let data = data else { return }
            
            do {
                let albums = try JSONDecoder().decode(AlbumData.self, from: data)
                
                DispatchQueue.main.async {
                    complition(albums.results)
                }
                
            } catch let jsonError {
                print("JSON error: ", jsonError)
            }
            
        }.resume()
        
    }
    
    func fetchTracks(collectionID: Int?, complition: @escaping ([Song]) -> ()) {
        
        let urlString: String = {
            if let ID = collectionID {
                return "https://itunes.apple.com/lookup?id=\(ID)&attribute=albumTerm&entity=song"
            }
            return ""
        }()
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print(error)
            }
            
            guard let data = data else { return }
            
            do {
                let albums = try JSONDecoder().decode(SongsData.self, from: data)
                
                DispatchQueue.main.async {
                    complition(albums.results)
                }
                
            } catch let jsonError {
                print("JSON error: ", jsonError)
            }
            
        }.resume()
        
    }
    
    func fetchImage(imageUrl: String?, complition: @escaping (UIImage) -> ()) {
        
        guard let stringURL = imageUrl else { return }
        
        if let imageFromCache = self.imageCache.object(forKey: stringURL as NSString) {
            
            complition(imageFromCache)
            
        } else {
            
            DispatchQueue.global().async {
                
                guard let url = URL(string: stringURL) else { return }
                
                let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5)
                let dataTask = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                    
                    if let error = error {
                        print(error)
                    }
                    
                    guard let data = data else { return }
                    
                    guard let image = UIImage(data: data) else { return }
                    
                    DispatchQueue.main.async {
                        complition(image)
                    }
                    self?.imageCache.setObject(image, forKey: stringURL as NSString)
                    
                }
                dataTask.resume()
            }
        }
    }
}
