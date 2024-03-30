//
//  listTableViewCellViewModel.swift
//  MITM-Alamofire
//
//  Created by Vibhash Kumar on 27/03/24.
//

import Foundation

struct SatelliteCellViewModel {
    var country : String?
    var id : String?
    var launch_date : String?
    var launcher : String?
    var mass : String?
    
    init(country: String? = nil, id: String? = nil, launch_date: String? = nil, launcher: String? = nil, mass: String? = nil) {
        self.country = country
        self.id = id
        self.launch_date = launch_date
        self.launcher = launcher
        self.mass = mass
    }
}
