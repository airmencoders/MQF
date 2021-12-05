//
//  MQFUITests.swift
//  MQFUITests
//
//  Created by Christian Brechbuhl on 5/25/19.
//
//
//xcodebuild -workspace MQF.xcworkspace -scheme "MQF"  -destination 'platform=iOS Simulator,name=iPhone 11,OS=13.2.2' test

import XCTest
import MQF
class MQFUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let app = XCUIApplication()
                  app.launchArguments.append("ui-testing")
                  app.launch()
   
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        //XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Only works if the app is first run
    func testSetUp() {
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
                                        
        
      
        let app = XCUIApplication()
          app.launchArguments.append("ui-testing-setup")
           app.launch()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Begin"]/*[[".cells.staticTexts[\"Begin\"]",".staticTexts[\"Begin\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Charleston AFB - 437/315 AW Pilot"]/*[[".cells.staticTexts[\"Charleston AFB - 437\/315 AW Pilot\"]",".staticTexts[\"Charleston AFB - 437\/315 AW Pilot\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Choose your MQFs"].buttons["Done"].tap()

//
//        XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()
        func testLaunchMQF(){

    }
    /// Only works if certain MQF is set

        let app = XCUIApplication()
        app.buttons["Study"].tap()

        let collectionViewsQuery = app.collectionViews
        let takeoffMsnStaticText = collectionViewsQuery.staticTexts["Example A"]
        takeoffMsnStaticText.tap()
        takeoffMsnStaticText.tap()
        collectionViewsQuery.buttons["End Quiz"].tap()

    }
    
    func testContactUs(){
        let app = XCUIApplication()
        app.buttons["feedback"].tap()
        
        let elementsQuery = app.alerts["We'd love to hear from you!"].scrollViews.otherElements
        elementsQuery.buttons["Will Do!"].tap()
    }
    
    func testViewSettings(){
        
        
        let app = XCUIApplication()
        app.buttons["settings"].tap()
        
        let settingsNavigationBar = app.navigationBars["Settings"]
        settingsNavigationBar.staticTexts["Settings"].tap()
        
        let tablesQuery = app.tables
       let numQ =  tablesQuery.children(matching: .other)["NUMBER OF QUESTIONS IN QUIZ"].children(matching: .other)["NUMBER OF QUESTIONS IN QUIZ"]
        
        let settings = tablesQuery.children(matching: .other)["SETTINGS"].children(matching: .other)["SETTINGS"]
        let about = tablesQuery.children(matching: .other)["ABOUT"].children(matching: .other)["ABOUT"]
        

        XCTAssert(numQ.exists)
        XCTAssert(settings.exists)
        XCTAssert(about.exists)
        
        //Close settings
        settingsNavigationBar.buttons["Done"].tap()
       
    }
    
    /// Runs through an entire mqf in study mode, once the results show it makes sure there are enough results for each question it saw in the run through
//    func testEntireMQF(){
//
//        let app = XCUIApplication()
//        app.buttons["Test"].tap()
//        
//
//        let resultsNavigationBar = app.navigationBars["Results"]
//        var c = 0
//        while !resultsNavigationBar.exists {
//            let aStaticText = app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["A"]/*[[".cells.staticTexts[\"A\"]",".staticTexts[\"A\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//            aStaticText.tap()
//            c = c + 1
//        }
//
//        
//        let cellCount = app.tables.cells.count
//        XCTAssertEqual(c / 2, cellCount - 1, "Wrong Result Cell Count")
//
//        resultsNavigationBar.buttons["Done"].tap()
//
//
//    }

}
