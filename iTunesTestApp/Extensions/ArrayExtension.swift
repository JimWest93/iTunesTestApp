import Foundation

extension Array where Element == Results {
    
    func sortAlphabetically() -> [Results] {
        return self.sorted { $0.collectionName?.localizedCaseInsensitiveCompare($1.collectionName ?? "") == ComparisonResult.orderedAscending }
    }
    
}
