//
//  PreviewHelper.swift
//  timeline
//
//  Created by Cole Patterson on 8/1/26.
//

import Foundation
import SwiftUI

struct SampleAppContext: PreviewModifier {
    
    static func makeSharedContext() async throws -> AppContext {
        let appContext = AppContext()
        
        if (appContext == nil) {
            fatalError("failed to create sample app context")
        }
        
        return appContext!
    }
    
    func body(content: Content, context: AppContext) -> some View {
        content
            .environment(context)
    }
    
}
