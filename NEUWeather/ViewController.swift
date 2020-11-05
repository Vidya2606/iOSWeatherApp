//
//  ViewController.swift
//  NEUWeather
//
//  Created by Ashisish on 10/23/20.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftSpinner
import SwiftyJSON
import PromiseKit
import RealmSwift


class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
   
    
    
    @IBOutlet weak var txtLat: UILabel!
    @IBOutlet weak var txtLng: UILabel!
    @IBOutlet weak var txtCityName: UILabel!
    @IBOutlet weak var txtCurrentTemp: UILabel!
    @IBOutlet weak var txtForecast: UILabel!
    @IBOutlet weak var txtMax: UILabel!
    @IBOutlet weak var txtMin: UILabel!
    
    
    @IBOutlet weak var tblView: UITableView!
    
    var arr = [CityInformation]()
    
    
    let locationManager = CLLocationManager()
    
    var lat : CLLocationDegrees?
    var lng : CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestLocation()
        
        tblView.delegate = self
        tblView.dataSource = self
        loadCitiesFromDB()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let currLocation = locations.last {
            lat = currLocation.coordinate.latitude
            lng = currLocation.coordinate.longitude
            txtLat.text = "\(lat!)"
            txtLng.text = "\(lng!)"
            print(lat!)
            print(lng!)
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error in getting Location : \(error)")
    }
    
    
  
    
    func getURLCurrentLocation(_ lat : CLLocationDegrees, _ lng: CLLocationDegrees) -> String{
        var url = geoPositionURL
        url.append("apikey=\(apiKey)&q=\(lat),\(lng)")
        return url
    }
    
    @IBAction func getWeather(_ sender: Any) {
        
        guard let latitude = lat, let longitude = lng else { return }

        let url = getURLCurrentLocation(latitude, longitude)

        getLocationData(for: url).done{ (key, city) in
            
            self.txtCityName.text = "City: \(city)"
            // Gdet One Hour forecast
            self.getOneHourForecast(for: key).done { (temp, forecast)  in
                self.txtCurrentTemp.text = "Current Temp: \(temp)"
                self.txtForecast.text = "Forecast: \(forecast)"

            }
            .catch { (error) in
                print("Error in getting One hour forecast \(error)")
            }
            
            // get One day forecast
            self.getOneDayForecast(for: key).done{ (min, max) in
                self.txtMin.text = "Min temp: \(min)"
                self.txtMax.text = "Max temp: \(max)"
                
            }
            .catch { (error) in
                print("Error in getting One day forecast \(error)")
            }
            
        }
        .catch { (error) in
            print(error)
        }

    }
    
    // This returns (MinTemp, MaxTemp)
    func getOneDayForecast(for key : String) -> Promise<(Int, Int)>{
        return Promise<(Int, Int)> { seal -> Void in
            
            let url = "\(oneDayURL)\(key)?apikey=\(apiKey)"
            AF.request(url).responseJSON{ response in
                
                if response.error != nil {
                    seal.reject(response.error!)
                }
                let oneDayJSON :JSON = JSON(response.data!)
                let min = oneDayJSON["DailyForecasts"][0]["Temperature"]["Minimum"]["Value"].intValue
                let max = oneDayJSON["DailyForecasts"][0]["Temperature"]["Maximum"]["Value"].intValue

                seal.fulfill((min, max))
                
            }
            
            
        }
    }
    
    // Thnis fuinction rteturns (Temp, forecast)
    func getOneHourForecast(for key : String) -> Promise<(Int, String)> {
        
        return Promise<(Int, String)> { seal -> Void in
            
            let url = "\(oneHourURL)\(key)?apikey=\(apiKey)"
            
            AF.request(url).responseJSON{ response in
                
                if response.error != nil {
                    seal.reject(response.error!)
                }
                let oneHourJSON :JSON = JSON(response.data!)
                let forecast = oneHourJSON[0]["IconPhrase"].stringValue
                let temp = oneHourJSON[0]["Temperature"]["Value"].intValue
                
                seal.fulfill((temp, forecast))
                
            }
            
        }
        
    }
    
    
    
    
    
    // this fun ction will return (City key , city Name)
    func getLocationData( for Url: String) -> Promise<(String, String)>{
        
        return Promise<(String, String)> { seal -> Void in
            
            AF.request(Url).responseJSON{ response in
                
                if response.error != nil {
                    seal.reject(response.error!)
                }
                
                let currJSON :JSON = JSON(response.data!)
                
                var key = ""
                var cityName = ""
                
                if currJSON["ParentCity"].exists() {
                    key = currJSON["ParentCity"]["Key"].stringValue
                    cityName = currJSON["ParentCity"]["LocalizedName"].stringValue
                }else{
                    key = currJSON["Key"].stringValue
                    cityName = currJSON["LocalizedName"].stringValue
                }
            
                
                seal.fulfill((key, cityName))
            }
        }// end of promise
    }// end oif function
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(arr[indexPath.row].name), \(arr[indexPath.row].adminArea), \(arr[indexPath.row].country)"

        return cell

    }
    
    
    @IBAction func addCity(_ sender: Any) {
        
        let alert = UIAlertController(title: "Please Type name of the city", message: "", preferredStyle: .alert)
        
        let OK = UIAlertAction(title: "OK", style: .default) { (action) in
            print("OK Pressed")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel")
        }
        
        
    }
    
    func loadCitiesFromDB(){
        do{
            let realm = try Realm()
            let cities = realm.objects(CityInformation.self)
            
            for city in cities{
                arr.append(city)
            }
            tblView.reloadData()
            
            
        }catch{
            print("Error in loading cities")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = arr[indexPath.row]
        
        self.txtCityName.text = "City: \(city.name)"
        // Gdet One Hour forecast
        self.getOneHourForecast(for: city.key).done { (temp, forecast)  in
            self.txtCurrentTemp.text = "Current Temp: \(temp)"
            self.txtForecast.text = "Forecast: \(forecast)"

        }
        .catch { (error) in
            print("Error in getting One hour forecast \(error)")
        }
        
        // get One day forecast
        self.getOneDayForecast(for: city.key).done{ (min, max) in
            self.txtMin.text = "Min temp: \(min)"
            self.txtMax.text = "Max temp: \(max)"
            
        }
        .catch { (error) in
            print("Error in getting One day forecast \(error)")
        }
        
    }
    
    
    


}

