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
        self.inititateViewModel()
        // Do any additional setup after loading the view.
    }
    
    private func inititateViewModel() {
        self.viewModel.viewDelegate = self
        configureTableView()
        self.getApiResponse()
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

extension ListViewController : ViewServices {
    
    func reloadTableView() {
        self.adapter?.configureDataSourceForSelection()
    }
    
    //MARK: Configure Datasource for Adapter
   private func getApiResponse(){
        self.viewModel.customerSatelliteDataSource = []
        self.viewModel.getResponseFromApi()
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
