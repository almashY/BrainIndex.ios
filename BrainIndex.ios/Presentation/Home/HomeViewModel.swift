import Foundation
import Observation

struct HomeUiState {
    var knowhowList: [Knowhow] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
}

@Observable final class HomeViewModel {
    private let getKnowhowListUseCase: GetKnowhowListUseCase
    private let deleteKnowhowUseCase: DeleteKnowhowUseCase

    var uiState = HomeUiState()
    var searchQuery: String = ""
    var selectedTag: String? = nil
    var showFavoriteOnly: Bool = false
    var allTags: [String] = []

    init(
        getKnowhowListUseCase: GetKnowhowListUseCase,
        deleteKnowhowUseCase: DeleteKnowhowUseCase
    ) {
        self.getKnowhowListUseCase = getKnowhowListUseCase
        self.deleteKnowhowUseCase = deleteKnowhowUseCase
    }

    func loadKnowhowList() {
        uiState.isLoading = true
        do {
            let filtered = try getKnowhowListUseCase.execute(
                query: searchQuery,
                tag: selectedTag,
                favoriteOnly: showFavoriteOnly
            )
            let all = try getKnowhowListUseCase.execute(query: "", tag: nil, favoriteOnly: false)
            allTags = Array(Set(all.flatMap { $0.tags })).sorted()
            uiState = HomeUiState(knowhowList: filtered, isLoading: false, errorMessage: nil)
        } catch {
            uiState = HomeUiState(knowhowList: [], isLoading: false, errorMessage: error.localizedDescription)
        }
    }

    func onSearchQueryChange(query: String) {
        searchQuery = query
        loadKnowhowList()
    }

    func onTagSelected(tag: String?) {
        selectedTag = tag
        loadKnowhowList()
    }

    func onToggleFavoriteFilter() {
        showFavoriteOnly.toggle()
        loadKnowhowList()
    }

    func onDeleteKnowhow(id: UUID) {
        do {
            try deleteKnowhowUseCase.execute(id: id)
            loadKnowhowList()
        } catch {
            uiState.errorMessage = error.localizedDescription
        }
    }
}
