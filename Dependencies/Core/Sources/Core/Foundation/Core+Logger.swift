//
//  Core+Logger.swift
//  Core
//
//  Created by Juan Sanzone on 13/03/2025.
//

import Foundation

extension Core.Logger {
    public static var minimumLogLevel: LogLevel = .debug
    public static weak var listener: Core.Logger.ListenerProtocol?
}

extension Core.Logger {
    public protocol ListenerProtocol: AnyObject {
        func didLog(message: String)
    }
}

extension Core.Logger {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()
    
    private static let isDebug: Bool = {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }()
    
    private static func shouldLog(_ level: LogLevel) -> Bool {
        return level.rawValue >= minimumLogLevel.rawValue
    }
    
    private static func log(_ message: String, level: LogLevel, file: String, line: Int, function: String) {
        guard shouldLog(level) else { return }
        
        let timestamp = dateFormatter.string(from: Date())
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[\(timestamp)] [\(level.emoji) \(level.name)] [\(fileName):\(line)] \(function) - \(message)"
        
        print(logMessage)
        listener?.didLog(message: logMessage)
    }
    
    private static func logError(_ error: Error, message: String?, file: String, line: Int, function: String) {
        guard shouldLog(.error) else { return }
        
        let timestamp = dateFormatter.string(from: Date())
        let fileName = (file as NSString).lastPathComponent
        let errorDescription = "\(error.localizedDescription) (\(String(describing: type(of: error))))"
        let fullMessage = message.map { "\($0) - " } ?? ""
        let logMessage = "[\(timestamp)] [❌ ERROR] [\(fileName):\(line)] \(function) - \(fullMessage)Error: \(errorDescription)"
        
        print(logMessage)
        listener?.didLog(message: logMessage)
    }
}

extension Core.Logger {
    public static func debug(_ message: String, file: String = #file, line: Int = #line, function: String = #function) {
        guard isDebug else { return }
        log(message, level: .debug, file: file, line: line, function: function)
    }

    public static func info(_ message: String, file: String = #file, line: Int = #line, function: String = #function) {
        log(message, level: .info, file: file, line: line, function: function)
    }

    public static func warning(_ message: String, file: String = #file, line: Int = #line, function: String = #function) {
        log(message, level: .warning, file: file, line: line, function: function)
    }

    public static func error(_ error: Error, message: String? = nil, file: String = #file, line: Int = #line, function: String = #function) {
        logError(error, message: message, file: file, line: line, function: function)
    }

    public static func fatal(_ message: String, file: String = #file, line: Int = #line, function: String = #function) -> Never {
        log(message, level: .fatal, file: file, line: line, function: function)
        fatalError(message)
    }
}

public extension Core.Logger {
    enum LogLevel: Int, Comparable {
        case debug = 0
        case info = 1
        case warning = 2
        case error = 3
        case fatal = 4
        
        public var name: String {
            switch self {
            case .debug: return "DEBUG"
            case .info: return "INFO"
            case .warning: return "WARNING"
            case .error: return "ERROR"
            case .fatal: return "FATAL"
            }
        }
        
        public var emoji: String {
            switch self {
            case .debug: return "🐛"
            case .info: return "ℹ️"
            case .warning: return "⚠️"
            case .error: return "❌"
            case .fatal: return "💀"
            }
        }
        
        public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
    }
}
