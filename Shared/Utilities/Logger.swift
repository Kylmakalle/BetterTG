// Logger.swift

import Foundation
import os.log

struct Logger {
    private let logger: os.Logger
    private let label: String

    init(label: String) {
        self.logger = os.Logger(subsystem: "BetterTG", category: label)
        self.label = label
    }

    func log(_ message: String) {
        let date = Date.now.formatted(date: .omitted, time: .standard)
        logger.info("[\(date)] [\(label)] \(message)")
    }
}
