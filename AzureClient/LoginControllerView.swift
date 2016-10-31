//
//  LoginControllerView.swift
//  TplResources
//
//  Created by alessio giacobbe on 17/10/16.
//  Copyright © 2016 alessio giacobbe. All rights reserved.
//

import UIKit

class LoginControllerView: UIViewController {

    
    
    var table : MSSyncTable?
    
    var store : MSCoreDataStore?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Login"
        let client = MSClient(applicationURLString: "Your project url")
        client.syncContext = MSSyncContext(delegate: nil, dataSource: self.store, callback: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Flogin(_ sender: AnyObject) {
        login(service: "facebook")
    }
    
    @IBAction func Glogin(_ sender: AnyObject) {
        login(service: "google")
    }
    
    @IBAction func Mlogin(_ sender: AnyObject) {
        login(service: "microsoftaccount"
        )
    }
    
    func login(service: String){
        
        let cliente = MSClient(applicationURLString: "Your project url")
        cliente.syncContext = MSSyncContext(delegate: nil, dataSource: self.store, callback: nil)
        
        cliente.login(withProvider: service, controller: self, animated: true) { (user, error) in
            
            if error == nil{
                
                print("login effettuato")
                UserDefaults.standard.setValue(service, forKey: "login_method")
                self.performSegue(withIdentifier: "AfterLogin", sender: nil)
            }else{
                
            }
            
        }
    }

    

}
