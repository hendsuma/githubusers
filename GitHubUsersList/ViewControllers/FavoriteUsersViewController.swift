//
//  FavoriteUsersViewController.swift
//  GitHubUsersList
//
//  Created by Hendrik Kusuma on 10/5/17.
//  Copyright © 2017 Kusumas. All rights reserved.
//

import UIKit
import PKHUD

class FavoriteUsersViewController: UIViewController {
	var allFavoriteUsers : [Users] = []
	@IBOutlet var allFavoriteUsersTableView : UITableView!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.allFavoriteUsers = Users.getAllFavoriteUsers()
		if (self.allFavoriteUsers.count <= 0) {
			HUD.flash(.label("You Have No Favorite User Yet"), delay: 2.0) { _ in
//				print("License Obtained.")
			}
		}
		else{
			allFavoriteUsersTableView.reloadData()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "ShowUserDetails"){
			let selectedUser = sender as! Users
			let nextVC = segue.destination as! UserGitHubDetailsViewController
			nextVC.selectedUser = selectedUser
		}
	}
	
	
}
extension FavoriteUsersViewController : UITableViewDelegate,UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.allFavoriteUsers.count;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let tablecell = tableView.dequeueReusableCell(withIdentifier: "UserTableCell", for: indexPath) as! UserTableViewCell
		
		tablecell.avatarImageView.layer.cornerRadius = tablecell.avatarImageView.frame.size.width/2
		tablecell.avatarImageView.clipsToBounds = true
		
		let singleUser = allFavoriteUsers[indexPath.row]
		tablecell.singleUser = singleUser
		tablecell.loginLabel.text = singleUser.login
		tablecell.githubPageURLLabel.text = singleUser.html_url
		tablecell.accountTypeLabel.text = singleUser.type
		
		if singleUser.site_admin {
			tablecell.siteAdminLabel.isHidden = false
		}
		if singleUser.isFavorite{
			tablecell.favoriteButton.isSelected = true
			
		}
		
		tablecell.avatarImageView.sd_setImage(with: URL(string:singleUser.avatar_url), placeholderImage: UIImage(named: "PlaceholderImage"))
		
		tablecell.delegate = self
		return tablecell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 111.5
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let singleUser = allFavoriteUsers[indexPath.row]
		
		self.performSegue(withIdentifier: "ShowUserDetails", sender: singleUser)
	}
	
}
extension FavoriteUsersViewController: UserTableViewCellDelegate {
	func customCell(_ cell: UITableViewCell, didPressButton: UIButton) {
		// Get the indexPath
		let indexPath = self.allFavoriteUsersTableView.indexPath(for: cell)
		let singleUser = allFavoriteUsers[indexPath!.row]
		if (!singleUser.isFavorite){
			//add to favorite list and update ui
			singleUser.isFavorite = true
			Users.setFavoriteUsers(user: singleUser)
			didPressButton.isSelected = true
			
		}
		else{
			//remove from favorite list and update ui
			singleUser.isFavorite = false
			Users.setFavoriteUsers(user: singleUser)
			didPressButton.isSelected = false
			self.allFavoriteUsers = Users.getAllFavoriteUsers()
			allFavoriteUsersTableView.reloadData()
			
		}
	}
}
