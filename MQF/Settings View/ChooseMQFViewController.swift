//
//  ChooseMQFViewController.swift
//  MQF
//
//  Created by Christian Brechbuhl on 6/7/19.


import UIKit
import Eureka

/// `ChooseMQFViewController` subclasses `FormViewController`
/// ViewContoller to let the user choose the active MQF or MQFPreset
class ChooseMQFViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpForm()
        
    }
    
    /// Sets up the form on the screen, should be called from `self.viewDidLoad`
    /// Creates Two Form views with a toggle switch to change between them. One is for the presets and the other for individual MQFs
    func setUpForm(){
        //Get current selection
        let previousSelection = MQFDefaults().object(forKey: MQFDefaults.activePresetID) as? String ?? "KCHS-Pilot-Airland2"
        ///Current crew position
        let crewPosition = MQFDefaults().object(forKey: MQFDefaults.crewPosition) as? String ?? "Pilot"
        let mds = MQFDefaults().object(forKey: MQFDefaults.mds) as? String ?? "C-17"
        
        //Instatiate form
        form
            
            +++ Section() //Create section
            
            //Add switch row (switches between selection modes
            <<< SegmentedRow<String>("switchRowTag"){
                $0.title = "Select Mode:"
                $0.options = ["OGV Presets","Individual MQFs"]
                $0.value = MQFDefaults().value(forKey: MQFDefaults.pickerMode) as? String ?? "OGV Presets" //Get currently selected mode (last used)
            }.onChange{ row in
                //On change save to MQFDefaults
                MQFDefaults().set(row.value ?? "OGV Presets", forKey: MQFDefaults.pickerMode)
                MQFDefaults().synchronize()
            }
            
            //Add section for MQFPresets
            +++ SelectableSection<ListCheckRow<String>>(header: "Choose a set of MQFs", footer: "All presets available to your crew position, to view others change your crew position in settings.", selectionType: .singleSelection(enableDeselection: false)){
                
                //Add a row for each `MQFPreset` base on each `MQFBase`
                for base in DataManager.shared.availableBases{
                    for option in base.presets {
                        print(option.mds)
                        if((option.crewPositions.contains(crewPosition) || option.crewPositions.contains("All")) && option.mds == mds){
                            //Only show MQFs for crew position
                            
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
                //Determine if the segment should be hidden or not
                $0.hidden = Condition.function(["switchRowTag"], { form in
                    let value = (form.rowBy(tag: "switchRowTag") as? SegmentedRow<String>)?.value
                    if(value == "Individual MQFs"){
                        return true
                    }else{
                        return false
                    }
                })
            }
            
            //Add section for choosing by individual MQF
            +++ SelectableSection<ListCheckRow<String>>(header: "Choose an MQF", footer: "All MQFs available to your crew position, to view others change your crew position in settings.", selectionType: .singleSelection(enableDeselection: false)){
                
                //Add row for each MQF available to the selected crew position
                for option in DataManager.shared.availableMQFs {
                    if((option.crewPositions.contains(crewPosition) || option.crewPositions.contains("All")) && option.mds == mds){
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
                //Determine if the section should be hidden or not
                $0.hidden = Condition.function(["switchRowTag"], { form in
                    let value = (form.rowBy(tag: "switchRowTag") as? SegmentedRow<String>)?.value
                    if(value == "OGV Presets"){
                        return true
                    }else{
                        return false
                    }
                })
                
        }
        
        
    }
    
    /// Overides `valueHasBeenChanged` to save new value to  `MQFDefaults` for selected item
    ///
    /// - parameters
    ///   - row:  `BaseRow`
    ///   - oldValue: `Any?` the old value
    ///   - newValue: `Any?` the new value
    override func valueHasBeenChanged(for row: BaseRow, oldValue: Any?, newValue: Any?) {
        if row.section === form[1] {
            let val = (row.section as! SelectableSection<ListCheckRow<String>>).selectedRow()?.baseValue as? String ?? "No row selected"
            let value = (form.rowBy(tag: "switchRowTag") as? SegmentedRow<String>)?.value
            
            if(value == "OGV Presets"){
                let preset = DataManager.shared.getPreset(for: val)
                if(preset != nil){
                    MQFDefaults().set(preset!.id, forKey: MQFDefaults.activePresetID)
                    MQFDefaults().set("PRESET", forKey: MQFDefaults.activeMode) //Mode (PRESET or MQF)
                    MQFDefaults().synchronize()
                    print("Preset set: \(preset!.id)")
                }else{
                    print("ERROR CHOOSING PRESET")
                }
            }else{
                let mqf = DataManager.shared.getMQFData(for: val)
                if(mqf != nil){
                    MQFDefaults().set(mqf!.filename, forKey: MQFDefaults.activePresetID)
                    MQFDefaults().set("MQF", forKey: MQFDefaults.activeMode)//Mode (PRESET or MQF)
                    MQFDefaults().synchronize()
                    print("Preset set: \(mqf!.filename)")
                }else{
                    print("ERROR CHOOSING MQF")
                }
            }
            
            
            
        }
        
    }
    
    // MARK: - Navigation
    
    /// Dismisses View
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
