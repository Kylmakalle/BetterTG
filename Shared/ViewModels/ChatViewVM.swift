// ChatViewVM.swift

import SwiftUI
import TDLibKit
import CollectionConcurrencyKit

class ChatViewVM: ObservableObject {
    let chat: Chat

    @Published var messages = [Message]()
    var offset = 0
    var retries = 0
    var loaded = 0
    let limit = 30

    let tdApi = TdApi.shared
    let logger = Logger(label: "ChatVM")

    let maxNumberOfRetries = 10

    init(chat: Chat) {
        self.chat = chat

        Task {
            try await self.update()
        }

        self.tdApi.client.run { data in
            do {
                let update = try TdApi.shared.decoder.decode(Update.self, from: data)

                switch update {
                    case let .updateNewMessage(newMessage):
                        if newMessage.message.chatId != chat.id { break }
                        self.logger.log("Got a new message: \(newMessage.message)")
                        DispatchQueue.main.async {
                            self.messages.append(newMessage.message)
                        }
                    default:
                        break
                }
            } catch {
                guard let tdError = error as? TDLibKit.Error else { return }
                self.logger.log("\(tdError.code) - \(tdError.message)", level: .error)
            }
        }
    }

    func update() async throws {
        retries = 0
        try await getMessages()
    }

    func getMessages() async throws {
        let chatHistory = try await self.tdApi.getChatHistory(
            chatId: self.chat.id,
            fromMessageId: 0,
            limit: limit,
            offset: -offset,
            onlyLocal: false
        )
        offset += chatHistory.totalCount

        DispatchQueue.main.async {
            self.messages = (chatHistory.messages?.reversed() ?? []).compactMap { msg in
                if self.messages.first(where: { msg == $0 }) == nil {
                    return msg
                }
                return nil
            } + self.messages
        }

        if offset % limit != 0 {
            retries += 1
            if retries != maxNumberOfRetries {
                try await getMessages()
            }
        }
    }

    func sendMessage(text: String) async throws {
        _ = try await tdApi.sendMessage(
            chatId: chat.id,
            inputMessageContent:
                    .inputMessageText(
                        .init(
                            clearDraft: true,
                            disableWebPagePreview: true,
                            text: FormattedText(
                                entities: [],
                                text: text)
                        )
                    ),
            messageThreadId: 0,
            options: nil,
            replyMarkup: nil,
            replyToMessageId: 0
        )
    }
}
