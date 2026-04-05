import Foundation

struct Knowhow: Identifiable {
    let id: UUID
    var title: String
    var body: String
    var tags: [String]
    var isFavorite: Bool
    let createdAt: Date
    var updatedAt: Date
}
