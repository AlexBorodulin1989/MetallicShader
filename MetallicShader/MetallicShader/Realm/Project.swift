//
//  Project.swift
//  MetallicShader
//
//  Created by Aleks on 25.03.2021.
//

import Foundation

import RealmSwift

@objcMembers class Project: Object, Codable {
    dynamic var id: String = ""
    dynamic var name: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        super.init()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
    
    override static func primaryKey() -> String?
    {
        return "id"
    }
    
    required override init()
    {
        super.init()
    }
    
    init(name: String) {
        super.init()
        self.id = UUID().uuidString
        self.name = name
    }
}
