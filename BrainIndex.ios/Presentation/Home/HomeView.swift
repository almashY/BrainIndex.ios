import SwiftUI

struct HomeView: View {
    @Environment(HomeViewModel.self) private var viewModel
    @Environment(DIContainer.self) private var di
    @State private var showEditSheet = false
    @State private var editViewModel: EditViewModel? = nil
    @State private var selectedKnowhowId: UUID? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBarView(
                    query: viewModel.searchQuery,
                    onQueryChange: { viewModel.onSearchQueryChange(query: $0) }
                )
                TagFilterBarView(
                    allTags: viewModel.allTags,
                    selectedTag: viewModel.selectedTag,
                    onTagSelected: { viewModel.onTagSelected(tag: $0) }
                )
                if viewModel.uiState.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.uiState.knowhowList.isEmpty {
                    emptyView
                } else {
                    knowhowList
                }
            }
            .navigationTitle("BrainIndex")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        selectedKnowhowId = nil
                        editViewModel = di.makeEditViewModel()
                        showEditSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.onToggleFavoriteFilter()
                    } label: {
                        Image(systemName: viewModel.showFavoriteOnly ? "heart.fill" : "heart")
                            .foregroundStyle(viewModel.showFavoriteOnly ? Color.red : Color.primary)
                    }
                }
            }
            .onAppear { viewModel.loadKnowhowList() }
            .sheet(isPresented: $showEditSheet, onDismiss: { viewModel.loadKnowhowList() }) {
                if let editVM = editViewModel {
                    EditView(viewModel: editVM, knowhowId: selectedKnowhowId)
                }
            }
        }
    }

    private var knowhowList: some View {
        List {
            ForEach(viewModel.uiState.knowhowList) { item in
                Button {
                    selectedKnowhowId = item.id
                    editViewModel = di.makeEditViewModel()
                    showEditSheet = true
                } label: {
                    KnowhowRowView(knowhow: item)
                }
                .buttonStyle(.plain)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.onDeleteKnowhow(id: item.id)
                    } label: {
                        Label("削除", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
    }

    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("ノウハウがありません")
                .foregroundStyle(.secondary)
            Text("右上の＋ボタンから追加しましょう")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct SearchBarView: View {
    let query: String
    let onQueryChange: (String) -> Void
    @State private var localQuery: String = ""

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
            TextField("検索", text: $localQuery)
                .onChange(of: localQuery) { _, new in onQueryChange(new) }
        }
        .padding(8)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
        .padding(.top, 8)
        .onAppear { localQuery = query }
    }
}

private struct TagFilterBarView: View {
    let allTags: [String]
    let selectedTag: String?
    let onTagSelected: (String?) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                TagChip(label: "すべて", isSelected: selectedTag == nil) {
                    onTagSelected(nil)
                }
                ForEach(allTags, id: \.self) { tag in
                    TagChip(label: tag, isSelected: selectedTag == tag) {
                        onTagSelected(selectedTag == tag ? nil : tag)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

private struct TagChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color(.secondarySystemBackground))
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .clipShape(Capsule())
        }
    }
}

struct KnowhowRowView: View {
    let knowhow: Knowhow

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(knowhow.title)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                if knowhow.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(Color.red)
                        .font(.caption)
                }
            }
            if !knowhow.body.isEmpty {
                Text(knowhow.body)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            if !knowhow.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(knowhow.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.accentColor.opacity(0.15))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}
