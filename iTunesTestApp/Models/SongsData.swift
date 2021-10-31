import Foundation

struct SongsData: Codable {
    let results: [Song]
}

struct Song: Codable {
    
    let trackName: String?
    let trackTimeMillis: Double?

    enum CodingKeys: String, CodingKey {
        case trackName
        case trackTimeMillis
    }

}
