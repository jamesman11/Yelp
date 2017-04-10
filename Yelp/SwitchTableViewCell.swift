//
//  SwitchTableViewCell.swift
//  Yelp
//
//  Created by James Man on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func SwitchCell(switchCell: SwitchTableViewCell, didChangeValue value:Bool)
}
class SwitchTableViewCell: UITableViewCell {
    @IBOutlet var switchLabel: UILabel!
    @IBOutlet var onSwitch: UISwitch!
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        onSwitch.addTarget(self, action: #selector(SwitchTableViewCell.switchValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func switchValueChanged(){
        delegate?.SwitchCell?(switchCell: self, didChangeValue: onSwitch.isOn)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
