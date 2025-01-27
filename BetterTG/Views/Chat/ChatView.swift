// ChatView.swift

import SwiftUI
import TDLibKit

struct ChatView: View {
    
    var viewModel: ChatViewModel
    
    @FocusState var focused
    
    @State var isScrollToBottomButtonShown = false
    
    var scroll = "chatScroll"
    @State var scrollOnFocus = true
    
    @Environment(\.isPreview) var isPreview
    @Environment(\.dismiss) var dismiss
    
    @Environment(RootViewModel.self) var rootViewModel
    
    init(customChat: CustomChat) {
        self.viewModel = ChatViewModel(customChat: customChat)
    }
    
    var body: some View {
        Group {
            if isPreview {
                bodyView
            } else {
                if viewModel.initLoadingMessages {
                    messagesPlaceholder
                } else if !viewModel.initLoadingMessages, viewModel.messages.isEmpty {
                    Text("No messages")
                        .center(.vertically)
                        .fullScreenBackground(color: .black)
                } else {
                    bodyView
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if !isPreview {
                ChatBottomArea(focused: $focused)
                    .if(viewModel.initLoadingMessages) {
                        $0.redacted(reason: .placeholder)
                    }
            }
        }
        .toolbar {
            toolbar
        }
        .navigationBarTitleDisplayMode(.inline)
        .environment(viewModel)
        .task {
            await viewModel.loadLiveActivity()
        }
        .onDisappear {
            LiveActivityManager.endAllActivities()
        }
        .onReceive(nc.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Task { await viewModel.loadLiveActivity() }
        }
        .onChange(of: viewModel.editCustomMessage) { _, editCustomMessage in
            guard let editCustomMessage else { return }
            viewModel.setEditMessageText(from: editCustomMessage.message)
        }
        .onChange(of: viewModel.replyMessage) {
            Task {
                await viewModel.updateDraft()
            }
        }
    }
    
    func scrollToLastOnFocus() {
        if scrollOnFocus {
            viewModel.scrollToLast()
        }
    }
}
