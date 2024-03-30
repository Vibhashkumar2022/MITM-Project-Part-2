//
//  ListViewModel.swift
//  MITM-Alamofire
//
//  Created by Vibhash Kumar on 27/03/24.
//

import Foundation

protocol ViewServices : AnyObject {
    func reloadTableView()
    func updateStatusLabel(isSuccess : Bool)
}

enum PinningType : Int {
    case certificate = 0
    case publicKey
    
    var pinningTypeString : String {
        switch self {
        case .certificate:
            return "Cirtificate Pinning"
        case .publicKey:
            return "Public Key Pinning"
        }
    }
}

enum ClientSelected {
    case urlsession
    case alamofire
}

class ListViewModel {
    var selectedPinningType : PinningType = .certificate
    var selectedClientType : ClientSelected = .urlsession
    weak var viewDelegate : ViewServices?
    var customerSatelliteDataSource : [SatelliteCellViewModel]?
    @MainActor func getResponseFromApi() {
        switch selectedPinningType {
        case .publicKey:
            Task {
                do{
                    let response : SatelliteResponseModel = try await NetworkManagerWithPublicKeys.shared.request(url: URL(string: costumerStateliteUrl))
                    convertListSatelliteResponseCellViewModel(dataModel: response.satellites)
                    viewDelegate?.updateStatusLabel(isSuccess: true)
                }catch{
                    print(error)
                    viewDelegate?.updateStatusLabel(isSuccess: false)
                }
            }
            
        case .certificate:
            Task {
                do{
                    let response : SatelliteResponseModel = try await NetworkManager.shared.request(url: URL(string: costumerStateliteUrl))
                    convertListSatelliteResponseCellViewModel(dataModel: response.satellites)
                    viewDelegate?.updateStatusLabel(isSuccess: true)
                }catch{
                    print(error)
                    viewDelegate?.updateStatusLabel(isSuccess: false)
                }
                
            }
        }
    }
    
    func convertListSatelliteResponseCellViewModel(dataModel : [customer_satellites]?) {
        self.customerSatelliteDataSource = (dataModel)?.map({ item in
            SatelliteCellViewModel(country: item.countryName, id: item.id, launch_date: item.launch_date, launcher: item.launcher, mass: item.mass)
        }) ?? []
        self.viewDelegate?.reloadTableView()
    }
    
    func updateSelectedPinningType(selectedPinningType : PinningType) {
        self.selectedPinningType = selectedPinningType
    }
    
}
