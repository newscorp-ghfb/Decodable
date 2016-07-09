//
//  DecodingError.swift
//  Decodable
//
//  Created by Johannes Lund on 2015-07-17.
//  Copyright © 2015 anviking. All rights reserved.
//

import Foundation

public enum DecodingError: ErrorProtocol, Equatable {
    
    public struct Metadata: Equatable {
        
        public init(path: [String] = [], object: AnyObject, rootObject: AnyObject? = nil) {
            self.path = path
            self.object = object
            self.rootObject = rootObject
        }
        
        /// The JSON key path to the object that failed to be decoded
        public var path: [String]
        
        /// The JSON object that failed to be decoded
        public let object: AnyObject
        
        /// The root JSON object for which the `path` can be used to find `object`
        public var rootObject: AnyObject?
        
        /// Represents the path to the object that failed decoding with "." as a separator.
        public var formattedPath: String {
            return path.joined(separator: ".")
        }
    }
    
    case TypeMismatch(expected: Any.Type, actual: Any.Type, Metadata)
    case MissingKey(String, Metadata)
    case RawRepresentableInitializationError(rawValue: Any, Metadata)
    case WrappedError(ErrorProtocol, Metadata)
    
    public var metadata: Metadata {
        get {
            switch self {
            case .TypeMismatch(expected: _, actual: _, let metadata):
                return metadata
            case .MissingKey(_, let metadata):
                return metadata
            case .RawRepresentableInitializationError(_, let metadata):
                return metadata
            case .WrappedError(_, let metadata):
                return metadata
            }
        }
        
        set {
            switch self {
            case let .TypeMismatch(expected, actual, _):
                self = .TypeMismatch(expected: expected, actual: actual, newValue)
            case let .MissingKey(key, _):
                self = .MissingKey(key, newValue)
            case let .RawRepresentableInitializationError(rawValue, _):
                self = RawRepresentableInitializationError(rawValue: rawValue, newValue)
            case let .WrappedError(error, _):
                self = .WrappedError(error, newValue)
            }
        }

    }
    
    public var debugDescription: String {
        switch self {
        case let .TypeMismatch(expected, actual, metadata):
            return "TypeMismatchError expected: \(expected) but \(metadata.object) is of type \(actual) in \(metadata.formattedPath)"
        case let .MissingKey(key, metadata):
            return "Missing Key \(key) in \(metadata.formattedPath) \(metadata.object)"
        case let .RawRepresentableInitializationError(rawValue, metadata):
            return "RawRepresentableInitializationError: \(rawValue) could not be used to initialize \("TYPE"). (path: \(metadata.formattedPath))" // FIXME
        case let .WrappedError(error, _):
            return "\(error)"
        }
    }
    
}


// Allow types to be used in pattern matching
// E.g case TypeMismatchError(NSNull.self, _, _) but be careful
// You probably rather want to modify the decode-closure
// There are overloads for this
public func ~=<T>(lhs: T.Type, rhs: Any.Type) -> Bool {
    return lhs == rhs
}

// FIXME: I'm not sure about === equality
public func ==(lhs: DecodingError.Metadata, rhs: DecodingError.Metadata) -> Bool {
    return lhs.object === rhs.object
        && lhs.path == rhs.path
        && lhs.rootObject === rhs.rootObject
}

public func ==(lhs: DecodingError, rhs: DecodingError) -> Bool {
    switch (lhs, rhs) {
    case let (.TypeMismatch(expected, actual, metadata), .TypeMismatch(expected2, actual2, metadata2)):
        return expected == expected2
            && actual == actual2
            && metadata == metadata2
    case let (.MissingKey(key, metadata), .MissingKey(key2, metadata2)):
        return key == key2
            && metadata == metadata2
    case let (.RawRepresentableInitializationError(rawValue, metadata), .RawRepresentableInitializationError(rawValue2, metadata2)):
        // FIXME: Might be strange
        switch (rawValue, rawValue2, metadata == metadata2) {
        case let (a as AnyObject, b as AnyObject, true):
            return a === b
        default:
            return false
        }
    case (.WrappedError, .WrappedError):
        // FIXME: What to do?
        print("FIXME: WrappedError equality is unimplemented/not supported")
        return false
    default:
        return false
    }
}

