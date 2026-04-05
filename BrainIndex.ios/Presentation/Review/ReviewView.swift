import SwiftUI

struct ReviewView: View {
    @Environment(ReviewViewModel.self) private var viewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.uiState.isLoading {
                    ProgressView()
                } else if viewModel.uiState.isEmpty {
                    allShownView
                } else if let knowhow = viewModel.currentKnowhow {
                    reviewCard(knowhow: knowhow)
                } else {
                    startView
                }
            }
            .navigationTitle("復習")
            .onAppear {
                if viewModel.currentKnowhow == nil && !viewModel.uiState.isEmpty {
                    viewModel.loadNext()
                }
            }
        }
    }

    private var startView: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.accentColor)
            Text("復習を始めましょう")
                .font(.title2)
            Button("スタート") {
                viewModel.loadNext()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var allShownView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.green)
            Text("すべてのノウハウを確認しました")
                .font(.title3)
                .multilineTextAlignment(.center)
            Button("最初からやり直す") {
                viewModel.reset()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    private func reviewCard(knowhow: Knowhow) -> some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(knowhow.title)
                            .font(.title2.bold())
                        Spacer()
                        Button {
                            viewModel.onToggleFavorite(id: knowhow.id, isFavorite: !knowhow.isFavorite)
                        } label: {
                            Image(systemName: knowhow.isFavorite ? "heart.fill" : "heart")
                                .foregroundStyle(knowhow.isFavorite ? .red : .secondary)
                                .font(.title2)
                        }
                    }

                    if !knowhow.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(knowhow.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.accentColor.opacity(0.15))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }

                    Divider()

                    Text(knowhow.body)
                        .font(.body)
                }
                .padding()
            }

            Divider()

            HStack {
                Text("\(viewModel.shownIds.count)件確認済み")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Button("次へ") {
                    viewModel.loadNext()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
