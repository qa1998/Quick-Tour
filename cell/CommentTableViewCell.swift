//
//  CommentTableViewCell.swift
//  Quick Tour
//
//  Created by quanganh on 3/1/20.
//  Copyright © 2020 quanganh. All rights reserved.

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var deleteLabel: UIButton!
    @IBOutlet weak var descriptionLB: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLAbel: UILabel!
    var delegate: deleteCommentDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deleteLabelAction(_ sender: UIButton) {
        delegate.delete(index: deleteLabel.tag)
    }

}

protocol deleteCommentDelegate {
    func delete(index: Int)
}
