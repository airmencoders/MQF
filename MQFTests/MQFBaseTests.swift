//
//  MQFBaseTests.swift
//  MQFTests
//
//  Created by Christian Brechbuhl on 1/29/20.
//  Copyright © 2020 Airmen Coders, US Air Force - See INTENT.md for license type information. All rights reserved.
//

import XCTest
@testable import MQF
@testable import SwiftyJSON

class MQFBaseTests: XCTestCase {

    // MARK: MQFBase
    func testCreateBase(){
        let jsonString = "{\"name\":\"Charleston AFB Test\",\"id\":\"1\",\"presets\":[{\"name\":\"437/315 AW Pilot\",\"id\":\"KCHS-Pilot-Airland\",\"positions\":[\"Pilot\"],\"mqfs\":[{\"testNum\":30,\"file\":\"c17-Pilot-1nov\"},{\"testNum\":5,\"file\":\"c17-KCHS-Pilot\"}],\"testTotal\":35}]}"
        let json = JSON(parseJSON: jsonString)
        let base = MQFBase.init(json: json)
        
        XCTAssertEqual(base.name, "Charleston AFB Test", "Wrong base name")
        XCTAssertEqual(base.presets.count, 1, "Wrong number of presets")
    }
    
    func testCreateEmptyBase(){
        let base = MQFBase()
        XCTAssertEqual(base.name, "Unknown", "Wrong base name")
        XCTAssertEqual(base.presets.count, 0, "Wrong number of presets")
    }
    
    func testCreateBaseWithBadJSON(){
        let jsonString = "[]"
            let json = JSON(parseJSON: jsonString)
            let base = MQFBase.init(json: json)
            
            XCTAssertEqual(base.name, "Base not found", "Wrong base name")
            XCTAssertEqual(base.presets.count, 0, "Wrong number of presets")
    }
    

}
