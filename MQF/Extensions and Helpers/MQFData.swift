//
//  MQFData.swift
//  MQF
//
//  Created by Christian Brechbuhl on 6/5/19.


import UIKit
import SwiftyJSON

/// MQFData represents a single MQF in the app.
class MQFData: NSObject {
    ///Name of MQF
    public var name:String
    ///Name of MDS this MQF is for
    public var mds:String
    ///`[String]` of crew positions this MQF applies to
    public var crewPositions:[String]
    /// Total number of questions from this MQF that should be in the test
    public var testNum = 0
    /// Filename of the MQF (for searching later, MQFData is based on JSON object supplied to `init`)
    public var filename:String

    /// Required `init()` - do not use, this creates an instance of MQFData with dummy data.
    /// Instead use `init(json:JSON)` or `init(json:JSON, total:Int)`
    override init() {
        self.name = ""
        self.mds = "C-17"
        self.crewPositions = [String]()
        self.filename = "c17-Pilot.json"
    }
    
    
    
    /// Init an instance of `MQFData` with given `JSON` object
    ///
    /// - parameters:
    ///   - json:  `JSON` for the desired MQF
    /// - returns: `MQFData`
    init(json:JSON){
        let dict = json.dictionary ?? [String:JSON]()
        self.name = dict["name"]?.string ?? "Name not found"
        self.mds = dict["mds"]?.string ?? "MDS not found"
        self.filename = dict["file"]?.string ?? "c17-Pilot.json"
        self.crewPositions = [String]()
        for position in dict["positions"]?.array ?? [JSON]() {
            self.crewPositions.append(position.string ?? "Not Found")
        }
        
    }
    
    /// Init an instane of `MQFData` with given `JSON` object and sets the number of questions in the test
    ///
    /// - parameters:
    ///   - json:  `JSON` for the id of the desired preset
    ///   - total: `Int` total number of questions in test
    /// - returns: `MQFData`
    public convenience init (json:JSON, total:Int){
        self.init(json:json)
        self.testNum = total
    }
}
