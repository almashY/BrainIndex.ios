import Foundation

final class GetKnowhowListUseCase {
    private let repository: KnowhowRepository

    init(repository: KnowhowRepository) {
        self.repository = repository
    }

    func execute(query: String, tag: String?, favoriteOnly: Bool) throws -> [Knowhow] {
        var list: [Knowhow]
        if !query.isEmpty {
            list = try repository.search(query: query)
        } else {
            list = try repository.getAll()
        }
        if let tag {
            list = list.filter { $0.tags.contains(tag) }
        }
        if favoriteOnly {
            list = list.filter { $0.isFavorite }
        }
        return list
    }
}
