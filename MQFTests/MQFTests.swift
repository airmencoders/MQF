//
//  MQFTests.swift
//  MQFTests
//
//  Created by Christian Brechbuhl on 5/25/19.
//

import XCTest
@testable import MQF
@testable import SwiftyJSON

class MQFTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreatePreset(){
           let jsonString = "{\"name\":\"437/315 AW Pilot Test\",\"id\":\"KCHS-Pilot-Airland\",\"positions\":[\"Pilot\"],\"mqfs\":[{\"testNum\":30,\"file\":\"c17-Pilot-1nov\"},{\"testNum\":5,\"file\":\"c17-KCHS-Pilot\"}],\"testTotal\":35}"
           let json = JSON(parseJSON: jsonString)
           let preset = MQFPreset.init(json: json)
           
        XCTAssertEqual(preset.name, "437/315 AW Pilot Test", "Wrong preset name")
        XCTAssertEqual(preset.crewPositions, ["Pilot"], "Wrong crew positions")
        XCTAssertEqual(preset.mqfs.count, 2, "Wrong number of MQFs")
       }

    
    func testCreateBase(){
        let jsonString = "{\"name\":\"Charleston AFB Test\",\"id\":\"1\",\"presets\":[{\"name\":\"437/315 AW Pilot\",\"id\":\"KCHS-Pilot-Airland\",\"positions\":[\"Pilot\"],\"mqfs\":[{\"testNum\":30,\"file\":\"c17-Pilot-1nov\"},{\"testNum\":5,\"file\":\"c17-KCHS-Pilot\"}],\"testTotal\":35}]}"
        let json = JSON(parseJSON: jsonString)
        let base = MQFBase.init(json: json)
        
        XCTAssertEqual(base.name, "Charleston AFB Test", "Wrong base name")
        XCTAssertEqual(base.presets.count, 1, "Wrong number of presets")
    }
    

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
