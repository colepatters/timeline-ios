//
//  PreviewHelper.swift
//  timeline
//
//  Created by Cole Patterson on 8/1/26.
//

import Foundation
import SwiftUI
import SwiftData

struct SampleAppContext: PreviewModifier {
    
    static func makeSharedContext() async throws -> AppContext {
        let appContext = AppContext()
        
        if (appContext == nil) {
            fatalError("failed to create sample app context")
        }
        
        try clearModelData(modelContext: appContext!.modelContainer.mainContext)
        insertSampleData(modelContext: appContext!.modelContainer.mainContext)
        
        return appContext!
    }
    
    
    
    func body(content: Content, context: AppContext) -> some View {
        content
            .modelContainer(context.modelContainer)
            .environment(context)
    }
    
}
