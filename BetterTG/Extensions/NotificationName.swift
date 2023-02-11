// NotificationName.swift

import Foundation

extension Notification.Name {
    static let waitTdlibParameters = Self("waitTdlibParameters")
    static let waitPhoneNumber = Self("waitPhoneNumber")
    static let waitEmailAddress = Self("waitEmailAddress")
    static let waitEmailCode = Self("waitEmailCode")
    static let waitCode = Self("waitCode")
    static let waitOtherDeviceConfirmation = Self("waitOtherDeviceConfirmation")
    static let waitRegistration = Self("waitRegistration")
    static let waitPassword = Self("waitPassword")
    static let ready = Self("ready")
    static let loggingOut = Self("loggingOut")
    static let closed = Self("closed")
    static let closing = Self("closing")
    static let newMessage = Self("newMessage")
    static let messageSendAcknowledged = Self("messageSendAcknowledged")
    static let messageSendSucceeded = Self("messageSendSucceeded")
    static let messageSendFailed = Self("messageSendFailed")
    static let messageSendContent = Self("messageSendContent")
    static let messageEdited = Self("messageEdited")
    static let messageIsPinned = Self("messageIsPinned")
    static let messageInteractionInfo = Self("messageInteractionInfo")
    static let messageContentOpened = Self("messageContentOpened")
    static let messageMentionRead = Self("messageMentionRead")
    static let messageUnreadReactions = Self("messageUnreadReactions")
    static let messageLiveLocationViewed = Self("messageLiveLocationViewed")
    static let newChat = Self("newChat")
    static let chatTitle = Self("chatTitle")
    static let chatPhoto = Self("chatPhoto")
    static let chatPermissions = Self("chatPermissions")
    static let chatLastMessage = Self("chatLastMessage")
    static let chatPosition = Self("chatPosition")
    static let chatReadInbox = Self("chatReadInbox")
    static let chatReadOutbox = Self("chatReadOutbox")
    static let chatActionBar = Self("chatActionBar")
    static let chatAvailableReactions = Self("chatAvailableReactions")
    static let chatDraftMessage = Self("chatDraftMessage")
    static let chatMessageSender = Self("chatMessageSender")
    static let chatMessageAutoDeleteTime = Self("chatMessageAutoDeleteTime")
    static let chatMessageTtl = Self("chatMessageTtl")
    static let chatNotificationSettings = Self("chatNotificationSettings")
    static let chatPendingJoinRequests = Self("chatPendingJoinRequests")
    static let chatReplyMarkup = Self("chatReplyMarkup")
    static let chatTheme = Self("chatTheme")
    static let chatUnreadMentionCount = Self("chatUnreadMentionCount")
    static let chatUnreadReactionCount = Self("chatUnreadReactionCount")
    static let chatVideoChat = Self("chatVideoChat")
    static let chatDefaultDisableNotification = Self("chatDefaultDisableNotification")
    static let chatHasProtectedContent = Self("chatHasProtectedContent")
    static let chatIsTranslatable = Self("chatIsTranslatable")
    static let chatHasScheduledMessages = Self("chatHasScheduledMessages")
    static let chatIsBlocked = Self("chatIsBlocked")
    static let chatIsMarkedAsUnread = Self("chatIsMarkedAsUnread")
    static let chatFilters = Self("chatFilters")
    static let chatOnlineMemberCount = Self("chatFilters")
    static let forumTopicInfo = Self("forumTopicInfo")
    static let scopeNotificationSettings = Self("scopeNotificationSettings")
    static let notification = Self("notification")
    static let notificationGroup = Self("notificationGroup")
    static let activeNotifications = Self("activeNotifications")
    static let havePendingNotifications = Self("havePendingNotifications")
    static let deleteMessages = Self("deleteMessages")
    static let chatAction = Self("chatAction")
    static let userStatus = Self("userStatus")
    static let user = Self("user")
    static let basicGroup = Self("basicGroup")
    static let supergroup = Self("supergroup")
    static let secretChat = Self("secretChat")
    static let userFullInfo = Self("userFullInfo")
    static let basicGroupFullInfo = Self("basicGroupFullInfo")
    static let supergroupFullInfo = Self("supergroupFullInfo")
    static let serviceNotification = Self("serviceNotification")
    static let file = Self("file")
    static let fileGenerationStart = Self("fileGenerationStart")
    static let fileGenerationStop = Self("fileGenerationStop")
    static let fileDownloads = Self("fileDownloads")
    static let fileAddedToDownloads = Self("fileAddedToDownloads")
    static let fileDownload = Self("fileDownload")
    static let fileRemovedFromDownloads = Self("fileRemovedFromDownloads")
    static let call = Self("call")
    static let groupCall = Self("groupCall")
    static let groupCallParticipant = Self("groupCallParticipant")
    static let newCallSignalingData = Self("newCallSignalingData")
    static let userPrivacySettingRules = Self("userPrivacySettingRules")
    static let unreadMessageCount = Self("unreadMessageCount")
    static let unreadChatCount = Self("unreadChatCount")
    static let option = Self("option")
    static let stickerSet = Self("stickerSet")
    static let installedStickerSets = Self("installedStickerSets")
    static let trendingStickerSets = Self("trendingStickerSets")
    static let recentStickers = Self("recentStickers")
    static let favoriteStickers = Self("favoriteStickers")
    static let savedAnimations = Self("savedAnimations")
    static let savedNotificationSounds = Self("savedNotificationSounds")
    static let selectedBackground = Self("selectedBackground")
    static let chatThemes = Self("chatThemes")
    static let languagePackStrings = Self("languagePackStrings")
    static let connectionState = Self("connectionState")
    static let termsOfService = Self("termsOfService")
    static let usersNearby = Self("usersNearby")
    static let attachmentMenuBots = Self("attachmentMenuBots")
    static let webAppMessageSent = Self("webAppMessageSent")
    static let activeEmojiReactions = Self("activeEmojiReactions")
    static let defaultReactionType = Self("defaultReactionType")
    static let diceEmojis = Self("diceEmojis")
    static let animatedEmojiMessageClicked = Self("animatedEmojiMessageClicked")
    static let animationSearchParameters = Self("animationSearchParameters")
    static let suggestedActions = Self("suggestedActions")
    static let autosaveSettings = Self("autosaveSettings")
    static let newInlineQuery = Self("newInlineQuery")
    static let newChosenInlineResult = Self("newChosenInlineResult")
    static let newCallbackQuery = Self("newCallbackQuery")
    static let newInlineCallbackQuery = Self("newInlineCallbackQuery")
    static let newShippingQuery = Self("newShippingQuery")
    static let newPreCheckoutQuery = Self("newPreCheckoutQuery")
    static let newCustomEvent = Self("newCustomEvent")
    static let newCustomQuery = Self("newCustomQuery")
    static let poll = Self("poll")
    static let pollAnswer = Self("pollAnswer")
    static let chatMember = Self("chatMember")
    static let newChatJoinRequest = Self("newChatJoinRequest")
    
    static let localIsListeningVoice = Self("customIsListeningVoice")
    static let localRecognizeSpeech = Self("customRecognizeSpeech")
}
