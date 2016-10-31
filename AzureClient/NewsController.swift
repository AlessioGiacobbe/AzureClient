//
//  NewsController.swift
//  TplResources
//
//  Created by alessio giacobbe on 19/10/16.
//  Copyright © 2016 alessio giacobbe. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyXMLParser


class NewsController: UITableViewController, XMLParserDelegate {

    
    @IBOutlet var tabella: UITableView!
    var name:String = "ciao"
    var news:file = file()
    var newstitle: [String] = [];
    var newslink: [String] = [];
    var xmlpars: XMLParser? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.tintColor = UIColor.black;
        // Do any additional setup after loading the view.
        var link:String = "google"
        if UserDefaults.standard.string(forKey: "Loc_Link") != nil {
            link = UserDefaults.standard.string(forKey: "Loc_Link")!
            link = replaceoptional(input: link)
        }
        
        print("link \(link)")
        Alamofire.request(link, method: .get)
            .responseData { response in
                if let data = response.data {
                    self.xmlpars = XMLParser(data: data)
                    self.xmlpars?.delegate = self
                    self.xmlpars?.parse()
                }
        }
        
        
        tabella.dataSource = self
        tabella.delegate = self
       
    }
    
    
    func replaceoptional(input: String) -> String {         //sicuramente c'è un modo giusto di fare ques_ ta cosa, ma tutto quello che trovo non funziona, quindi mi arrangio, odio gli optional comunque
        let newString = input.replacingOccurrences(of: "Optional(", with: "")
        let finalString = newString.replacingOccurrences(of: ")", with: "")
        return finalString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        name = elementName
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (newstitle.count)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        tabella.delegate = self
        tabella.dataSource = self
        tabella.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cella", for: indexPath)
        print("ciao")
        cell.textLabel?.text = newstitle[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tap")
        UIApplication.shared.openURL(URL(string: newslink[indexPath.row])!)
    }
    
    func parser(_ parser: XMLParser, foundCharacters stringa: String) {
        let valore = stringa.trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch name{
            case "title":
                newstitle.append(valore)
                print("titolo \(valore)")
            case "link":
                newslink.append(valore)
                print("stringa \(valore)")
            default:
                break
        }
    }
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
