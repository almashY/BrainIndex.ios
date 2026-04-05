import Foundation

protocol KnowhowRepository {
    func getAll() throws -> [Knowhow]
    func search(query: String) throws -> [Knowhow]
    func filterByTag(tag: String) throws -> [Knowhow]
    func getById(id: UUID) throws -> Knowhow?
    func insert(knowhow: Knowhow) throws
    func update(knowhow: Knowhow) throws
    func delete(id: UUID) throws
    func getRandom(excludeIds: [UUID]) throws -> Knowhow?
    func getRandomList(count: Int) throws -> [Knowhow]
    func updateFavorite(id: UUID, isFavorite: Bool) throws
    func getTodayCount() throws -> Int
    func getStreakDays() throws -> Int
}
