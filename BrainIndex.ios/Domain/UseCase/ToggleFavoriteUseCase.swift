import Foundation

final class ToggleFavoriteUseCase {
    private let repository: KnowhowRepository

    init(repository: KnowhowRepository) {
        self.repository = repository
    }

    func execute(id: UUID, isFavorite: Bool) throws {
        try repository.updateFavorite(id: id, isFavorite: isFavorite)
    }
}
