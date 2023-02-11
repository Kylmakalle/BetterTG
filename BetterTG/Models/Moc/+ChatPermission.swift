// +ChatPermission.swift

import SwiftUI
import TDLibKit

extension ChatPermissions {
    static let moc = ChatPermissions(
        canAddWebPagePreviews: false,
        canChangeInfo: false,
        canInviteUsers: false,
        canManageTopics: false,
        canPinMessages: false,
        canSendAudios: false,
        canSendDocuments: false,
        canSendMessages: false,
        canSendOtherMessages: false,
        canSendPhotos: false,
        canSendPolls: false,
        canSendVideoNotes: false,
        canSendVideos: false,
        canSendVoiceNotes: false
    )
}
