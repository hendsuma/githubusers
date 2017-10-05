//
//  UserService.swift
//  GitHubUsersList
//
//  Created by Hendrik Kusuma on 10/5/17.
//  Copyright © 2017 Kusumas. All rights reserved.
//

import Foundation
import Moya

enum UserService {
	case getUsers()
	case getUsersSince(since:String)
	
}

// MARK: - TargetType Protocol Implementation
extension UserService : TargetType {
	var task: Task {
		return .requestData(self.sampleData)
	}
	
	var headers: [String : String]? {
		return nil
	}
	
	
	var baseURL: URL { return URL(string: "https://api.github.com/")! }
	
	var path: String {
		switch self {
		case .getUsers():
			return "users"
		case .getUsersSince(let since):
			return "users?since=\(since)"
		}
	}
	var method: Moya.Method {
		return .get
		
	}
	var parameters: [String: Any]? {
		switch self {
			case .getUsersSince(let since):
				return ["since":since]
		default:
			return nil
		}
	}
	var sampleData: Data { return Data() }
	
	var parameterEncoding : ParameterEncoding{
		return URLEncoding.queryString
	}
}
