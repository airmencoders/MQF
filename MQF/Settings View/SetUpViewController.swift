//
//  SetUpViewController.swift
//  MQF
//
//  Created by Christian Brechbuhl on 7/31/19.


import UIKit
import Eureka

/// Initial screen shown to user on new install, has them pick an MDS and crew position.
class SetUpViewController: FormViewController {
var currentMWS = "C-17"
    override func viewDidLoad() {
        super.viewDidLoad()
        MQFDefaults().set("C-17", forKey: MQFDefaults.mds)
        MQFDefaults().set("Pilot", forKey: MQFDefaults.crewPosition)

         self.currentMWS = MQFDefaults().string(forKey: MQFDefaults.mds) ?? "C-17"
    
        //Instantiate form
        self.setUpForm()
       //mark set up as shown
        MQFDefaults().set(true, forKey: MQFDefaults.hasBeenSetup)
        MQFDefaults().synchronize()
    
    }
    
    func setUpForm(){
        let crewPosRow = PushRow<String>() {
                                $0.title = "Crew Position"
                                $0.selectorTitle = "Pick a position"
                                $0.options = DataManager.shared.availableCrewPositionsForMWS(mds: self.currentMWS)
                                $0.value = MQFDefaults().object(forKey: MQFDefaults.crewPosition) as? String ?? "Pilot"
                                $0.add(rule: RuleRequired())
                                $0.validationOptions = .validatesOnChange
                            }.onChange { row in
                                if(row.value != nil){
                                    MQFDefaults().set(row.value, forKey: MQFDefaults.crewPosition)
                                }else{
                                    row.value = MQFDefaults().string(forKey: MQFDefaults.crewPosition) ?? "C-17"
                                }
                                MQFDefaults().synchronize()
                            }.cellUpdate { cell, row in
                                row.options = DataManager.shared.availableCrewPositionsForMWS(mds: self.currentMWS)
                                if !row.isValid {
                                    cell.textLabel?.textColor = .red
                                    print("invalid")
                                }
                            }
        form
            
            +++ Section(header: "Choose your MDS & Crew Position", footer: "You can always change them later in Settings. Don't see your MDS or crew position? Contact us to get your MQFs added, this app is open to all AF communities.")
            
            //Adds row to choose MDS from list of all available MDSs
                <<< PushRow<String>() {
                   $0.title = "MDS (Airframe)"
                   $0.selectorTitle = "Pick an MDS"
                   $0.options = DataManager.shared.availableMDS
                   $0.value = MQFDefaults().object(forKey: MQFDefaults.mds) as? String ?? "C-17"
                   $0.add(rule: RuleRequired())
                   $0.validationOptions = .validatesOnChange
               }.onChange { row in // Handle changes
                   if(row.value != nil){
                       MQFDefaults().set(row.value, forKey: MQFDefaults.mds)
                       self.currentMWS = row.value ?? "C-17"
                   }else{
                       row.value = MQFDefaults().string(forKey: MQFDefaults.mds) ?? "C-17"
                   }
                   crewPosRow.updateCell()
                   MQFDefaults().synchronize() // saves defaults
               }.cellUpdate { cell, row in
                   
                   if !row.isValid {
                       cell.textLabel?.textColor = .red
                       print("invalid")
                   }
               }
            
            //Adds row to choose crew position from list of all available
            <<< crewPosRow
            
            //Adds button that dismisses view
            <<< ButtonRow(){ row in
                row.title = "Begin"
                row.onCellSelection({ (button, row) in
                    print("button on select")
                    self.dismissSetup()
                    
                })
        }

    }
    
    ///Dismisses the screen
    func dismissSetup(){
        if(self.checkCanDismiss()){
        self.dismiss(animated: true, completion: nil)
        }else{
            let mws = MQFDefaults().string(forKey: MQFDefaults.mds) ?? "C-17"
            let pos = MQFDefaults().string(forKey: MQFDefaults.crewPosition) ?? "Pilot"
            let alert = UIAlertController(title: "Oops", message: "Looks like we don't currently have any MQFs for \(mws) \(pos)s. Please select a different crew position or MWS.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func checkCanDismiss()->Bool{
        let mws = MQFDefaults().string(forKey: MQFDefaults.mds) ?? "UNKN"
        let pos = MQFDefaults().string(forKey: MQFDefaults.crewPosition) ?? "Pilot"
        return checkValidMWSCrewPositionCombo(mws: mws, crewPosition: pos)
    }
    

    func checkValidMWSCrewPositionCombo(mws:String, crewPosition:String)->Bool{
        if(DataManager.shared.availableMQFsFor(mws: mws, crewPosition: crewPosition).count > 0){
            return true
        }
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
