import Foundation
import Observation

struct QuizUiState {
    var isLoading: Bool = false
    var errorMessage: String? = nil
}

@Observable final class QuizViewModel {
    private let generateQuizUseCase: GenerateQuizUseCase

    var uiState = QuizUiState()
    var questions: [QuizQuestion] = []
    var currentIndex: Int = 0
    var selectedAnswer: String? = nil
    var score: Int = 0
    var isFinished: Bool = false

    var currentQuestion: QuizQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var isAnswered: Bool { selectedAnswer != nil }

    init(generateQuizUseCase: GenerateQuizUseCase) {
        self.generateQuizUseCase = generateQuizUseCase
    }

    func startQuiz() {
        uiState = QuizUiState(isLoading: true, errorMessage: nil)
        do {
            questions = try generateQuizUseCase.execute(count: 5)
            currentIndex = 0
            score = 0
            selectedAnswer = nil
            isFinished = false
            uiState = QuizUiState(isLoading: false, errorMessage: nil)
        } catch {
            uiState = QuizUiState(isLoading: false, errorMessage: error.localizedDescription)
        }
    }

    func onAnswerSelected(answer: String) {
        guard selectedAnswer == nil else { return }
        selectedAnswer = answer
        if answer == currentQuestion?.correctAnswer {
            score += 1
        }
    }

    func onNextQuestion() {
        if currentIndex + 1 < questions.count {
            currentIndex += 1
            selectedAnswer = nil
        } else {
            isFinished = true
        }
    }

    func onRetry() {
        startQuiz()
    }
}
