//
//  PTLogger.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 24.8.2023.
//

import Foundation
import OSLog

/// MSDK logger that has 3 levels: debug, warning, and error
///
public class PTLogger {
    
    public enum LogLevel: Int {
        case debug
        case warning
        case error
    }
    
    private static let logger = Logger()
    
    /// The global MSDK log level
    public static var globalLevel: LogLevel = .debug
    
    
    /// Logging MSDK message based on the globalLevel
    /// - Parameters:
    ///   - message: message to be logged
    ///   - level: on what log level to show
    static func log(message: String, level: LogLevel) {
        switch level {
        case .debug:
            if globalLevel == level {
                logger.info("Paytrail SDK(debug) - \(message)")
            }
        case .warning:
            logger.warning("Paytrail SDK(warning): \(message)")
        case .error:
            logger.error("Paytrail SDK(error): \(message)")
        }
    }
}
