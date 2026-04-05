import Foundation
import Observation

struct ReviewUiState {
    var isLoading: Bool = false
    var isEmpty: Bool = false
    var errorMessage: String? = nil
}

@Observable final class ReviewViewModel {
    private let getRandomKnowhowUseCase: GetRandomKnowhowUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteUseCase

    var uiState = ReviewUiState()
    var currentKnowhow: Knowhow? = nil
    var shownIds: [UUID] = []

    init(
        getRandomKnowhowUseCase: GetRandomKnowhowUseCase,
        toggleFavoriteUseCase: ToggleFavoriteUseCase
    ) {
        self.getRandomKnowhowUseCase = getRandomKnowhowUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
    }

    func loadNext() {
        uiState.isLoading = true
        do {
            if let knowhow = try getRandomKnowhowUseCase.execute(excludeIds: shownIds) {
                shownIds.append(knowhow.id)
                currentKnowhow = knowhow
                uiState = ReviewUiState(isLoading: false, isEmpty: false, errorMessage: nil)
            } else {
                currentKnowhow = nil
                uiState = ReviewUiState(isLoading: false, isEmpty: true, errorMessage: nil)
            }
        } catch {
            uiState = ReviewUiState(isLoading: false, isEmpty: false, errorMessage: error.localizedDescription)
        }
    }

    func onToggleFavorite(id: UUID, isFavorite: Bool) {
        do {
            try toggleFavoriteUseCase.execute(id: id, isFavorite: isFavorite)
            if currentKnowhow?.id == id {
                currentKnowhow?.isFavorite = isFavorite
            }
        } catch {
            uiState.errorMessage = error.localizedDescription
        }
    }

    func reset() {
        shownIds = []
        currentKnowhow = nil
        uiState = ReviewUiState()
        loadNext()
    }
}
