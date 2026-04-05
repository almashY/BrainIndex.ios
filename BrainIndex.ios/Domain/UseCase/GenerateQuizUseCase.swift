import Foundation

enum QuizError: Error, LocalizedError {
    case notEnoughItems

    var errorDescription: String? {
        switch self {
        case .notEnoughItems:
            return "クイズを生成するには4件以上のノウハウが必要です"
        }
    }
}

final class GenerateQuizUseCase {
    private let repository: KnowhowRepository

    init(repository: KnowhowRepository) {
        self.repository = repository
    }

    func execute(count: Int = 5) throws -> [QuizQuestion] {
        let allItems = try repository.getRandomList(count: count * 2)
        guard allItems.count >= 4 else {
            throw QuizError.notEnoughItems
        }

        let questionItems = Array(allItems.prefix(count))
        let allTitles = allItems.map { $0.title }

        return questionItems.compactMap { item -> QuizQuestion? in
            let questionText = item.body
                .split(separator: "\n", maxSplits: 1)
                .first
                .map(String.init) ?? item.body
            guard !questionText.isEmpty else { return nil }

            let wrongChoices = Array(
                allTitles.filter { $0 != item.title }.shuffled().prefix(3)
            )
            guard wrongChoices.count == 3 else { return nil }

            let choices = ([item.title] + wrongChoices).shuffled()
            return QuizQuestion(
                questionText: questionText,
                correctAnswer: item.title,
                choices: choices,
                sourceKnowhowId: item.id
            )
        }
    }
}
