//
//  AddCityTableViewController.swift
//  NEUWeather
//
//  Created by Maheshwara Reddy on 12/3/20.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON
import PromiseKit
import RealmSwift
class AddCityTableViewController: UITableViewController, UISearchBarDelegate {

    var arr: [CityInformation] = [CityInformation]()
    
    
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        srchBar.delegate = self
        
        print(Realm.Configuration.defaultConfiguration.fileURL)

    }
  


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = "\(arr[indexPath.row].name), \(arr[indexPath.row].country), \(arr[indexPath.row].adminArea)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let city = arr[indexPath.row]
        
        let alert = UIAlertController(title: "Add City", message: "Do you want to see weather for \(city.name)", preferredStyle: .alert)
        
        let OK = UIAlertAction(title: "OK", style: .default) { (action) in
            self.addCityToDB(city: city)
            self.navigationController?.popViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (action) in
            print("Cancel Pressed")
        }
        alert.addAction(OK)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteCity(city : CityInformation){
        do{
            let realm = try Realm()
            try realm.write({
                realm.delete(city)
            })
        }catch{
            print("Error")
        }
    }
 
    
    
    func getCityNames(for cityStr : String){
        let url = "\(autoCompleteCity)\(cityStr)&apikey=\(apiKey)"
        AF.request(url).responseJSON { (response) in
            if response.error != nil {
                print(response.error!)
                return
            }
            self.arr = [CityInformation]()
            let autoCompleteJSON : [JSON] = JSON(response.data!).arrayValue
            for cityJSON in autoCompleteJSON {
                let key = cityJSON["Key"].stringValue
                let name = cityJSON["LocalizedName"].stringValue
                let country = cityJSON["Country"]["LocalizedName"].stringValue
                let adminArea = cityJSON["AdministrativeArea"]["LocalizedName"].stringValue
                let city = CityInformation(key, name, country, adminArea)
                self.arr.append(city)
            }
            self.tblView.reloadData()
            
        }// end of AF Request
        
    }// End oif fun ction
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            arr = [CityInformation]()
            tblView.reloadData()
            return
        }
        
        if searchText.count <= 2 {
            return
        }
        getCityNames(for: searchText)
    }
    
    func addCityToDB( city : CityInformation){
        
        do {
            let realm = try Realm()
            try realm.write({
                realm.add(city, update: .all)
            })
        }
        catch{
           print("Error in writing to Database")
        }
    }

}
