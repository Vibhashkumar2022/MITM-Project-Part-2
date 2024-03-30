//
//  ListViewController.swift
//  MITM-Alamofire
//
//  Created by Vibhash Kumar on 27/03/24.
//

import UIKit

final class ListViewController: UIViewController {
    @IBOutlet private weak var listView : UITableView!
    @IBOutlet private weak var pinnedStatus : UILabel!
    @IBOutlet private weak var SSLPinningType: UISegmentedControl!
    var viewModel = ListViewModel()
    private var adapter : ListViewAdapter?
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.getApiResponse()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: Configure Tableview Adapter
    private func configureTableView(){
        self.adapter = ListViewAdapter(tableView: listView, delegate: self, viewModel: viewModel)
    }
    
    @IBAction private func pinningTypeSelection(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.viewModel.updateSelectedPinningType(selectedPinningType:.certificate)
        case 1:
            self.viewModel.updateSelectedPinningType(selectedPinningType:.publicKey)
        default:
            break
        }
        self.getApiResponse()
    }
    
}

extension ListViewController {
    //MARK: Configure Datasource for Adapter
   private func getApiResponse(){
        self.viewModel.customerSatelliteDataSource = []
        self.adapter?.configureDataSourceForSelection()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.viewModel.getResponseFromApi { response, error in
                self.updateStatusLabel(isSuccess: (error == nil))
                self.viewModel.convertListSatelliteResponseCellViewModel(dataModel: response?.satellites)
                self.adapter?.configureDataSourceForSelection()
            }
        }
    }
    
    func updateStatusLabel(isSuccess : Bool) {
        let msg = self.viewModel.selectedPinningType.pinningTypeString + " \(isSuccess ? "Success" : "Failed")"
        DispatchQueue.main.async {
            self.pinnedStatus.text = msg
        }
    }
}

//MARK:  delegates for Adapter
extension ListViewController : ListViewAdapterDelegate {
    func didSelectCellCallBack(index: IndexPath) {
        
    }
    
    func deleteItemFromCart(index: IndexPath) {
        
    }
}
