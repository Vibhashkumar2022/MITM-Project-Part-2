//
//  ListTableViewAdapter.swift
//  MITM-Alamofire
//
//  Created by Vibhash Kumar on 27/03/24.
//

import Foundation
import UIKit

protocol ListViewAdapterDelegate : NSObject {
    func didSelectCellCallBack( index : IndexPath)
    func deleteItemFromCart(index : IndexPath)
   
}
extension ListViewAdapterDelegate {
    func deleteItemFromCart(index : IndexPath){}
    func addMoreBtnCallBack(){}
}

final class ListViewAdapter : NSObject {
    
    //MARK: Public Properties
    var viewModel : ListViewModel?
    
    //MARK: Private Properties
    private var satellitedataSource : [SatelliteCellViewModel] = []
    private var tableView : UITableView!
    private var delegate : ListViewAdapterDelegate
    
    
    //MARK: Init
    init(tableView : UITableView , delegate : ListViewAdapterDelegate, viewModel :ListViewModel){
        self.tableView = tableView
        self.delegate = delegate
        self.viewModel = viewModel
        super.init()
        registerCells()
    }
    
    //MARK: Public Methods
    func configureDataSourceForSelection() {
        self.satellitedataSource = viewModel?.customerSatelliteDataSource ?? []
        loadData()
    }
    
    //MARK: Private Methods
    private func registerCells() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: CGFloat(35), left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
        tableView.register(UINib(nibName: "SatelliteTableViewCell", bundle: nil), forCellReuseIdentifier: "SatelliteTableViewCell")
    }
    
    
    private func loadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
    //MARK: UITableViewDataSource
extension  ListViewAdapter : UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Satellite Details"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return satellitedataSource.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : SatelliteTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SatelliteTableViewCell", for: indexPath) as? SatelliteTableViewCell  else  {
            return UITableViewCell()
        }
        
        cell.configureCell(viewModel: satellitedataSource[indexPath.row])
        return cell
    }
}



//MARK: UITableViewDelegate
extension  ListViewAdapter : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectCellCallBack(index: indexPath)
    }
}



