// ChatView.swift

import SwiftUI
import TDLibKit

struct ChatView: View {
    
    @StateObject var viewModel: ChatViewModel
    
    @FocusState var focused
    
    @State var isScrollToBottomButtonShown = false
    
    let scroll = "chatScroll"
    @State var scrollOnFocus = true
    
    @Environment(\.isPreview) var isPreview
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var rootViewModel: RootViewModel
    
    init(customChat: CustomChat) {
        self._viewModel = StateObject(wrappedValue: ChatViewModel(customChat: customChat))
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
        .environmentObject(viewModel)
        .task {
            await viewModel.loadLiveActivity()
        }
        .onDisappear {
            LiveActivityManager.endAllActivities()
        }
        .onReceive(nc.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Task { await viewModel.loadLiveActivity() }
        }
    }
    
    func scrollToLastOnFocus() {
        if scrollOnFocus {
            viewModel.scrollToLast()
        }
    }
}
