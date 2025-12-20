//
//  AppSchemaMigrations.swift
//  timeline
//
//  Created by Cole Patterson on 12/19/25.
//

import Foundation
import SwiftData

struct AppSchemaMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] = [
        AppSchemaV1.self
    ]
    
    static var stages: [MigrationStage] = [
        
    ]
    
//    static let migrateV1toV2 = MigrationStage.custom(
//        fromVersion: AppSchemaV1
//    )
}
