//
//  FeedBack.swift
//  TplResources
//
//  Created by alessio giacobbe on 18/10/16.
//  Copyright © 2016 alessio giacobbe. All rights reserved.
//

import UIKit

class FeedBack: UIViewController {
    
    var table : MSSyncTable?
    var store : MSCoreDataStore?
    @IBOutlet weak var Val_Pass: CosmosView!
    @IBOutlet weak var Val_Bus: CosmosView!
    @IBOutlet weak var Val_Glob: CosmosView!
    @IBOutlet weak var Val_Con: CosmosView!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var line: UITextField!
    @IBOutlet weak var direction: UITextField!
    @IBOutlet weak var currenth: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func done(_ sender: AnyObject) {
        
        let client = MSClient(applicationURLString: "Your project url")
        //let managedObjectContext = (UIApplication.shared.delegate).managedObjectContext!
        //self.store = MSCoreDataStore(managedObjectContext: managedObjectContext)
        client.syncContext = MSSyncContext(delegate: nil, dataSource: self.store, callback: nil)
        
        
        client.login(withProvider: UserDefaults.standard.string(forKey: "login_method")!, controller: self, animated: true) { (user, error) in
            
            if error == nil{
                
                let tabella = client.table(withName: "feedback")
                var userid = self.table?.client.currentUser?.userId
                userid = userid?.replacingOccurrences(of: "sid:", with: "")
                let elemento = ["your element data"]
                tabella.insert(elemento){ (result, error) in
                    if let err = error {
                        print("ERROR ", err)
                    } else if let item = result {
                        print("Todo Item: ", item["text"])
                    }
                }
            }else{
                
            }
            
        }
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
