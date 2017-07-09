//
//  ProductListController.swift
//  ProductHuntClient
//
//  Created by Vadim on 7/7/17.
//  Copyright © 2017 Vadim Prosviryakov. All rights reserved.
//

import UIKit
import RxSwift
import KVNProgress


class ProductListController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    fileprivate var product: [Product] = []
    var category = "Tech"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 88
        title = category
        KVNProgress.show()
        downloadProduct()
        refreshDown()
    }
    
    
    func refreshDown() {
        refreshControl = UIRefreshControl()
        // refreshControl.attributedTitle = NSAttributedString(string: "Data is updated")
        refreshControl.addTarget(self, action: #selector(ProductListController.refreshData(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func refreshData(sender: AnyObject) {
        refreshBegin(newtext: "Refresh", refreshEnd: {(x: Int) -> () in
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        })
    }
    
    private func refreshBegin(newtext: String, refreshEnd:@escaping (Int) -> ()) {
        DispatchQueue.global().async {
            self.downloadProduct()
            sleep(2)
            DispatchQueue.main.async {
                refreshEnd(0)
            }
        }
    }
    
    private func downloadProduct() {
        ProductApi.instance.getProducts(category: category.localizedLowercase).subscribe(onNext: { [weak self] product in
            self?.product = product
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            self?.tableView.reloadData()
            KVNProgress.dismiss()
        }).addDisposableTo(disposeBag)
    }
    

    @IBAction func menuSelect(_ sender: Any) {
        let profileVC = storyboard!.instantiateViewController(withIdentifier: "MenuSelected")
        let nc = NavigationController(rootViewController: profileVC)
        present(nc, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productDetail" {
            if let selectedIndexPath = self.tableView.indexPathsForSelectedRows?.first {
                let selectedProduct = self.product[selectedIndexPath.row]
                let productDetailController = segue.destination as! ProductDetailController
                productDetailController.productDetail = selectedProduct
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - UITableViewDataSource
extension ProductListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductListCell
        
        guard let url = NSURL(string: product[indexPath.row].thumbnailProduct?["image_url"]! as! String) else {
            return cell
        }
        cell.thumbnailProduct.sd_setImage(with: url as URL, completed: { (image, error, cache, url) in
            cell.thumbnailProduct.image = image
        })
        
        cell.nameProduct.text = product[indexPath.row].nameProduct
        cell.descriptionProduct.text = product[indexPath.row].descriptionProduct
        cell.upvotesProduct.text = "+ " + product[indexPath.row].upvotesProduct.description
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProductListController: UITableViewDelegate {
    
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

// MARK: - UITableViewCell
class ProductListCell: UITableViewCell {
    @IBOutlet weak var thumbnailProduct: UIImageView!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var descriptionProduct: UILabel!
    @IBOutlet weak var upvotesProduct: UILabel!
}
