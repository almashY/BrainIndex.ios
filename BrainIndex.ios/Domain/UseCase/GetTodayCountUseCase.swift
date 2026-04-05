import Foundation

final class GetTodayCountUseCase {
    private let repository: KnowhowRepository

    init(repository: KnowhowRepository) {
        self.repository = repository
    }

    func execute() throws -> Int {
        try repository.getTodayCount()
    }
}
