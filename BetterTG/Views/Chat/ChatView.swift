// ChatView.swift

import SwiftUI
import TDLibKit

struct ChatView: View {
    
    @StateObject var viewModel: ChatViewModel
    @State var isPreview: Bool
    
    @Binding var openedPhotoInfo: OpenedPhotoInfo?
    var rootNamespace: Namespace.ID?
    
    @FocusState var focused
    @State var showPicker = false
    
    @State var isScrollToBottomButtonShown = false
    
    let scroll = "chatScroll"
    @State private var scrollOnFocus = true
    
    init(customChat: CustomChat,
         isPreview: Bool = false,
         openedPhotoInfo: Binding<OpenedPhotoInfo?>? = nil,
         rootNamespace: Namespace.ID? = nil
    ) {
        self._viewModel = StateObject(wrappedValue: ChatViewModel(customChat: customChat))
        self._isPreview = State(initialValue: isPreview)
        self.rootNamespace = rootNamespace
        
        if let openedPhotoInfo {
            self._openedPhotoInfo = Binding(projectedValue: openedPhotoInfo)
        } else {
            self._openedPhotoInfo = Binding(get: { nil }, set: { _ in })
        }
    }
    
    var body: some View {
        Group {
            if viewModel.initLoadingMessages, viewModel.messages.isEmpty {
                ScrollView {
                    LazyVStack(spacing: 5) {
                        messagesList(CustomMessage.placeholder(), redacted: true)
                            .redacted(reason: .placeholder)
                    }
                }
                .flippedUpsideDown()
                .scrollDisabled(true)
                .background(.black)
            } else if !viewModel.initLoadingMessages, viewModel.messages.isEmpty {
                Text("No messages")
                    .center(.vertically)
                    .fullScreenBackground(color: .black)
            } else {
                bodyView
            }
        }
        .safeAreaInset(edge: .bottom) {
            if !isPreview {
                ChatBottomArea(
                    focused: $focused,
                    openedPhotoInfo: $openedPhotoInfo,
                    rootNamespace: rootNamespace
                )
                .if(viewModel.initLoadingMessages) {
                    $0.redacted(reason: .placeholder)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 0) {
                    Text(viewModel.customChat.chat.title)
                    
                    Group {
                        if viewModel.actionStatus.isEmpty {
                            Text(viewModel.onlineStatus)
                        } else {
                            Text(viewModel.actionStatus)
                        }
                    }
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .top),
                            removal: .move(edge: .bottom)
                        )
                        .combined(with: .opacity)
                    )
                    .font(.caption)
                    .foregroundColor(
                        !viewModel.actionStatus.isEmpty || viewModel.onlineStatus == "online" ? .blue : .gray
                    )
                    .animation(.default, value: viewModel.actionStatus)
                    .animation(.default, value: viewModel.onlineStatus)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Group {
                    if let chatPhoto = viewModel.customChat.chat.photo {
                        AsyncTdImage(id: chatPhoto.big.id) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .contextMenu {
                                    Button("Save", systemImage: "square.and.arrow.down") {
                                        guard let uiImage = UIImage(contentsOfFile: chatPhoto.big.local.path)
                                        else { return }
                                        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                                    }
                                } preview: {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                }
                        } placeholder: {
                            PlaceholderView(
                                userId: viewModel.customChat.user.id,
                                title: viewModel.customChat.user.firstName,
                                fontSize: 20
                            )
                        }
                    } else {
                        PlaceholderView(
                            userId: viewModel.customChat.user.id,
                            title: viewModel.customChat.user.firstName,
                            fontSize: 20
                        )
                    }
                }
                .frame(width: 32, height: 32)
                .clipShape(Circle())
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .environmentObject(viewModel)
    }
    
    var bodyView: some View {
        ScrollViewReader { scrollViewProxy in
            messagesScroll
                .coordinateSpace(name: scroll)
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    let maxY = Int(value.maxY)
                    if maxY > 800 {
                        scrollOnFocus = false
                        if isScrollToBottomButtonShown == false {
                            withAnimation {
                                isScrollToBottomButtonShown = true
                            }
                        }
                    } else {
                        scrollOnFocus = true
                        if isScrollToBottomButtonShown == true {
                            withAnimation {
                                isScrollToBottomButtonShown = false
                            }
                        }
                    }
                    
                    if viewModel.loadingMessages { return }
                    
                    let minY = Int(value.minY)
                    if minY > -1000 {
                        Task {
                            await viewModel.loadMessages()
                        }
                    }
                }
                .onReceive(nc.publisher(for: .customIsListeningVoice)) { _ in scrollToLastOnFocus() }
                .onReceive(nc.publisher(for: .customRecognizeSpeech)) { _ in scrollToLastOnFocus() }
                .onChange(of: focused) { _ in scrollToLastOnFocus() }
                .onChange(of: viewModel.messages) { _ in scrollToLastOnFocus() }
                .onChange(of: viewModel.displayedImages) { _ in scrollToLastOnFocus() }
                .onChange(of: viewModel.replyMessage) { reply in
                    if reply == nil {
                        scrollToLastOnFocus()
                    } else if reply != nil {
                        focused = true
                    }
                }
                .onChange(of: viewModel.editCustomMessage) { edit in
                    if edit == nil {
                        scrollToLastOnFocus()
                    } else if edit != nil {
                        focused = true
                    }
                }
                .onAppear {
                    viewModel.scrollViewProxy = scrollViewProxy
                }
                .onTapGesture {
                    focused = false
                }
        }
        .background(.black)
        .dropDestination(for: SelectedImage.self) { items, _ in
            viewModel.displayedImages = Array(items.prefix(10))
            return true
        }
        .overlay(alignment: .bottomTrailing) {
            if isScrollToBottomButtonShown {
                Image(systemName: "chevron.down")
                    .padding(10)
                    .background(.black)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(.blue, lineWidth: 1)
                    }
                    .padding(.trailing)
                    .padding(.bottom, 5)
                    .onTapGesture {
                        viewModel.scrollToLast()
                    }
                    .transition(.move(edge: .trailing))
            }
        }
        .onDisappear {
            viewModel.mediaPlayer.stop()
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
