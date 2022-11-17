// TdApi+Extension.swift

import Foundation
import TDLibKit

extension TdApi {
    static var shared = TdApi(client: TdClientImpl(completionQueue: .global(qos: .userInitiated)))
    private static let logger = Logger(label: "TdApi")

    // swiftlint:disable function_body_length
    func startTdLibUpdateHandler() {
        client.run { data in
            do {
                let update = try TdApi.shared.decoder.decode(Update.self, from: data)

                switch update {
                    case let .updateAuthorizationState(updateAuthorizationState):
                        switch updateAuthorizationState.authorizationState {
                            case .authorizationStateWaitTdlibParameters:
                                Task {
                                    var url = try FileManager.default.url(
                                        for: .applicationSupportDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: true)
                                    let dir = url.path()
                                    url.append(path: "td")

                                    _ = try await self.setTdlibParameters(
                                        apiHash: Secret.apiHash,
                                        apiId: Secret.apiId,
                                        applicationVersion: SystemUtils.info(key: "CFBundleShortVersionString"),
                                        databaseDirectory: dir,
                                        databaseEncryptionKey: Data(),
                                        deviceModel: await SystemUtils.getDeviceModel(),
                                        enableStorageOptimizer: true,
                                        filesDirectory: dir,
                                        ignoreFileNames: false,
                                        systemLanguageCode: "en-US",
                                        systemVersion: SystemUtils.osVersion,
                                        useChatInfoDatabase: true,
                                        useFileDatabase: true,
                                        useMessageDatabase: true,
                                        useSecretChats: true,
                                        useTestDc: false
                                    )
                                }
//                            case .authorizationStateWaitEncryptionKey:
//                                Task {
//                                    try? await self.checkDatabaseEncryptionKey(encryptionKey: Data())
//                                }
                            case .authorizationStateReady:
                                break
//                                Task {
//                                    _ = try await self.loadChats(chatList: .chatListMain, limit: 10)
//                                    _ = try await self.loadChats(chatList: .chatListArchive, limit: 10)
//                                }
                            case .authorizationStateClosed:
                                TdApi.shared = TdApi(client: TdClientImpl(completionQueue: .global()))
                                TdApi.shared.startTdLibUpdateHandler()
                            default:
                                break
                        }
                    default:
                        break
                }
            } catch {
                guard let tdError = error as? TDLibKit.Error else { return }
                TdApi.logger.log("TdLibUpdateHandler: \(tdError.code) - \(tdError.message)", level: .error)
            }
        }
    }
}
