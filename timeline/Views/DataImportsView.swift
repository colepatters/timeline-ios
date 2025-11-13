//
//  DataImportsView.swift
//  timeline
//
//  Created by Cole Patterson on 11/13/25.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

private func handleImportAll(clearExisting: Bool) {
    
}

private func handleFileLoadCompletion(_ result: Result<URL, any Error>) -> Void {
    switch result {
        case .success(let url):
        print(url)
        
        do {
            let handle = try FileHandle(forReadingFrom: url)
        }
        catch {
            print(error.localizedDescription)
        }
            
        case.failure(let error):
            print(error.localizedDescription)
    }
}

struct DataImportsView: View {
    
    @State var destroyBeforeImportAll: Bool = true
    @State var showFileImporter: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Import all") {
                    Toggle("Destroy all before import", isOn: $destroyBeforeImportAll)
                    Button {
                        showFileImporter = true
                    } label: {
                        Text("Import all")
                    }
                }
            }
            .navigationTitle("Data Imports")
            .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [UTType.json], onCompletion: handleFileLoadCompletion)
        }
    }
}

#Preview {
    DataImportsView()
}
