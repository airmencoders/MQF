//
//  SetUpViewController.swift
//  MQF
//
//  Created by Christian Brechbuhl on 7/31/19.


import UIKit
import Eureka

/// Initial screen shown to user on new install, has them pick an MDS and crew position.
class SetUpViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Instantiate form
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
                }.onChange { row in
                    if(row.value != nil){
                        MQFDefaults().set(row.value, forKey: MQFDefaults.mds)
                    }else{
                        row.value = MQFDefaults().string(forKey: MQFDefaults.mds) ?? "C-17"
                    }
                    MQFDefaults().synchronize()
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                        print("invalid")
                    }
            }
            
            //Adds row to choose crew position from list of all available
            <<< PushRow<String>() {
                $0.title = "Crew Position"
                $0.selectorTitle = "Pick a position"
                $0.options = DataManager.shared.availableCrewPositions
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
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                        print("invalid")
                    }
            }
        
            //Adds button that dismisses view
            <<< ButtonRow(){ row in
                row.title = "Begin"
                row.onCellSelection({ (button, row) in
                    print("button on select")
                    self.dismissSetup()
                    
                })
        }
            
       //mark set up as shown
        MQFDefaults().set(true, forKey: MQFDefaults.hasBeenSetup)
        MQFDefaults().synchronize()
    
    }
    
    ///Dismisses the screen
    func dismissSetup(){
        self.dismiss(animated: true, completion: nil)
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
