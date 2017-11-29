//
//  ProductDetailViewController.swift
//  FoodList
//
//  Created by 이선협 on 2017. 11. 29..
//  Copyright © 2017년 이선협. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageScrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var descriptionView: UIView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var pointLabel: UILabel!
    @IBOutlet var deliveryInfoLabel: UILabel!
    @IBOutlet var deliveryFeeLabel: UILabel!
    
    @IBOutlet var orderButton: UIButton!
    
    let notificationName = Notification.Name("DetailAPIReqeust")
    var detailHash = ""
    var restaurantTitle = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setRestaurantUI(notification:)), name: notificationName, object: nil)
        
        getRestaurantDetailData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
    }
    
    @IBAction func order() {
        let alertController = UIAlertController(title: "주문", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setRestaurantUI(notification: Notification) {
        guard let restaurantDetail = notification.userInfo?["restaurant"] as? RestaurantDetail else { return }
        DispatchQueue.main.async {
            self.titleLabel.text = restaurantDetail.title
            self.descriptionLabel.text = restaurantDetail.productDescription
            self.priceLabel.text = restaurantDetail.price
            self.pointLabel.text = restaurantDetail.point
            self.deliveryInfoLabel.text = restaurantDetail.deliveryInfo
            self.deliveryFeeLabel.text = restaurantDetail.deliveryFee
            
            for i in 0..<restaurantDetail.thumbImages.count {
                let imageView = UIImageView()
                let x = self.imageScrollView.frame.size.width * CGFloat(i)
                imageView.frame = CGRect(x: x, y: 0, width: self.imageScrollView.frame.width, height: self.imageScrollView.frame.height)
                imageView.contentMode = .scaleAspectFit
                imageView.image = URL(string: restaurantDetail.thumbImages[i])
                    .flatMap { try! Data.init(contentsOf: $0) }
                    .flatMap { UIImage(data: $0) }
                
                self.imageScrollView.contentSize.width = self.imageScrollView.frame.size.width * CGFloat(i + 1)
                self.imageScrollView.addSubview(imageView)
            }
            self.pageControl.numberOfPages = restaurantDetail.thumbImages.count
            
            var sumY: CGFloat = 454
            for i in 0..<restaurantDetail.detailSectionImages.count {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.image = URL(string: restaurantDetail.detailSectionImages[i])
                    .flatMap { try! Data.init(contentsOf: $0) }
                    .flatMap { UIImage(data: $0) }
                imageView.sizeToFit()
                
                let ratio = UIScreen.main.bounds.size.width / imageView.image!.size.width
                let ratioHeight = imageView.image!.size.height * ratio
                print(ratioHeight)
                imageView.frame = CGRect(x: 0, y: sumY, width: UIScreen.main.bounds.size.width, height: ratioHeight)
                sumY += ratioHeight
                
                self.scrollView.contentSize.height = sumY
                self.scrollView.addSubview(imageView)
                self.orderButton.removeFromSuperview()
                self.view.addSubview(self.orderButton)
            }
        }
    }
    
    func getRestaurantDetailData() {
        NetworkManager.shared.request(urlString: "http://52.78.212.27:8080/woowa/detail/\(self.detailHash)") { (data) in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let restaurantsDetailJson = json as? [String: Any] {
                if let restaurantDetail = RestaurantDetail(json: restaurantsDetailJson, title: self.restaurantTitle) {
                    NotificationCenter.default.post(name: self.notificationName, object: nil,
                                                    userInfo: ["restaurant" : restaurantDetail])
                }
            }
        }
    }
}

extension ProductDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            self.orderButton.frame.origin.y = UIScreen.main.bounds.size.height + scrollView.contentOffset.y - 44 - 64
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.imageScrollView {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            self.pageControl.currentPage = Int(pageNumber)
        }
    }
}
