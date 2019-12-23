//
//  ChooseMQFViewController.swift
//  MQF
//
//  Created by Christian Brechbuhl on 6/7/19.


import UIKit
import Eureka

class ChooseMQFViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let previousSelection = MQFDefaults().object(forKey: MQFDefaults.activePresetID) as? String ?? "KCHS-Pilot-Airland2"
        let crewPosition = MQFDefaults().object(forKey: MQFDefaults.crewPosition) as? String ?? "Pilot"
        form +++ Section()
            <<< SegmentedRow<String>("switchRowTag"){
                $0.title = "Select Mode:"
                $0.options = ["OGV Presets","Individual MQFs"]
                $0.value = MQFDefaults().value(forKey: MQFDefaults.pickerMode) as? String ?? "OGV Presets"
                }.onChange{ row in
                    MQFDefaults().set(row.value ?? "OGV Presets", forKey: MQFDefaults.pickerMode)
                    MQFDefaults().synchronize()
            }
          
            +++ SelectableSection<ListCheckRow<String>>(header: "Choose a set of MQFs", footer: "All presets available to your crew position, to view others change your crew position in settings.", selectionType: .singleSelection(enableDeselection: false)){
                
                for base in DataManager.shared.availableBases{
                for option in base.presets {
                    if(option.crewPositions.contains(crewPosition) || option.crewPositions.contains("All")){
                        //Only show MQFs fro crew position
                    
                    $0 <<< ListCheckRow<String>(option.name){ listRow in
                        listRow.title = "\(base.name) - \(option.name)"
                        listRow.selectableValue = option.id
                        if(previousSelection == option.id){
                            listRow.value = option.id
                        }else{
                        listRow.value = nil
                        }
                    }
                    }
                }
                }
                $0.hidden = Condition.function(["switchRowTag"], { form in
                                        let value = (form.rowBy(tag: "switchRowTag") as? SegmentedRow<String>)?.value
                                        if(value == "Individual MQFs"){
                                            return true
                                        }else{
                                            return false
                                        }
                                    })
                }
        +++ SelectableSection<ListCheckRow<String>>(header: "Choose an MQF", footer: "All MQFs available to your crew position, to view others change your crew position in settings.", selectionType: .singleSelection(enableDeselection: false)){
           
                for option in DataManager.shared.availableMQFs {
                    print(option.crewPositions)
                    print(crewPosition)
                    if(option.crewPositions.contains(crewPosition) || option.crewPositions.contains("All")){
                    $0 <<< ListCheckRow<String>(option.name){ listRow in
                        listRow.title = option.name
                        listRow.selectableValue = option.filename
                        listRow.tag = "MQF-\(option.name)"
                        if(previousSelection == option.filename){
                            listRow.value = option.filename
                        }else{
                            listRow.value = nil
                        }
                    }
                    }
                }
                $0.hidden = Condition.function(["switchRowTag"], { form in
                    let value = (form.rowBy(tag: "switchRowTag") as? SegmentedRow<String>)?.value
                    if(value == "OGV Presets"){
                        return true
                    }else{
                        return false
                    }
                })
                
        }

        

        // Do any additional setup after loading the view.
    }
    

    override func valueHasBeenChanged(for row: BaseRow, oldValue: Any?, newValue: Any?) {
        if row.section === form[1] {
            let val = (row.section as! SelectableSection<ListCheckRow<String>>).selectedRow()?.baseValue as? String ?? "No row selected"
            let value = (form.rowBy(tag: "switchRowTag") as? SegmentedRow<String>)?.value
          
            if(value == "OGV Presets"){
               let preset = DataManager.shared.getPreset(for: val)
                if(preset != nil){
                    MQFDefaults().set(preset!.id, forKey: MQFDefaults.activePresetID)
                    MQFDefaults().set("PRESET", forKey: MQFDefaults.activeMode)
                    MQFDefaults().synchronize()
                    print("Preset set: \(preset!.id)")
                }else{
                    print("ERROR CHOOSING PRESET")
                }
            }else{
                let mqf = DataManager.shared.getMQFData(for: val)
                if(mqf != nil){
                    MQFDefaults().set(mqf!.filename, forKey: MQFDefaults.activePresetID)
                    MQFDefaults().set("MQF", forKey: MQFDefaults.activeMode)
                    MQFDefaults().synchronize()
                    print("Preset set: \(mqf!.filename)")
                }else{
                    print("ERROR CHOOSING MQF")
                }
            }
            
          
            
        }
        
    }
    
    // MARK: - Navigation

     @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
     }
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
