//
//  UserGitHubDetailsViewController.swift
//  GitHubUsersList
//
//  Created by Hendrik Kusuma on 10/5/17.
//  Copyright © 2017 Kusumas. All rights reserved.
//

import UIKit
import PKHUD

class UserGitHubDetailsViewController: UIViewController {
	
	@IBOutlet var userGithubWebView : UIWebView!
	var selectedUser : Users!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = selectedUser.login
		userGithubWebView.loadRequest(URLRequest.init(url: URL(string:selectedUser.html_url)!))
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}
extension UserGitHubDetailsViewController : UIWebViewDelegate{
	
	func webViewDidStartLoad(_ webView: UIWebView) {
		//show loading
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		HUD.show(.progress)
		
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView) {
		//hide loading
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
		HUD.hide()
	}
	
}

