//
//  PillsTableViewCell.swift
//  Pill Box
//
//  Created by Дмитрий Подольский on 08.12.2020.
//

import UIKit

class PillsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgLabel: UILabel!
    @IBOutlet weak var namePillsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func set(object: Pills.PillsBox) {
        self.imgLabel.text = object.imgEmoji
        self.namePillsLabel.text = object.name
        self.descriptionLabel.text = object.description
    }
}
