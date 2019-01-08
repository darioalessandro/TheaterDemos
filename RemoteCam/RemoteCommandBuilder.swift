//
//  RemoteCommandBuilder.swift
//  Actors
//
//  Created by Dario Talarico on 1/7/19.
//  Copyright © 2019 dario. All rights reserved.
//

import Foundation

enum RemoteCommandBuilderError: Error {
    case unknownCommand
}

class RemoteCommandBuilder {
    
    public static let shared = RemoteCommandBuilder()
    
    public func buildWith(payload: Any) throws -> RemoteShutterEnvelope {
        switch payload {
        case is TakePic:
            return RemoteShutterEnvelope.with {
                $0.takePic = TakePic()
                $0.contentType = RemoteShutterEnvelope.ContentType.takePic
            }
        default:
            throw RemoteCommandBuilderError.unknownCommand
        }
    }
    
    public func serialize(payload: Any) throws -> Data {
        let envelope = try buildWith(payload: payload)
        return try envelope.serializedData()
    }
    
    public func deserialize(serializedData: Data) throws -> Any {
        let envelope = try RemoteShutterEnvelope(serializedData: serializedData)
        switch envelope.contentType {
        case RemoteShutterEnvelope.ContentType.takePic:
            return envelope.takePic
        default:
            throw RemoteCommandBuilderError.unknownCommand
        }
    }
    
}
