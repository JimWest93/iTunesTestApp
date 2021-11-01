import Foundation
import UIKit

class APIManager {
    
    static var shared: APIManager = {
        let instance = APIManager()
        return instance
    }()
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    //Получение списка альбомов по запросу, стандартный лимит 50
    func fetchAlbumsList(searchRequest: String, complition: @escaping ([Album]) -> ()) {
        
        let queryItems = [URLQueryItem(name: "term", value: searchRequest),
                          URLQueryItem(name: "entity", value: "album")]
        
        guard var urlComps = URLComponents(string: "https://itunes.apple.com/search") else { return }
        
        urlComps.queryItems = queryItems
        
        URLSession.shared.dataTask(with: urlComps.url!) { (data, response, error) in
            
            if let error = error {
                print(error)
            }
            
            guard let data = data else { return }
            
            do {
                let albums = try JSONDecoder().decode(AlbumsData.self, from: data)
                
                print(albums)
                
                DispatchQueue.main.async {
                    complition(albums.results)
                }
                
            } catch let jsonError {
                print("JSON error: ", jsonError)
            }
            
        }.resume()
        
    }
    
    //Получение списка треков с альбома по ID альбома
    func fetchTracks(collectionID: Int, complition: @escaping ([Song]) -> ()) {
        
        var songs: [Song] = []
        
        let queryItems = [URLQueryItem(name: "id", value: String(collectionID)),
                          URLQueryItem(name: "attribute", value: "albumTerm"),
                          URLQueryItem(name: "entity", value: "song")]
        
        guard var urlComps = URLComponents(string: "https://itunes.apple.com/lookup") else { return }
        
        urlComps.queryItems = queryItems
        
        URLSession.shared.dataTask(with: urlComps.url!) { (data, response, error) in
            
            if let error = error {
                print(error)
            }
            
            guard let data = data else { return }
            
            do {
                let tracks = try JSONDecoder().decode(SongsData.self, from: data)
                
                tracks.results.forEach { song in
                    if song.trackName != nil {
                        songs.append(song)
                    }
                }
                
                DispatchQueue.main.async {
                    complition(songs)
                }
                
            } catch let jsonError {
                print("JSON error: ", jsonError)
            }
            
        }.resume()
        
    }
    
    //Получение и кеширование изображений
    func fetchImage(imageUrl: String, complition: @escaping (UIImage) -> ()) {
        
        if let imageFromCache = self.imageCache.object(forKey: imageUrl as NSString) {
            
            complition(imageFromCache)
            
        } else {
            
            guard let url = URL(string: imageUrl) else { return }
            
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
                self?.imageCache.setObject(image, forKey: imageUrl as NSString)
                
            }
            dataTask.resume()
        }
    }
}
