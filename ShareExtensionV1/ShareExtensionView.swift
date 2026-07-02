//
//  ShareExtensionView.swift
//  ShareExtensionV1
//
//  Created by Cole Patterson on 6/28/26.
//

import SwiftUI
import MapKit

struct ShareExtensionView: View {
    
    let extensionManager: ExtensionManager
    let handleClose: () -> Void
    
    var body: some View {
        if (extensionManager.loadingMapItem == true) {
            HStack {
                ProgressView()
                Text("loading...")
            }
        } else if (extensionManager.loadingMapItem == false && extensionManager.mapItem != nil){
            VStack {
                VStack(alignment: .leading) {
                    Text(extensionManager.mapItem!.name ?? "unknown place")
                        .font(.title)
                        .fontWeight(.bold)
                    Text(extensionManager.mapItem!.address?.fullAddress ?? "unknown address")
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                VStack {
                    Button {
                        print("save")
                        handleClose()
                    } label: {
                        Text("save place")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.glassProminent)
                    .controlSize(.large)
                }
            }
            .padding()
        }
    }
}
