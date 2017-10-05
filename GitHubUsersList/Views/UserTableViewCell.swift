//
//  UserTableViewCell.swift
//  GitHubUsersList
//
//  Created by Hendrik Kusuma on 10/5/17.
//  Copyright © 2017 Kusumas. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
	@IBOutlet weak var loginLabel:UILabel!
	@IBOutlet weak var githubPageURLLabel:UILabel!
	@IBOutlet weak var accountTypeLabel:UILabel!
	@IBOutlet weak var favoriteButton: UIButton!
	@IBOutlet weak var siteAdminLabel:UILabel!
	@IBOutlet weak var avatarImageView:UIImageView!
	
	var singleUser : Users!
	weak var delegate: UserTableViewCellDelegate?
	
	@IBAction func handleButtonPress(sender: UIButton) {
		self.delegate?.customCell(self, didPressButton: sender)
	}
	
	
}
protocol UserTableViewCellDelegate: class {
	func customCell(_ cell: UITableViewCell, didPressButton: UIButton)
}
