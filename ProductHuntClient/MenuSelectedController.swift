//
//  MenuSelectedController.swift
//  ProductHuntClient
//
//  Created by Vadim on 7/9/17.
//  Copyright © 2017 Vadim Prosviryakov. All rights reserved.
//

import UIKit
import RxSwift
import KVNProgress

class MenuSelectedController: UIViewController {
        
    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    var categories: [Category] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = UIColor(red: 237, green: 237, blue: 237)
        KVNProgress.show()
        getMenu()
    }
    
    private func getMenu() {
        ProductApi.instance.getCategory().subscribe(onNext: { category in
            self.categories = category
        }).addDisposableTo(disposeBag)
        KVNProgress.dismiss()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "select" {
            if let selectedIndexPath = self.tableView.indexPathsForSelectedRows?.first {
                let selectedProduct = self.categories[selectedIndexPath.row]
                let destinationNavigationController = segue.destination as! UINavigationController
                let productDetailController = destinationNavigationController.topViewController as! ProductListController
                productDetailController.category = selectedProduct.category
                productDetailController.title = selectedProduct.category
            }
        }
    }
}

extension MenuSelectedController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuSelectedCell
        cell.menuText.text = categories[indexPath.row].category
        return cell
    }
}

extension MenuSelectedController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.0) // very light gray
        } else {
            cell.backgroundColor = UIColor.white
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


class MenuSelectedCell: UITableViewCell {
    
    @IBOutlet weak var menuText: UILabel!
}
