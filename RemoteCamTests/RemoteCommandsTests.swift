//
//  SerializationTests.swift
//  RemoteCamTests
//
//  Created by Dario Talarico on 1/7/19.
//  Copyright © 2019 dario. All rights reserved.
//

import Foundation
import Quick
import Nimble

class RemoteCommandsTests: QuickSpec {
    
    override func spec() {
        
        describe("RemoteCommandsTests") {
            it("serialize and deserialize TakePic command") {
                do {
                    let envelope = RemoteShutterEnvelope.with  {
                        $0.takePic = TakePic()
                        $0.contentType = RemoteShutterEnvelope.ContentType.takePic
                    }
                    let serializedEnvelope = try envelope.serializedData()
                    let decodedEnvelope = try RemoteShutterEnvelope(serializedData: serializedEnvelope)
                    expect(decodedEnvelope.contentType).to(equal(RemoteShutterEnvelope.ContentType.takePic))
                } catch {
                    expect(true).to(be(false))
                }
            }
        }
    }
}
