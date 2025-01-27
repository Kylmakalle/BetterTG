// RootView+ChatsListItem.swift

import SwiftUI
import TDLibKit

extension RootView {
    @ViewBuilder func chatsListItem(
        for customChat: CustomChat,
        redacted: Bool = false,
        chatList: ChatList
    ) -> some View {
        HStack {
            if let isPinned = customChat.positions.first(where: { $0.list == chatList })?.isPinned, isPinned {
                Button(systemImage: "pin.fill") {
                    viewModel.togglePinned(chatId: customChat.chat.id, chatList: chatList, value: !isPinned)
                }
                .font(.title2)
                .foregroundColor(.white)
                .padding(.leading, 10)
            }
            
            if !redacted {
                chatsListPhoto(for: customChat.chat)
            } else {
                Circle()
                    .frame(width: 64)
                    .overlay {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .unredacted()
                    }
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(customChat.chat.title)
                    .font(.title2)
                    .foregroundColor(.white)
                
                lastOrDraftMessage(for: customChat)
            }
            .lineLimit(1)
            
            if customChat.unreadCount != 0 {
                Spacer()
                
                Circle()
                    .fill(.blue)
                    .frame(width: 32, height: 32)
                    .overlay {
                        Text("\(customChat.unreadCount)")
                            .font(.callout)
                            .foregroundColor(.white)
                            .minimumScaleFactor(0.5)
                    }
                    .padding(.trailing, 10)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(5)
        .background(.gray6)
        .cornerRadius(20)
        .padding(.horizontal, 10)
    }
}
