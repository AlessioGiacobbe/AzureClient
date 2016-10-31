//
//  SettingsController.swift
//  TplResources
//
//  Created by alessio giacobbe on 19/10/16.
//  Copyright © 2016 alessio giacobbe. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{

    @IBOutlet weak var picker: UIPickerView!
    var table : MSSyncTable?
    var selected : Int = 0
    var store : MSCoreDataStore?
    var namelist: [String] = []
    var linklist: [String] = []
    var imagelist: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Impostazioni"
        // Do any additional setup after loading the view.
        
        gettable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func save(_ sender: AnyObject) {
        let row  = picker.selectedRow(inComponent: 0)
        UserDefaults.standard.setValue(linklist[row], forKey: "Loc_Link")
        UserDefaults.standard.setValue(namelist[row], forKey: "Loc_Name")
        UserDefaults.standard.setValue(imagelist[row], forKey: "Loc_IMG")
        self.performSegue(withIdentifier: "SettingToHome", sender: nil)

    }
    
    
    
    func gettable(){
        var way = UserDefaults.standard.string(forKey: "login_method")
        if way == nil{
            way = "google"
        }
        let client = MSClient(applicationURLString: "your project url")
        client.syncContext = MSSyncContext(delegate: nil, dataSource: self.store, callback: nil)
        self.table = client.syncTable(withName: "your table")
        client.login(withProvider: way!, controller: self, animated: true) { (user, error) in
            let tabella = client.table(withName: "your table")
            tabella.read { (result, error) in
                let items = result?.items
                for item in items!{
                    let nomino = "\(item["Nome"])"
                    let linkimm = "\(item["LinkIMG"])"
                    let linkfeed = "\(item["LinkBus"])"
                    self.namelist.append(nomino)
                    self.imagelist.append(linkimm)
                    self.linklist.append(linkfeed)
                    print("luogo: ", item["Nome"])
                    
                    self.picker.dataSource = self
                    self.picker.delegate = self
                }
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return namelist.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return replaceoptional(input: namelist[row])
    }
    
    func replaceoptional(input: String) -> String {         //sicuramente c'è un modo giusto di fare ques_ ta cosa, ma tutto quello che trovo non funziona, quindi mi arrangio, odio gli optional comunque
        let newString = input.replacingOccurrences(of: "Optional(", with: "")
        let finalString = newString.replacingOccurrences(of: ")", with: "")
        return finalString
    }
    


}
