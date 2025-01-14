// ChatViewModel+MessageActions.swift

import SwiftUI
import TDLibKit

extension ChatViewModel {
    func sendMessage() async {
        if !displayedImages.isEmpty {
            await sendMessagePhotos()
        } else if !editMessageText.characters.isEmpty {
            await editMessage()
        } else if !text.characters.isEmpty {
            await sendMessageText()
        } else {
            return
        }
        
        await MainActor.run {
            displayedImages.removeAll()
            editMessageText = ""
            text = ""
            replyMessage = nil
            editCustomMessage = nil
        }
    }
    
    func sendMessagePhoto(imageAsset: ImageAsset) {
        if let url = imageAsset.url {
            Task {
                await tdSendMessage(with: makeInputMessageContent(for: url))
            }
        }
    }
    
    func sendMessagePhotos() async {
        await tdSendChatAction(.chatActionUploadingPhoto(.init(progress: 0)))
        
        if displayedImages.count == 1, let photo = displayedImages.first {
            await tdSendMessage(with: makeInputMessageContent(for: photo.url))
        } else {
            let messageContents = displayedImages.map {
                makeInputMessageContent(for: $0.url)
            }
            toBeSentPhotosCount = displayedImages.count
            await tdSendMessageAlbum(with: messageContents)
        }
    }
    
    func sendMessageText() async {
        await tdSendMessage(with:
                .inputMessageText(
                    .init(
                        clearDraft: true,
                        disableWebPagePreview: true,
                        text: FormattedText(
                            entities: [],
                            text: text.string
                        )
                    )
                )
        )
    }
    
    func sendMessageVoiceNote(duration: Int, waveform: Data) async {
        await tdSendMessage(with:
                .inputMessageVoiceNote(
                    .init(
                        caption: FormattedText(
                            entities: [],
                            text: text.string
                        ),
                        duration: duration,
                        voiceNote: .inputFileLocal(.init(path: savedVoiceNoteUrl.path())),
                        waveform: waveform
                    )
                )
        )
        text = ""
    }
    
    func editMessage() async {
        guard let message = self.editCustomMessage?.message else { return }
        
        switch message.content {
            case .messageText:
                await tdEditMessageText(message)
            case .messagePhoto, .messageVoiceNote:
                await tdEditMessageCaption(message)
            default:
                log("Unsupported edit message type")
        }
    }
    
    func setEditMessageText(from message: Message?) {
        withAnimation {
            switch message?.content {
                case .messageText(let messageText):
                    editMessageText = messageText.text.text.attributedString
                case .messagePhoto(let messagePhoto):
                    editMessageText = messagePhoto.caption.text.attributedString
                case .messageVoiceNote(let messageVoiceNote):
                    editMessageText = messageVoiceNote.caption.text.attributedString
                default:
                    break
            }
        }
    }
    
    func deleteMessage(id: Int64, deleteForBoth: Bool) async {
        guard let customMessage = messages.first(where: { $0.message.id == id }) else { return }
        
        if customMessage.album.isEmpty {
            await tdDeleteMessages(ids: [id], deleteForBoth: deleteForBoth)
        } else {
            let ids = customMessage.album.map { $0.id }
            await tdDeleteMessages(ids: ids, deleteForBoth: deleteForBoth)
        }
    }
    
    func viewMessage(id: Int64) {
        Task {
            await tdViewMessages(ids: [id])
        }
    }
}
