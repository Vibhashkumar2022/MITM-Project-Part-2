//
//  ListViewModel.swift
//  MITM-Alamofire
//
//  Created by Vibhash Kumar on 27/03/24.
//

import Foundation

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
    var customerSatelliteDataSource : [SatelliteCellViewModel] = []
    func getResponseFromApi(completion:@escaping((_ response : SatelliteResponseModel?,_ error :Error?)->Void)){
        switch selectedPinningType {
        case .publicKey:
            debugPrint("Using Public Key")
            getResponseFromApiUsingPublicKey(client: selectedClientType) { response, error in
                if self.selectedClientType == .urlsession {
                    if let arr = response {
                        completion(arr, error)
                    }
                } else {
                    if let arr = response {
                        completion(arr, error)
                    }
                }
            }
        default:
            debugPrint("Using Certificate Pinning")
            getResponseFromApiUsingCertificate(client: selectedClientType) { response, error in
                if self.selectedClientType == .urlsession {
                    if let arr = response {
                        completion(arr, error)
                    }
                } else {
                    if let arr = response {
                        completion(arr, error)
                    }
                }
            }
        }
    }
    
    func getResponseFromApiUsingCertificate(client: ClientSelected,completion:@escaping((_ response : SatelliteResponseModel?,_ error :Error?)->Void)){
        if client == .urlsession {
            NetworkManager.shared.request(url: URL(string: costumerStateliteUrl), expecting: SatelliteResponseModel.self) { data, error in
                if let arr = data {
                    completion(arr, error)
                }
                return
            }
        } else {
              // TODO:  Performing task with Alamofire in part 3
        }
    }
    
    func getResponseFromApiUsingPublicKey(client: ClientSelected,completion:@escaping((_ response : SatelliteResponseModel?,_ error :Error?)->Void)){
        if client == .urlsession {
            NetworkManagerWithPublicKeys.shared.request(url: URL(string: costumerStateliteUrl), expecting: SatelliteResponseModel.self) { data, error in
                if let arr = data {
                    completion(arr, error)
                }
                return
            }
        } else {
            // TODO:  Performing task with Alamofire in part 3
        }
    }
    
    
    func convertListSatelliteResponseCellViewModel(dataModel : [customer_satellites]?) {
        self.customerSatelliteDataSource = (dataModel)?.map({ item in
            SatelliteCellViewModel(country: item.countryName, id: item.id, launch_date: item.launch_date, launcher: item.launcher, mass: item.mass)
        }) ?? []
    }
    
    func updateSelectedPinningType(selectedPinningType : PinningType) {
        self.selectedPinningType = selectedPinningType
    }
    
}
