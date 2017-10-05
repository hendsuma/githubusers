//
//  Users.swift
//  GitHubUsersList
//
//  Created by Hendrik Kusuma on 10/5/17.
//  Copyright © 2017 Kusumas. All rights reserved.
//

import UIKit
import EVReflection
import SwiftyUserDefaults

class Users : EVObject{
	var login 		: String = ""
	var id			: Int 	 = 0
	var avatar_url	: String = ""
	var html_url	: String = ""
	var type 		: String = ""
	var site_admin	: Bool   = false
	var isFavorite	: Bool	 = false
	
	static func getDownloadedUsers() -> [Users]{
		let result : [Users] = [Users](json: Defaults[.downloadedUsers])
		
		
		
		return result
		
	}
	
	static func saveDownloadedUsers (newData:[Users]){
		var allDownloadedUsers = [Users](json: Defaults[.downloadedUsers])
		
		allDownloadedUsers.append(contentsOf:newData)
		
		Defaults[.downloadedUsers] = allDownloadedUsers.toJsonString()
	}
	
	static func setFavoriteUsers(user:Users){
		var allDownloadedUsers = [Users](json: Defaults[.downloadedUsers])
		
		let userIndex = allDownloadedUsers.index(where: {$0.id == user.id})

		allDownloadedUsers[userIndex!] = user
		
		Defaults[.downloadedUsers] = allDownloadedUsers.toJsonString()
		
	}
	
	static func getAllFavoriteUsers() -> [Users]{
		let tempResult : [Users] = [Users](json: Defaults[.downloadedUsers])
		
		let result = tempResult.filter(){$0.isFavorite == true}
		
		return result
		
	}
	
}
extension DefaultsKeys {
	static let downloadedUsers = DefaultsKey<String?>("downloadedUsers")
	static let lastDownloadedID = DefaultsKey<Int?>("lastDownloadedID")
}
