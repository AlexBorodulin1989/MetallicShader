//
//  Project.swift
//  MetallicShader
//
//  Created by Aleks on 25.03.2021.
//

import Foundation

import RealmSwift

@objcMembers class Project: Object, Decodable {
    dynamic var _id: String = ""
    dynamic var name: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        _id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        super.init()
    }
    
    override static func primaryKey() -> String?
    {
        return "_id"
    }
    
    required override init()
    {
        super.init()
    }
}
