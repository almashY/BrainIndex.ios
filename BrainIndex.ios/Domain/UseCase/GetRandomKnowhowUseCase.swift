import Foundation

final class GetRandomKnowhowUseCase {
    private let repository: KnowhowRepository

    init(repository: KnowhowRepository) {
        self.repository = repository
    }

    func execute(excludeIds: [UUID]) throws -> Knowhow? {
        try repository.getRandom(excludeIds: excludeIds)
    }
}
