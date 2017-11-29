//
//  MainViewController.swift
//  FoodList
//
//  Created by 이선협 on 2017. 11. 29..
//  Copyright © 2017년 이선협. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var restaurantsSection: [(key: String, restaurants: [Restaurant])] = []
    let notificationName = Notification.Name("ListAPIReqeust")

    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.setRestaurantUI(notification:)), name: notificationName, object: nil)
        restaurantsSection.removeAll()
        fetchRestaurantData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
    }
    
    func setRestaurantUI(notification: Notification) {
        guard let restaurants = notification.userInfo?["restaurants"] as? [Restaurant],
            let key = notification.userInfo?["key"] as? String else { return }
        self.restaurantsSection.append((key, restaurants))
        
        if self.restaurantsSection.count == 4 {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchRestaurantData() {
        // Main Data
        NetworkManager.shared.request(urlString: "http://crong.codesquad.kr:8080/woowa/main") { (data) in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let restaurantsJson = json as? [Any] {
                var restaurants: [Restaurant] = []
                for restaurantJson in restaurantsJson {
                    if let restaurant = Restaurant(json: restaurantJson as! [String: Any]) {
                        restaurants.append(restaurant)
                    }
                }
                NotificationCenter.default.post(name: self.notificationName, object: nil,
                                                userInfo: ["key": "main", "restaurants" : restaurants])
            }
        }
        
        NetworkManager.shared.request(urlString: "http://crong.codesquad.kr:8080/woowa/soup") { (data) in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let restaurantsJson = json as? [Any] {
                var restaurants: [Restaurant] = []
                for restaurantJson in restaurantsJson {
                    if let restaurant = Restaurant(json: restaurantJson as! [String: Any]) {
                        restaurants.append(restaurant)
                    }
                }
                NotificationCenter.default.post(name: self.notificationName, object: nil,
                                                userInfo: ["key": "soup", "restaurants" : restaurants])
            }
        }
        
        NetworkManager.shared.request(urlString: "http://crong.codesquad.kr:8080/woowa/course") { (data) in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let restaurantsJson = json as? [Any] {
                var restaurants: [Restaurant] = []
                for restaurantJson in restaurantsJson {
                    if let restaurant = Restaurant(json: restaurantJson as! [String: Any]) {
                        restaurants.append(restaurant)
                    }
                }
                NotificationCenter.default.post(name: self.notificationName, object: nil,
                                                userInfo: ["key": "course", "restaurants" : restaurants])
            }
        }
        
        NetworkManager.shared.request(urlString: "http://crong.codesquad.kr:8080/woowa/side") { (data) in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let restaurantsJson = json as? [Any] {
                var restaurants: [Restaurant] = []
                for restaurantJson in restaurantsJson {
                    if let restaurant = Restaurant(json: restaurantJson as! [String: Any]) {
                        restaurants.append(restaurant)
                    }
                }
                NotificationCenter.default.post(name: self.notificationName, object: nil,
                                                userInfo: ["key": "side", "restaurants" : restaurants])
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.restaurantsSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurantsSection[section].restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as! RestaurantCell
        let restaurant = self.restaurantsSection[indexPath.section].restaurants[indexPath.row]
        
        cell.configure(restaurant: restaurant)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderCell") as! SectionHeaderCell
        
        switch self.restaurantsSection[section].key {
        case "main":
            headerCell.badgeLabel.text = "메인"
            headerCell.descriptionLabel.text = "메인 요리"
        case "soup":
            headerCell.badgeLabel.text = "국・찌개"
            headerCell.descriptionLabel.text = "김이 모락모락 국・찌개"
        case "course":
            headerCell.badgeLabel.text = "코스"
            headerCell.descriptionLabel.text = "코스 요리"
        case "side":
            headerCell.badgeLabel.text = "밑반찬"
            headerCell.descriptionLabel.text = "언제 먹어도 든든한 밑반찬"
        default:
            print("Error")
        }
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        
        let restaurant = self.restaurantsSection[indexPath.section].restaurants[indexPath.row]
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let productDetailViewController = mainStoryboard.instantiateViewController(withIdentifier: "ProductDetail") as! ProductDetailViewController
        productDetailViewController.detailHash = restaurant.detailHash
        productDetailViewController.restaurantTitle = restaurant.title
        self.show(productDetailViewController, sender: nil)
    }
}
