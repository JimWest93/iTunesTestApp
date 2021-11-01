import Foundation

extension Array where Element == Album {
    func sortAlphabetically() -> [Album] {
        return self.sorted { $0.collectionName.localizedCaseInsensitiveCompare($1.collectionName) == ComparisonResult.orderedAscending }
    }
}
