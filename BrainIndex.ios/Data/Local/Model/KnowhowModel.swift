import Foundation
import SwiftData

@Model
final class KnowhowModel {
    @Attribute(.unique) var id: UUID
    var title: String
    var body: String
    var tags: String
    var isFavorite: Bool
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        body: String,
        tags: String,
        isFavorite: Bool,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.tags = tags
        self.isFavorite = isFavorite
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    func toDomain() -> Knowhow {
        Knowhow(
            id: id,
            title: title,
            body: body,
            tags: tags.isEmpty ? [] : tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
            isFavorite: isFavorite,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Knowhow {
    func toModel() -> KnowhowModel {
        KnowhowModel(
            id: id,
            title: title,
            body: body,
            tags: tags.joined(separator: ","),
            isFavorite: isFavorite,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
