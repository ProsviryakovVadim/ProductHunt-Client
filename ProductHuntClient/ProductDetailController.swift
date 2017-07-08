//
//  ProductDetailController.swift
//  ProductHuntClient
//
//  Created by Vadim on 7/7/17.
//  Copyright © 2017 Vadim Prosviryakov. All rights reserved.
//

import UIKit
import KVNProgress

final class ProductDetailController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var productDetail: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        KVNProgress.show()
        tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webView" {
            let url = self.productDetail.redirectUrl
            let webView = segue.destination as! WebController
            webView.webUrl = url
        }
    }
}

// MARK: - UITableViewDataSource
extension ProductDetailController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! ProductDetailCell
            guard let url = NSURL(string: productDetail.thumbnailProduct?["image_url"]! as! String) else {
                return cell
            }
            cell.thumbnailProductDetail.sd_setImage(with: url as URL, completed: { (image, error, cache, url) in
                cell.thumbnailProductDetail.image = image
            })
            cell.nameProductDetail.text = productDetail?.nameProduct
            cell.descriptionProductDetail.text = productDetail?.descriptionProduct
            tableView.rowHeight = 88
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "screenshotCell", for: indexPath) as! ProductScreenshotCell

            guard let url = NSURL(string: productDetail.screenshotUrl?["300px"]! as! String) else {
                return cell
            }
            cell.screenshotProductDetail.sd_setImage(with: url as URL, completed: { (image, error, cache, url) in
                cell.screenshotProductDetail.image = image
                KVNProgress.dismiss()
            })
            
            tableView.rowHeight = 250
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "getItCell", for: indexPath) as! ProductGetItCell
            tableView.rowHeight = 44
            return cell
        default: break
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension ProductDetailController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.white
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - UITableViewCell
class ProductDetailCell: UITableViewCell {
    @IBOutlet weak var thumbnailProductDetail: UIImageView!
    @IBOutlet weak var nameProductDetail: UILabel!
    @IBOutlet weak var descriptionProductDetail: UILabel!
}

class ProductScreenshotCell: UITableViewCell {
    @IBOutlet weak var screenshotProductDetail: UIImageView!
}

class ProductGetItCell: UITableViewCell {
    
    @IBAction func getIt(_ sender: Any) {
        
    }
}
