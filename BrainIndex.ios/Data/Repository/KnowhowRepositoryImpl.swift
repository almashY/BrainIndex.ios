import Foundation
import SwiftData

final class KnowhowRepositoryImpl: KnowhowRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func getAll() throws -> [Knowhow] {
        let descriptor = FetchDescriptor<KnowhowModel>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor).map { $0.toDomain() }
    }

    func search(query: String) throws -> [Knowhow] {
        let descriptor = FetchDescriptor<KnowhowModel>(
            predicate: #Predicate<KnowhowModel> { model in
                model.title.localizedStandardContains(query) ||
                model.body.localizedStandardContains(query)
            },
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor).map { $0.toDomain() }
    }

    func filterByTag(tag: String) throws -> [Knowhow] {
        let all = try getAll()
        return all.filter { $0.tags.contains(tag) }
    }

    func getById(id: UUID) throws -> Knowhow? {
        let descriptor = FetchDescriptor<KnowhowModel>(
            predicate: #Predicate<KnowhowModel> { $0.id == id }
        )
        return try modelContext.fetch(descriptor).first?.toDomain()
    }

    func insert(knowhow: Knowhow) throws {
        let model = knowhow.toModel()
        modelContext.insert(model)
        try modelContext.save()
    }

    func update(knowhow: Knowhow) throws {
        let id = knowhow.id
        let descriptor = FetchDescriptor<KnowhowModel>(
            predicate: #Predicate<KnowhowModel> { $0.id == id }
        )
        guard let model = try modelContext.fetch(descriptor).first else { return }
        model.title = knowhow.title
        model.body = knowhow.body
        model.tags = knowhow.tags.joined(separator: ",")
        model.isFavorite = knowhow.isFavorite
        model.updatedAt = knowhow.updatedAt
        try modelContext.save()
    }

    func delete(id: UUID) throws {
        let descriptor = FetchDescriptor<KnowhowModel>(
            predicate: #Predicate<KnowhowModel> { $0.id == id }
        )
        guard let model = try modelContext.fetch(descriptor).first else { return }
        modelContext.delete(model)
        try modelContext.save()
    }

    func getRandom(excludeIds: [UUID]) throws -> Knowhow? {
        let all = try getAll()
        return all.filter { !excludeIds.contains($0.id) }.randomElement()
    }

    func getRandomList(count: Int) throws -> [Knowhow] {
        let all = try getAll()
        return Array(all.shuffled().prefix(count))
    }

    func updateFavorite(id: UUID, isFavorite: Bool) throws {
        let descriptor = FetchDescriptor<KnowhowModel>(
            predicate: #Predicate<KnowhowModel> { $0.id == id }
        )
        guard let model = try modelContext.fetch(descriptor).first else { return }
        model.isFavorite = isFavorite
        try modelContext.save()
    }

    func getTodayCount() throws -> Int {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let descriptor = FetchDescriptor<KnowhowModel>(
            predicate: #Predicate<KnowhowModel> { model in
                model.createdAt >= startOfDay && model.createdAt < endOfDay
            }
        )
        return try modelContext.fetchCount(descriptor)
    }

    func getStreakDays() throws -> Int {
        let descriptor = FetchDescriptor<KnowhowModel>()
        let models = try modelContext.fetch(descriptor)
        guard !models.isEmpty else { return 0 }

        let calendar = Calendar.current
        let dates = Set(models.map { calendar.startOfDay(for: $0.createdAt) })

        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())
        while dates.contains(checkDate) {
            streak += 1
            guard let prev = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
            checkDate = prev
        }
        return streak
    }
}
