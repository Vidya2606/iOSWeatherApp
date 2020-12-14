//
//  CityInfo.swift
//  NEUWeather
//
//  Created by Maheshwara Reddy on 12/3/20.
//

import Foundation
import RealmSwift

class CityInformation: Object {
    @objc dynamic var key : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var country : String = ""
    @objc dynamic var adminArea : String = ""
    
    init(_ key: String,_ name: String,_ country: String, _ adminArea: String) {
        super.init()
        self.key = key
        self.name = name
        self.country = country
        self.adminArea = adminArea
    }
    
    required init() {
    }
    
    override static func primaryKey() -> String? {
        return "key"
    }
    
}
