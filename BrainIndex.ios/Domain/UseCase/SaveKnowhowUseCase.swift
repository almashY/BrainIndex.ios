import Foundation

final class SaveKnowhowUseCase {
    private let repository: KnowhowRepository

    init(repository: KnowhowRepository) {
        self.repository = repository
    }

    func execute(knowhow: Knowhow) throws {
        if let _ = try repository.getById(id: knowhow.id) {
            try repository.update(knowhow: knowhow)
        } else {
            try repository.insert(knowhow: knowhow)
        }
    }
}
