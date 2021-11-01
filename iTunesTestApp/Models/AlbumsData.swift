import Foundation

struct AlbumsData: Codable {
    let results: [Album]
}

struct Album: Codable {
    
    let collectionID: Int?
    let artistName, collectionName : String?
    let artworkUrl60, artworkUrl100: String?
    let primaryGenreName: String?
    let releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case collectionID = "collectionId"
        case artistName, collectionName
        case artworkUrl60, artworkUrl100, primaryGenreName, releaseDate
    }

}
