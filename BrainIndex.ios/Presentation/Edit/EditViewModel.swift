import Foundation
import Observation

struct EditUiState {
    var isLoading: Bool = false
    var isSaving: Bool = false
    var errorMessage: String? = nil
}

enum SaveResult {
    case success
    case error
}

@Observable final class EditViewModel {
    private let getKnowhowByIdUseCase: GetKnowhowByIdUseCase
    private let saveKnowhowUseCase: SaveKnowhowUseCase

    var uiState = EditUiState()
    var title: String = ""
    var body: String = ""
    var tags: [String] = []
    var isFavorite: Bool = false
    var saveResult: SaveResult? = nil

    private var currentKnowhow: Knowhow? = nil

    init(
        getKnowhowByIdUseCase: GetKnowhowByIdUseCase,
        saveKnowhowUseCase: SaveKnowhowUseCase
    ) {
        self.getKnowhowByIdUseCase = getKnowhowByIdUseCase
        self.saveKnowhowUseCase = saveKnowhowUseCase
    }

    func loadKnowhow(id: UUID) {
        uiState.isLoading = true
        do {
            if let knowhow = try getKnowhowByIdUseCase.execute(id: id) {
                currentKnowhow = knowhow
                title = knowhow.title
                body = knowhow.body
                tags = knowhow.tags
                isFavorite = knowhow.isFavorite
            }
            uiState.isLoading = false
        } catch {
            uiState = EditUiState(isLoading: false, isSaving: false, errorMessage: error.localizedDescription)
        }
    }

    func onTagAdd(tag: String) {
        let trimmed = tag.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !tags.contains(trimmed) else { return }
        tags.append(trimmed)
    }

    func onTagRemove(tag: String) {
        tags.removeAll { $0 == tag }
    }

    func onToggleFavorite() {
        isFavorite.toggle()
    }

    func onSave() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        guard !trimmedTitle.isEmpty else {
            uiState.errorMessage = "タイトルを入力してください"
            return
        }
        uiState.isSaving = true
        let now = Date()
        let knowhowToSave: Knowhow
        if let existing = currentKnowhow {
            knowhowToSave = Knowhow(
                id: existing.id,
                title: trimmedTitle,
                body: body,
                tags: tags,
                isFavorite: isFavorite,
                createdAt: existing.createdAt,
                updatedAt: now
            )
        } else {
            knowhowToSave = Knowhow(
                id: UUID(),
                title: trimmedTitle,
                body: body,
                tags: tags,
                isFavorite: isFavorite,
                createdAt: now,
                updatedAt: now
            )
        }
        do {
            try saveKnowhowUseCase.execute(knowhow: knowhowToSave)
            uiState.isSaving = false
            saveResult = .success
        } catch {
            uiState = EditUiState(isLoading: false, isSaving: false, errorMessage: error.localizedDescription)
            saveResult = .error
        }
    }
}
