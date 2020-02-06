//
//  DataManagerTests.swift
//  MQFTests
//
//  Created by Christian Brechbuhl on 1/29/20.
//  Copyright © 2020 Airmen Coders, US Air Force - See INTENT.md for license type information. All rights reserved.
//

import XCTest
@testable import MQF
@testable import SwiftyJSON


class DataManagerTests: XCTestCase {

      override func setUp() {

                      DataManager.shared.load(file: "test-available")
        }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAvailableCrewPositions(){
        let cp = DataManager.shared.availableCrewPositions
        XCTAssertEqual(cp, ["Pilot", "Loadmaster", "Boom"], "Wrong crew positions")
    }
    
    func testAvailableMDS(){
        let mds = DataManager.shared.availableMDS
        
        XCTAssertEqual(mds, ["C-17", "KC-135"], "Wrong MDS")
    }
    
    func testGetPresets(){
        let presets = DataManager.shared.getPresets()
        XCTAssertEqual(presets.count, 17, "Wrong number of presets")
    }
    
    func testLoadBadPath(){
        DataManager.shared.availableMQFs = [MQFData]()
        DataManager.shared.load(file: "jkhkhkhj")
        XCTAssertEqual(DataManager.shared.availableMQFs.count, 0, "Found mqfs in non existant file")
    }

}
