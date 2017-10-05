//
//  AllUsersViewController.swift
//  GitHubUsersList
//
//  Created by Hendrik Kusuma on 10/5/17.
//  Copyright © 2017 Kusumas. All rights reserved.
//

import UIKit
import Moya
import SDWebImage
import PKHUD
import ReachabilitySwift

class AllUsersViewController: UIViewController {
	
	var allUsers : [Users] = []
	@IBOutlet var allUsersTableView : UITableView!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.allUsers = Users.getDownloadedUsers()
		allUsersTableView.reloadData()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupReachability()
		
		// Do any additional setup after loading the view, typically from a nib.
		if(self.allUsers.count <= 0){
			getUsers()
		}
		else{
			let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
			spinner.startAnimating()
			spinner.frame = CGRect(x: 0, y: 0, width: self.allUsersTableView.frame.width, height: 44)
			self.allUsersTableView.tableFooterView = spinner;
			
		}
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func getUsers(){
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		HUD.show(.progress)
		let provider = MoyaProvider<UserService>()
		provider.request(.getUsers()) { (result) in
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
			switch result {
			case .success(let response):
				HUD.hide()
				if(response.statusCode == 200){
					let responseString = String(data: response.data, encoding: String.Encoding.utf8) as String!
					let userArray = [Users](json:responseString)
					Users.saveDownloadedUsers(newData: userArray)
					self.allUsers = Users.getDownloadedUsers()
					self.allUsersTableView.reloadData()
				}
				else{
					
					
				}
			case .failure(let error): HUD.hide()
				break
				// show error
			}
		}
		
	}
	func getUsersSince(since : String){
		let provider = MoyaProvider<UserService>()
		provider.request(.getUsersSince(since: since)) { (result) in
			print(result)
			switch result {
			case .success(let response):
				if(response.statusCode == 200){
					let responseString = String(data: response.data, encoding: String.Encoding.utf8) as String!
					let userArray = [Users](json:responseString)
					Users.saveDownloadedUsers(newData: userArray)
					self.allUsers = Users.getDownloadedUsers()
					self.allUsersTableView.reloadData()
				}
			case .failure(let error): break
				// show error
			}
		}
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "ShowUserDetails"){
			let selectedUser = sender as! Users
			let nextVC = segue.destination as! UserGitHubDetailsViewController
			nextVC.selectedUser = selectedUser
		}
	}
	func setupReachability() {
		let reachable = try! DefaultReachabilityService.init()
		let user : Users = Users()
		reachable.reachability.subscribe { event in
			switch (event) {
			case let .next(status):
				print("network is \(status)")
				if !reachable._reachability.isReachable {
					HUD.hide()
					let alertController = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString(reachable._reachability.currentReachabilityStatus.description, comment: ""), preferredStyle: UIAlertControllerStyle.alert)
					let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
					alertController.addAction(action)
					if !(self.navigationController!.visibleViewController!.isKind(of: UIAlertController.self)) {
						OperationQueue.main.addOperation {
							self.navigationController?.present(alertController, animated: true, completion: nil)
						}
					}
				}
			default:
				break
			}
			}.addDisposableTo(user.disposeBag)
		
		
		
	}

}

extension AllUsersViewController : UITableViewDelegate,UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.allUsers.count;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let tablecell = tableView.dequeueReusableCell(withIdentifier: "UserTableCell", for: indexPath) as! UserTableViewCell
		
		tablecell.avatarImageView.layer.cornerRadius = tablecell.avatarImageView.frame.size.width/2
		tablecell.avatarImageView.clipsToBounds = true
		
		let singleUser = allUsers[indexPath.row]
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
		else{
			tablecell.favoriteButton.isSelected = false
			
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
		let singleUser = allUsers[indexPath.row]
		
		self.performSegue(withIdentifier: "ShowUserDetails", sender: singleUser)
	}
	func tableView(_ tableView: UITableView,
	               willDisplay cell: UITableViewCell,
	               forRowAt indexPath: IndexPath)
	{
		// At the bottom...
		if (indexPath.row == self.allUsers.count - 1) {
			let lastUserID = allUsers[allUsers.count-1]
			self.getUsersSince(since: String(lastUserID.id))
		}
	}
}
extension AllUsersViewController: UserTableViewCellDelegate {
	func customCell(_ cell: UITableViewCell, didPressButton: UIButton) {
		// Get the indexPath
		let indexPath = self.allUsersTableView.indexPath(for: cell)
		let singleUser = allUsers[indexPath!.row]
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
			
			
		}
	}
}
