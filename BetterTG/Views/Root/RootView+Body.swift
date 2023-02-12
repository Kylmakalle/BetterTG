// RootView+Body.swift

import SwiftUI

extension RootView {
    @ViewBuilder var bodyView: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 8) {
                    switch viewModel.searchScope {
                        case .chats:
                            chatsList(viewModel.filteredSortedChats(query.lowercased()), chatList: .chatListMain)
                        case .global:
                            chatsList(viewModel.searchedGlobalChats)
                    }
                }
                .padding(.top, 8)
                .animation(value: viewModel.mainChats)
                .animation(value: viewModel.searchedGlobalChats)
            }
            .navigationTitle("BetterTG")
            .navigationDestination(isPresented: $showArchivedChats) {
                archivedChatsView
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(systemImage: "square.stack") {
                        showArchivedChats = true
                    }
                }
            }
        }
        .searchable(text: $query, prompt: "Search chats...")
        .searchScopes($viewModel.searchScope) {
            ForEach(SearchScope.allCases, id: \.self) { scope in
                Text(scope.rawValue)
            }
        }
        .onSubmit(of: .search) {
            viewModel.searchGlobalChats(query.lowercased())
        }
        .onChange(of: viewModel.searchScope) { scope in
            guard scope == .global else { return }
            
            if query.isEmpty {
                viewModel.searchScope = .chats
            } else {
                viewModel.searchGlobalChats(query)
            }
        }
        .onChange(of: query) { _ in
            if query.isEmpty {
                viewModel.searchScope = .chats
            }
        }
        .onChange(of: scenePhase) { newPhase in
            viewModel.handleScenePhase(newPhase)
        }
        .confirmationDialog(
            "Are you sure you want to delete chat with \(confirmedChat?.title ?? "User")?",
            isPresented: $showConfirmChatDelete
        ) {
            Button("Delete", role: .destructive) {
                guard let id = confirmedChat?.id else { return }
                Task {
                    await viewModel.tdDeleteChatHistory(chatId: id, forAll: deleteChatForAllUsers)
                }
            }
        }
        .overlay {
            if viewModel.openedItems != nil {
                ItemsPreview()
                    .zIndex(1)
            }
        }
    }
}