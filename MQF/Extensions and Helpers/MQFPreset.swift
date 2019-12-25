//
//  MQFPreset.swift
//  MQF
//
//  Created by Christian Brechbuhl on 6/7/19.


import UIKit
import SwiftyJSON

/// `MQFPreset` represents a preset collecton of MQFs in the app. They are show in the Choose MQF UI under OGV Presets.
class MQFPreset: NSObject, NSCoding {
    ///Name of the MQF Preset (`String`)
    public var name:String
    /// Name of the MDS it applies to (`String`)
    public var mds:String
    /// Array of the crew positions the preset applies to (`[String`)
    public var crewPositions:[String]
    /// Id of this `MQFPreset` (`String`)
    public var id:String
    /// Number of question in a test based on this preset (`Int`)
    public var testTotal:Int
    /// Array of the MQFs used in this preset (`[MQFData]`)
    public var mqfs:[MQFData]
   
    
    override init() {
        self.name = ""
        self.mds = "C-17"
        self.crewPositions = [String]()
        self.id = ""
        self.testTotal = 0
        self.mqfs = [MQFData]();
    
    }
    
    /// Init an instance of `MQFPreset` with given `JSON` object
    ///
    /// - parameters:
    ///   - json:  `JSON` for the desired MQF
    /// - returns: `MQFPreset`
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
            let mqf = DataManager.shared.getMQFData(for: data["file"]?.string ?? "") // Searches loaded MQFs for one with that filename
            if(mqf != nil){
                print(data)
                let tn = data["testNum"]
                let tni = tn?.intValue
                mqf!.testNum = tni ?? 0 //If there is no test number, use 0
                self.mqfs.append(mqf!)
            }
        }
        
    }
    
    /// Init an instance of `MQFData` with encoded version, used to load from file
    ///
    /// - parameters:
    ///   - decoder:  `NSCoder`
    /// - returns: `MQFPreset`
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.id = decoder.decodeObject(forKey: "id") as? String ?? ""
        self.mds = decoder.decodeObject(forKey: "mds") as? String ?? ""
        self.testTotal = decoder.decodeInteger(forKey: "testTotal")
        self.crewPositions = decoder.decodeObject(forKey: "crewPositions") as? [String] ?? [String]()
        self.mqfs = [MQFData]()
    }
    
    /// Encodes `MQFPreset` using `NSCoder` to save in file
    ///
    /// - parameters:
    ///   - coder:  `NSCoder`
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.id, forKey: "id")
        coder.encode(self.mds, forKey: "mds")
        coder.encode(self.testTotal, forKey: "testTotal")
        coder.encode(self.crewPositions, forKey: "crewPositions")
        
    }
}
