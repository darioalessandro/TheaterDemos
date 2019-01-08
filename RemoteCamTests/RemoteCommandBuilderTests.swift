//
//  RemoteCommandBuilderTests.swift
//  Actors
//
//  Created by Dario Talarico on 1/7/19.
//  Copyright © 2019 dario. All rights reserved.
//

import Foundation
import Quick
import Nimble

enum TestError: Error {
    case error
}

class RemoteCommandBuilderTests: QuickSpec {
    
    override func spec() {
        
        describe("RemoteCommandBuilder") {
            it("serialize and deserialize TakePic command") {
                do {
                    let takePic = TakePic()
                    let serializedEnvelope = try RemoteCommandBuilder.shared.serialize(payload: takePic)
                    let decodedCommand = try RemoteCommandBuilder.shared.deserialize(serializedData: serializedEnvelope)
                    switch (decodedCommand) {
                    case is TakePic:
                      expect(true).to(be(true))
                    default:
                        throw TestError.error
                    }
                } catch {
                    expect(true).to(be(false))
                }
            }
        }
    }
}
