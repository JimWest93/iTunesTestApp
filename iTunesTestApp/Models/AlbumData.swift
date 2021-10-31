import Foundation

struct AlbumData: Codable {
    let results: [Results]
}

struct Results: Codable {
    
    let collectionID: Int?
    let artistName, collectionName : String?
    let collectionViewURL: String?
    let artworkUrl60, artworkUrl100: String?
    let primaryGenreName: String?
    let releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case collectionID = "collectionId"
        case artistName, collectionName
        case collectionViewURL = "collectionViewUrl"
        case artworkUrl60, artworkUrl100, primaryGenreName, releaseDate
    }

}
