import SwiftUI

struct EditView: View {
    @Bindable var viewModel: EditViewModel
    let knowhowId: UUID?
    @State private var tagInput: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("タイトル") {
                    TextField("タイトルを入力", text: $viewModel.title)
                }

                Section("内容 (Markdown)") {
                    TextEditor(text: $viewModel.body)
                        .frame(minHeight: 150)
                }

                Section("タグ") {
                    HStack {
                        TextField("タグを追加", text: $tagInput)
                            .onSubmit {
                                viewModel.onTagAdd(tag: tagInput)
                                tagInput = ""
                            }
                        Button {
                            viewModel.onTagAdd(tag: tagInput)
                            tagInput = ""
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                        .disabled(tagInput.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    if !viewModel.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(viewModel.tags, id: \.self) { tag in
                                    HStack(spacing: 4) {
                                        Text(tag).font(.caption)
                                        Button {
                                            viewModel.onTagRemove(tag: tag)
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.caption)
                                        }
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.accentColor.opacity(0.15))
                                    .clipShape(Capsule())
                                }
                            }
                        }
                    }
                }

                Section {
                    Toggle("お気に入り", isOn: Binding(
                        get: { viewModel.isFavorite },
                        set: { _ in viewModel.onToggleFavorite() }
                    ))
                }
            }
            .navigationTitle(knowhowId == nil ? "新規作成" : "編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("保存") { viewModel.onSave() }
                        .disabled(viewModel.uiState.isSaving)
                }
            }
            .onAppear {
                if let id = knowhowId {
                    viewModel.loadKnowhow(id: id)
                }
            }
            .onChange(of: viewModel.saveResult) { _, result in
                if result == .success { dismiss() }
            }
            .alert("エラー", isPresented: Binding(
                get: { viewModel.uiState.errorMessage != nil },
                set: { if !$0 { viewModel.uiState.errorMessage = nil } }
            )) {
                Button("OK") { viewModel.uiState.errorMessage = nil }
            } message: {
                Text(viewModel.uiState.errorMessage ?? "")
            }
        }
    }
}
