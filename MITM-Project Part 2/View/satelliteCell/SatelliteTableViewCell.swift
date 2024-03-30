//
//  SatelliteTableViewCell.swift
//  MITM-Alamofire
//
//  Created by Vibhash Kumar on 27/03/24.
//

import UIKit

final class SatelliteTableViewCell: UITableViewCell {
    
    // MARK:  Private IBOutlet
    
    @IBOutlet private weak var cellView : UIView!
    @IBOutlet private weak var id : UILabel!
    @IBOutlet private weak var countryLbl : UILabel!
    @IBOutlet private weak var launchDate : UILabel!
    @IBOutlet private weak var launcher : UILabel!
    @IBOutlet private weak var massLbl : UILabel!
    
    // MARK:  View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
   
    // MARK:  Cell Configuration
    
    func configureCell(viewModel : SatelliteCellViewModel?){
        id.text = viewModel?.id
        launchDate.text = viewModel?.launch_date
        launcher.text = "Launcher: \(viewModel?.launcher ?? "")"
        massLbl.text = "Mass: \(viewModel?.mass ?? "")"
        countryLbl.text = "Country Name: \(viewModel?.country ?? "")"
    }
}
