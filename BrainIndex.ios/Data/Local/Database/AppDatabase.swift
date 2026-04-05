import Foundation
import SwiftData

struct AppDatabase {
    static func makeContainer() throws -> ModelContainer {
        let schema = Schema([KnowhowModel.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try ModelContainer(for: schema, configurations: [config])
    }
}
