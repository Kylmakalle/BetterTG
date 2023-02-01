// MessageView.swift

import SwiftUI
import TDLibKit

struct MessageView: View {
    
    @State var customMessage: CustomMessage
    
    @Binding var openedPhotoInfo: OpenedPhotoInfo?
    var rootNamespace: Namespace.ID?
    
    @EnvironmentObject var viewModel: ChatViewModel
    
    @State var recognized = false
    @State var recognizedText = "..."
    @State var isListeningVoiceNote = false
    @State var recognizeSpeech = false
    @Namespace var voiceNoteNamespace
    
    @State var isOutgoing = true
    @State var text = ""
    
    @State var forwardedWidth: Int = 0
    @State var replyWidth: Int = 0
    @State var contentWidth: Int = 0
    @State var textWidth: Int = 0
    @State var editWidth: Int = 0
    
    @State var textSize: CGSize = .zero
    @State var draggableTextSize: CGSize = .zero
    
    let recognizedTextId = "recognizedTextId"
    let playId = "playId"
    let currentTimeId = "currentTimeId"
    let durationId = "durationId"
    let chevronId = "chevronId"
    let speechId = "speechId"
    
    var body: some View {
        VStack(alignment: customMessage.message.isOutgoing ? .trailing : .leading, spacing: 1) {
            if let forwardedFrom = customMessage.forwardedFrom {
                HStack(alignment: .center, spacing: 0) {
                    Text("FF: ")
                        .foregroundColor(.white).opacity(0.5)
                    
                    Text(forwardedFrom)
                        .bold()
                }
                .padding(5)
                .background(backgroundColor(for: .forwarded))
                .cornerRadius(corners(for: .forwarded))
                .readSize { forwardedWidth = Int($0.width) }
            }
            
            if customMessage.replyUser != nil, customMessage.replyToMessage != nil {
                ReplyMessageView(customMessage: customMessage, type: .replied)
                    .padding(5)
                    .background(backgroundColor(for: .reply))
                    .cornerRadius(corners(for: .reply))
                    .readSize { replyWidth = Int($0.width) }
            }
            
            HStack(alignment: .bottom, spacing: 0) {
                if case .messageVoiceNote(let messageVoiceNote) = customMessage.message.content, isOutgoing {
                    voiceNoteSide(from: messageVoiceNote.voiceNote)
                }
                
                messageContent
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(1)
                    .background(backgroundColor(for: .content))
                    .cornerRadius(corners(for: .content))
                    .readSize { contentWidth = Int($0.width) }
                
                if case .messageVoiceNote(let messageVoiceNote) = customMessage.message.content, !isOutgoing {
                    voiceNoteSide(from: messageVoiceNote.voiceNote)
                }
            }
            
            messageText
                .multilineTextAlignment(.leading)
                .padding(8)
                .foregroundColor(.white)
                .background(backgroundColor(for: .text))
                .cornerRadius(corners(for: .text))
                .readSize { textWidth = Int($0.width) }
            
            if customMessage.message.editDate != 0 {
                Text("edited")
                    .font(.caption)
                    .foregroundColor(.white).opacity(0.5)
                    .padding(3)
                    .background(backgroundColor(for: .edit))
                    .cornerRadius(corners(for: .edit))
                    .readSize { editWidth = Int($0.width) }
            }
        }
        .onAppear {
            isOutgoing = customMessage.message.isOutgoing
        }
        .onReceive(nc.publisher(for: .messageEdited)) { notification in
            guard let messageEdited = notification.object as? UpdateMessageEdited,
                  messageEdited.chatId == customMessage.message.chatId,
                  messageEdited.messageId == customMessage.message.id
            else { return }
            
            Task {
                guard let customMessage = await viewModel.getCustomMessage(fromId: messageEdited.messageId)
                else { return }
                
                await MainActor.run {
                    withAnimation {
                        self.customMessage = customMessage
                    }
                }
            }
        }
    }
    
    func backgroundColor(for type: MessagePart) -> Color {
        switch type {
            case .text, .content:
                if viewModel.highlightedMessageId == customMessage.message.id {
                    return .white.opacity(0.5)
                }
                fallthrough
            default:
                return customMessage.sendFailed ? .red : .gray6
        }
    }
}
