//
//  MQFPreset.swift
//  MQF
//
//  Created by Christian Brechbuhl on 6/7/19.
//  Copyright © 2019 Umbo LLC. All rights reserved.
//


import UIKit
import SwiftyJSON
class MQFPreset: NSObject, NSCoding {
    public var name:String
    public var mds:String
    public var crewPositions:[String]
    public var id:String
    public var testTotal:Int
    public var mqfs:[MQFData]
   
    
    override init() {
        self.name = ""
        self.mds = "C-17"
        self.crewPositions = [String]()
        self.id = ""
        self.testTotal = 0
        self.mqfs = [MQFData]();
    
    }
    
    init(json:JSON){
        let dict = json.dictionary ?? [String:JSON]()
        self.name = dict["name"]?.string ?? "Name not found"
        self.id = dict["id"]?.string ?? "ID not found"
        self.mds = dict["mds"]?.string ?? "MDS-NF"
        self.testTotal = dict["testTotal"]?.int ?? 0
        self.crewPositions = [String]()
        for position in dict["positions"]?.array ?? [JSON]() {
            self.crewPositions.append(position.string ?? "Not Found")
        }
        self.mqfs = [MQFData]();
        for requestedMQF in dict["mqfs"]?.array ?? [JSON]() {
            let data = requestedMQF.dictionary ?? [String:JSON]()
            let mqf = DataManager.shared.getMQFData(for: data["file"]?.string ?? "")
            if(mqf != nil){
                mqf?.testNum = data["testNum"]?.int ?? 0
                self.mqfs.append(mqf!)
            }
        }
        
    }
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.id = decoder.decodeObject(forKey: "id") as? String ?? ""
        self.mds = decoder.decodeObject(forKey: "mds") as? String ?? ""
        self.testTotal = decoder.decodeInteger(forKey: "testTotal")
        self.crewPositions = decoder.decodeObject(forKey: "crewPositions") as? [String] ?? [String]()
        self.mqfs = [MQFData]()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.id, forKey: "id")
        coder.encode(self.mds, forKey: "mds")
        coder.encode(self.testTotal, forKey: "testTotal")
        coder.encode(self.crewPositions, forKey: "crewPositions")
        
    }
}
