//
//  MQFData.swift
//  MQF
//
//  Created by Christian Brechbuhl on 6/5/19.


import UIKit
import SwiftyJSON
class MQFData: NSObject {
    public var name:String
    public var mds:String
    public var crewPositions:[String]
    public var testNum = 0
    public var filename:String

    override init() {
        self.name = ""
        self.mds = "C-17"
        self.crewPositions = [String]()
        self.filename = "c17-Pilot.json"
    }
    
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
    public convenience init (json:JSON, total:Int){
        self.init(json:json)
        self.testNum = total
    }
}
