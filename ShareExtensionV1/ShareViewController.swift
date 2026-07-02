//
//  ShareViewController.swift
//  ShareExtensionV1
//
//  Created by Cole Patterson on 6/28/26.
//
//  huge thanks to this medium article for help on this obtuse ass code
// https://medium.com/@henribredtprivat/create-an-ios-share-extension-with-custom-ui-in-swift-and-swiftui-2023-6cf069dc1209


import UIKit
import Social
import UniformTypeIdentifiers
import MapKit
import SwiftUI
import SwiftData

@Observable
class ExtensionManager {
    var loadingMapItem: Bool = true
    var mapItem: MKMapItem? = nil
    
    func loadMapItem(_ itemProvider: NSItemProvider) async {
        if (itemProvider.hasItemConformingToTypeIdentifier("com.apple.mapkit.map-item")) {
            do {
                let item = try await itemProvider.loadItem(forTypeIdentifier: "com.apple.mapkit.map-item")
                guard let data = item as? Data else { return }
                do {
                    // 3.
                    guard let mapItem = try NSKeyedUnarchiver.unarchivedObject(ofClass: MKMapItem.self, from: data as Data) else { return }
                    // 4.
                    self.mapItem = mapItem
                    print("successfully got map item")
                    print(mapItem)
                } catch {
                    print("Error unarchiving mapItems. \(error)")
                }
            }
            catch {
                print("Error loading map item: \(error)")
            }
        }
        
        loadingMapItem = false
    }
}

class ShareViewController: SLComposeServiceViewController {
    
    let manager: ExtensionManager = ExtensionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard
            let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = extensionItem.attachments?.first else {
            close()
            return
        }
        
        if let mapKitItem = extensionItem.attachments?.first(where: { $0.hasItemConformingToTypeIdentifier("com.apple.mapkit.map-item")
        }) {
            Task {
                await manager.loadMapItem(itemProvider)
            }
            
            DispatchQueue.main.async {
                let contentView = UIHostingController(rootView: ShareExtensionView(extensionManager: self.manager, handleClose: self.close))
                self.addChild(contentView)
                self.view.addSubview(contentView.view)
                
                // set up constraints
                contentView.view.translatesAutoresizingMaskIntoConstraints = false
                contentView.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                contentView.view.bottomAnchor.constraint (equalTo: self.view.bottomAnchor).isActive = true
                contentView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                contentView.view.rightAnchor.constraint (equalTo: self.view.rightAnchor).isActive = true
            }
        }
    }
    
    /// Close the Share Extension
    func close() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
