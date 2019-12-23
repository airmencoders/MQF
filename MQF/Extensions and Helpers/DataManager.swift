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
    open class var shared: DataManager {
        
        struct Static {
            static let instance = DataManager()
        }
        return Static.instance
    }
    
    public var availableCrewPositions: [String] {
        var cps = [String]()
        for mqf in availableMQFs{
            for position in mqf.crewPositions{
                cps.append(position)
            }
        }
        return cps.unique()
    }
    
    public var availableMDS: [String] {
        var mds = [String]()
        for mqf in availableMQFs{
                mds.append(mqf.mds)
        }
        return mds.unique()
    }
    
    public func load(){
        print("loading data")
        guard let path = Bundle.main.path(forResource: "available", ofType: "json") else {
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
    
    public func getMQFData(for filename:String)->MQFData?{
        for md in self.availableMQFs{
          //  print("\(md.filename) - \(filename)")
            if (md.filename == filename){
                return md
            }
        }
        return nil
    }
    
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
    
    private func loadFromJSONFile (path: String)->JSON? {
        guard let jsonString = try? String(contentsOfFile: path) else {
            return nil
        }
        
        let json = JSON(parseJSON: jsonString)
        
        return json
    }
}
