//
//  MenuViewController.swift
//  MQF
//
//  Created by Christian Brechbuhl on 5/28/19.
//  Copyright © 2019 Umbo LLC. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if(segue.identifier == "Study"){
            let vc = segue.destination as! QuestionCollectionViewController
            vc.mode = .Study
        }else if(segue.identifier == "Test"){
            let vc = segue.destination as! QuestionCollectionViewController
            vc.mode = .Test
        }
    }
 
    @IBAction func chooseMQF(_ sender: Any) {
        let alert = UIAlertController.init(title: "Coming Soon", message: "This feature has not been implemented in the demo version, in the full version you will be able to choose the MQFs you wish to study/test.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Cool!", style: .default, handler: nil)
        
        //now we are adding the default action to our alertcontroller
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    

}
