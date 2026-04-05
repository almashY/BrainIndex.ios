import Foundation

final class GetKnowhowByIdUseCase {
    private let repository: KnowhowRepository

    init(repository: KnowhowRepository) {
        self.repository = repository
    }

    func execute(id: UUID) throws -> Knowhow? {
        try repository.getById(id: id)
    }
}
