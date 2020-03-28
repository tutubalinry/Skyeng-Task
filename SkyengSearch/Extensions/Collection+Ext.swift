import Foundation

extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        if indices.contains(index) {
            return self[index]
        }
        return nil
    }
}
