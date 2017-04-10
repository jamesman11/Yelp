//
//  FiltersViewController.swift
//  Yelp
//
//  Created by James Man on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func FiltersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters:[String : Any])
}
class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {
    @IBOutlet var filterTableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    var categories: [[String:String]]!
    var switchStates = [Int:Dictionary<Int, Bool>]()
    var filterSelections = Helper.filtersSections
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTableView.delegate = self
        filterTableView.dataSource = self
        
        // Set yelp like navigation bar color
        navigationController?.navigationBar.barTintColor = Helper.UIColorFromHex(rgbValue: 0xd32323, alpha: 1.0)
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearch(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        var filters: [String : Any] = [
            "deal" : false
        ]
        for (section, data) in switchStates {
            switch(section){
                case Helper.DEAL_TYPE:
                    filters["deal"] = data[0]
                    break;
//                case Helper.DISTANCE_TYPE:
//                    filters["distance"] = data[0]
//                    break;
//                case Helper.SORT_BY_TYPE:
//                    filters["distance"] = data[0]
//                    break;
                case Helper.CATEGORY_TYPE:
                    var categories = [String]()
                    for (row, isSelected) in data {
                        if isSelected {
                            categories.append(Helper.categories[row]["code"]!)
                        }
                    }
                    filters["categories"] = categories
                    break;
            default:
                break;
            }
        }
        delegate?.FiltersViewController?(filtersViewController: self, didUpdateFilters: filters)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = filterTableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchTableViewCell
        let filterSelection = filterSelections[indexPath.section]
        let filterLabels = filterSelection["cellLabels"] as! [String]
        cell.switchLabel.text = filterLabels[indexPath.row]
        cell.delegate = self
        if switchStates[indexPath.section] != nil {
            cell.onSwitch.isOn = switchStates[indexPath.section]?[indexPath.row] ?? false
        } else {
            cell.onSwitch.isOn = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let labels = filterSelections[section]["cellLabels"] as! [String]
        return labels.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filterSelections[section]["title"] as? String
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return filterSelections.count
    }
    func SwitchCell(switchCell: SwitchTableViewCell, didChangeValue value: Bool) {
        let indexPath = filterTableView.indexPath(for: switchCell)!
        if switchStates[indexPath.section] == nil {
            switchStates[indexPath.section] = [:]
        }
        switchStates[indexPath.section]?[indexPath.row] = value
    }
}
