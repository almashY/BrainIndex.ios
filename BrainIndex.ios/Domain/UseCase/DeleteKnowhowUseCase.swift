import Foundation

final class DeleteKnowhowUseCase {
    private let repository: KnowhowRepository

    init(repository: KnowhowRepository) {
        self.repository = repository
    }

    func execute(id: UUID) throws {
        try repository.delete(id: id)
    }
}
