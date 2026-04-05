import Foundation

struct QuizQuestion {
    let questionText: String
    let correctAnswer: String
    let choices: [String]
    let sourceKnowhowId: UUID
}
