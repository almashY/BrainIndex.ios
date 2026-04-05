import SwiftUI

struct QuizView: View {
    @Environment(QuizViewModel.self) private var viewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.uiState.isLoading {
                    ProgressView("クイズを生成中...")
                } else if let errorMessage = viewModel.uiState.errorMessage {
                    errorView(message: errorMessage)
                } else if viewModel.isFinished {
                    scoreView
                } else if viewModel.questions.isEmpty {
                    startView
                } else if let question = viewModel.currentQuestion {
                    questionView(question: question)
                }
            }
            .navigationTitle("クイズ")
        }
    }

    private var startView: some View {
        VStack(spacing: 24) {
            Image(systemName: "questionmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.accentColor)
            Text("クイズに挑戦しよう")
                .font(.title2)
            Text("登録したノウハウから5問出題されます")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("スタート") {
                viewModel.startQuiz()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(.orange)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button("もう一度試す") {
                viewModel.startQuiz()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    private func questionView(question: QuizQuestion) -> some View {
        VStack(spacing: 0) {
            progressBar

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Q\(viewModel.currentIndex + 1) / \(viewModel.questions.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(question.questionText)
                        .font(.title3)
                        .fixedSize(horizontal: false, vertical: true)

                    VStack(spacing: 12) {
                        ForEach(question.choices, id: \.self) { choice in
                            choiceButton(choice: choice, question: question)
                        }
                    }

                    if viewModel.isAnswered {
                        nextButton
                    }
                }
                .padding()
            }
        }
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(.systemGray5))
                Rectangle()
                    .fill(Color.accentColor)
                    .frame(
                        width: geo.size.width * CGFloat(viewModel.currentIndex + 1) / CGFloat(max(viewModel.questions.count, 1))
                    )
                    .animation(.easeInOut, value: viewModel.currentIndex)
            }
        }
        .frame(height: 4)
    }

    private func choiceButton(choice: String, question: QuizQuestion) -> some View {
        let isSelected = viewModel.selectedAnswer == choice
        let isCorrect = choice == question.correctAnswer
        let showResult = viewModel.isAnswered

        return Button {
            viewModel.onAnswerSelected(answer: choice)
        } label: {
            HStack {
                Text(choice)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                if showResult {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : (isSelected ? "xmark.circle.fill" : ""))
                        .foregroundStyle(isCorrect ? .green : .red)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(choiceBackground(isSelected: isSelected, isCorrect: isCorrect, showResult: showResult))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(choiceStroke(isSelected: isSelected, isCorrect: isCorrect, showResult: showResult), lineWidth: 2)
            )
        }
        .disabled(viewModel.isAnswered)
    }

    private func choiceBackground(isSelected: Bool, isCorrect: Bool, showResult: Bool) -> Color {
        if showResult {
            if isCorrect { return Color.green.opacity(0.15) }
            if isSelected { return Color.red.opacity(0.15) }
        }
        return Color(.secondarySystemBackground)
    }

    private func choiceStroke(isSelected: Bool, isCorrect: Bool, showResult: Bool) -> Color {
        if showResult {
            if isCorrect { return .green }
            if isSelected { return .red }
        }
        return Color(.separator)
    }

    private var nextButton: some View {
        Button(viewModel.currentIndex + 1 < viewModel.questions.count ? "次の問題" : "結果を見る") {
            viewModel.onNextQuestion()
        }
        .buttonStyle(.borderedProminent)
        .frame(maxWidth: .infinity)
    }

    private var scoreView: some View {
        VStack(spacing: 24) {
            Image(systemName: scoreIcon)
                .font(.system(size: 64))
                .foregroundStyle(scoreColor)

            Text("結果")
                .font(.title2.bold())

            Text("\(viewModel.score) / \(viewModel.questions.count)")
                .font(.system(size: 56, weight: .bold))

            Text(scoreMessage)
                .font(.title3)
                .foregroundStyle(.secondary)

            Button("もう一度挑戦") {
                viewModel.onRetry()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }

    private var scoreIcon: String {
        let ratio = Double(viewModel.score) / Double(max(viewModel.questions.count, 1))
        if ratio >= 0.8 { return "star.fill" }
        if ratio >= 0.6 { return "hand.thumbsup.fill" }
        return "arrow.clockwise.circle.fill"
    }

    private var scoreColor: Color {
        let ratio = Double(viewModel.score) / Double(max(viewModel.questions.count, 1))
        if ratio >= 0.8 { return .yellow }
        if ratio >= 0.6 { return .green }
        return .orange
    }

    private var scoreMessage: String {
        let ratio = Double(viewModel.score) / Double(max(viewModel.questions.count, 1))
        if ratio >= 0.8 { return "素晴らしい！" }
        if ratio >= 0.6 { return "よくできました！" }
        return "もう少し復習しましょう"
    }
}
