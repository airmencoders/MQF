//
//  QKSessionTests.swift
//  MQFTests
//
//  Created by Christian Brechbuhl on 1/30/20.
//  Copyright © 2020 Airmen Coders, US Air Force - See INTENT.md for license type information. All rights reserved.
//

import XCTest
@testable import MQF
@testable import SwiftyJSON

class QKSessionTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStartWithNoSession(){
        do {
            let session = try QKSession.default.start()
            
        } catch error {
            <#statements#>
        }
        
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
