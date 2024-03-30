//
//  ListDataModel.swift
//  MITM-Alamofire
//
//  Created by Vibhash Kumar on 27/03/24.
//

import Foundation

struct SatelliteResponseModel : Codable {
   let satellites : [customer_satellites]?
    enum CodingKeys: String, CodingKey {
        case satellites = "customer_satellites"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.satellites = try container.decodeIfPresent([customer_satellites].self, forKey: .satellites)
    }
}

struct customer_satellites : Codable {
    var countryName : String?
    var id : String?
    var launch_date : String?
    var launcher : String?
    var mass : String?
    enum CodingKeys: String, CodingKey {
        case countryName = "country"
        case id, launch_date, launcher, mass
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.countryName = try container.decodeIfPresent(String.self, forKey: .countryName)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.launcher = try container.decodeIfPresent(String.self, forKey: .launcher)
        self.mass = try container.decodeIfPresent(String.self, forKey: .mass)
        self.launch_date = try container.decodeIfPresent(String.self, forKey: .launch_date)
    }
}
