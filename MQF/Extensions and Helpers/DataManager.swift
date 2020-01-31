//
//  DataManager.swift
//  MQF
//
//  Created by Christian Brechbuhl on 6/5/19.


import UIKit
import SwiftyJSON
class DataManager: NSObject {

    public var availableMQFs = [MQFData]()
    public var availableBases = [MQFBase]()
    
    /// Shared instantiation of `DataManager` use this to access
    /// - returns: `Static.instance`
    open class var shared: DataManager {
        
        struct Static {
            static let instance = DataManager()
        }
        return Static.instance
    }
    
    /// List all available crew positions
    /// - returns: `[String]` containing each available crew position
    public var availableCrewPositions: [String] {
        var cps = [String]()
        for mqf in availableMQFs{
            for position in mqf.crewPositions{
                cps.append(position)
            }
        }
        return cps.unique()
    }
    
    /// List all available crew positions
    /// - returns: `[String]` containing each available crew position
    public func availableCrewPositionsForMWS(mds:String)->[String]{
        var cps = [String]()
        for mqf in availableMQFs{
            if(mqf.mds == mds){
            for position in mqf.crewPositions{
                cps.append(position)
            }
            }
        }
        return cps.unique()
    }
    
    /// List of all available MDSs
    /// - returns: `[String]`of each MDS found
    public var availableMDS: [String] {
        var mds = [String]()
        for mqf in availableMQFs{
                mds.append(mqf.mds)
        }
        return mds.unique()
    }
    
    /// Loads MQFs listed in `available.json`
    /// Does not take any parameters or return anything. Once called the loaded MQFs can be accessed view the `DataManager` class, shared instantiation.
    public func load(file:String = "available"){
        print("loading data")
        guard let path = Bundle.main.path(forResource: file, ofType: "json") else {
            return
        }
        let json = loadFromJSONFile(path: path)
        
        let dict = json!.dictionary ?? [String:JSON]()
        //Parse Available MQFs
        let available = dict["available"]?.array ?? [JSON]()
        self.availableMQFs = [MQFData]()
        for mqfJson in available{
            let mqf = MQFData(json: mqfJson)
            self.availableMQFs.append(mqf)
        }

        
        
        let presets = dict["presets"]?.dictionary ?? [String:JSON]()
        self.availableBases = [MQFBase]()
       // print(presets)
        for mqfJson in presets{
            let base = MQFBase(json: mqfJson.value)
            self.availableBases.append(base)
        }
  
        
        
    }
    
    /// Returns single `MQFData` for the given filename
    /// Searches loaded MQFs and returns based on matching filename
    /// - parameters:
    ///   - filename:  `String` for the filename of the desired MQF
    /// - returns: `MQFData`
    public func getMQFData(for filename:String)->MQFData?{
        for md in self.availableMQFs{
          //  print("\(md.filename) - \(filename)")
            if (md.filename == filename){
                return md
            }
        }
  
        return nil
    }
    
    /// Returns single `MQFPreset` for the given id
    ///
    /// - parameters:
    ///   - id:  `String` for the id of the desired preset
    /// - returns: `MQFPreset`
    public func getPreset(for id:String)->MQFPreset?{
        for base in self.availableBases{
            for preset in base.presets{
                //print("Preset ID: \(preset.id) - \(id)")
                if (preset.id == id){
                    return preset
                }
            }
        }
        return nil
    }
    
    
    /// Returns an array of MQFPreset for each preset that meets the search criteria. Items are returned if they match base, mds, and position. If any parameter is nil that is treated as ALL. For example if you provide mds = nil, position = Loadmaster, and baseName = nil it will return all Loadmaster presets.
    ///
    /// - parameters:
    ///   - mds:  `String` for the MDS ie C17 or nil
    ///   - position: `String` for the position ie Pilot or nil
    ///   - baseName: `String` for the base name ie charleston or nil
    /// - returns: [MQFPreset] can be an empty array if nothing matches search
    public func getPresets(for mds:String? = nil, position:String?=nil, baseName:String? = nil)->[MQFPreset]{
        var availablePresets = [MQFPreset]()
        for base in self.availableBases{
            if(baseName == nil || base.name == baseName ){
                   for preset in base.presets{
                    if((mds == nil || preset.mds == mds!) && (position == nil || preset.crewPositions.contains(position!))){
                        availablePresets.append(preset)
                    }

                   }
               }
        }
        return availablePresets;
    }
    
    /// Loads file into `JSON` object
    ///
    /// - parameters:
    ///   - path:  `String` file path for desired file
    /// - returns: `JSON`
    private func loadFromJSONFile (path: String)->JSON? {
        guard let jsonString = try? String(contentsOfFile: path) else {
            return nil
        }
        
        let json = JSON(parseJSON: jsonString)
        
        return json
    }
}
