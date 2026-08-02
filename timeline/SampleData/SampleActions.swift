//
//  SampleData+Actions.swift
//  timeline
//
//  Created by Cole Patterson on 10/4/25.
//

import Foundation
import SwiftData

func insertSampleData(modelContext: ModelContext) {
    for entry in sampleLocationSnapshots {
        modelContext.insert(entry)
    }
    for entry in samplePlaces {
        modelContext.insert(entry)
    }
    for entry in sampleVisits {
        modelContext.insert(entry)
    }
    
    modelContext.insert(Event(name: "Move"))
    modelContext.insert(Event(name: "Breakup"))
    
    
    let dateFormatter = ISO8601DateFormatter()
    
//    location / CLvisits
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "7CA9F7A5-8344-43A0-9D7B-44B98D0E09F1"), lat: 44.72751214667472,
            lon: -93.41049659108229, arrivalDate: dateFormatter.date(from: "2026-07-18T23:06:12Z")!,
            departureDate: dateFormatter.date(from: "2026-07-19T06:13:39Z")!,
            createdAt: dateFormatter.date(from: "2026-07-19T06:15:08Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "594B0569-0AF4-41BD-B9C5-5450BBE7EBBD"), lat: 44.71036850576193,
            lon: -93.43438821463508, arrivalDate: dateFormatter.date(from: "2026-07-19T06:18:46Z")!,
            departureDate: dateFormatter.date(from: "2026-07-19T18:36:02Z")!,
            createdAt: dateFormatter.date(from: "2026-07-19T18:36:24Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "C4B0C066-A037-49C0-A2F3-BB9F6372C50B"), lat: 44.71039407474634,
            lon: -93.43452854871693, arrivalDate: dateFormatter.date(from: "2026-07-19T18:44:12Z")!,
            departureDate: dateFormatter.date(from: "2026-07-19T20:00:42Z")!,
            createdAt: dateFormatter.date(from: "2026-07-19T20:01:06Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "E7FC62FE-8933-44D1-B420-76F2F7BD984F"), lat: 44.727567854760046,
            lon: -93.41066131358916, arrivalDate: dateFormatter.date(from: "2026-07-19T20:05:31Z")!,
            departureDate: dateFormatter.date(from: "4001-01-01T00:00:00Z")!,
            createdAt: dateFormatter.date(from: "2026-07-19T20:06:32Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "24C66D0D-254A-40C6-828A-4B1B93355AA5"), lat: 44.727567854760046,
            lon: -93.41066131358916, arrivalDate: dateFormatter.date(from: "2026-07-19T20:05:31Z")!,
            departureDate: dateFormatter.date(from: "4001-01-01T00:00:00Z")!,
            createdAt: dateFormatter.date(from: "2026-07-19T20:06:32Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "D2584E5C-3AE9-494F-BE21-E07BC2335375"), lat: 44.745864710234514,
            lon: -93.29285014545447, arrivalDate: dateFormatter.date(from: "2026-07-19T22:52:48Z")!,
            departureDate: dateFormatter.date(from: "4001-01-01T00:00:00Z")!,
            createdAt: dateFormatter.date(from: "2026-07-19T22:57:19Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "EB3BC5CB-23A1-43E4-9807-67F0860732BD"), lat: 44.7458352646317,
            lon: -93.29278388715043, arrivalDate: dateFormatter.date(from: "2026-07-19T22:52:48Z")!,
            departureDate: dateFormatter.date(from: "2026-07-20T00:36:34Z")!,
            createdAt: dateFormatter.date(from: "2026-07-20T00:37:18Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "918B1C05-88EA-4ACB-B144-8B9F299191C9"), lat: 44.69581391734419,
            lon: -93.44763516587672, arrivalDate: dateFormatter.date(from: "2026-07-20T00:51:29Z")!,
            departureDate: dateFormatter.date(from: "2026-07-20T01:07:14Z")!,
            createdAt: dateFormatter.date(from: "2026-07-20T01:08:11Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "7BF7BD58-1AC0-4487-8B26-4DA544E8981B"), lat: 44.727551434465575,
            lon: -93.4107024110935, arrivalDate: dateFormatter.date(from: "2026-07-20T01:17:17Z")!,
            departureDate: dateFormatter.date(from: "4001-01-01T00:00:00Z")!,
            createdAt: dateFormatter.date(from: "2026-07-20T01:18:04Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "B477FBA8-9159-44C6-9801-FBB8EA8A2B97"), lat: 44.72747224876478,
            lon: -93.41046926720894, arrivalDate: dateFormatter.date(from: "2026-07-20T01:17:17Z")!,
            departureDate: dateFormatter.date(from: "2026-07-20T05:04:07Z")!,
            createdAt: dateFormatter.date(from: "2026-07-20T05:05:04Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "C3A51CC7-606B-44BD-B0E4-420A83F5678A"), lat: 44.710450319965716,
            lon: -93.4344915740219, arrivalDate: dateFormatter.date(from: "2026-07-20T05:09:13Z")!,
            departureDate: dateFormatter.date(from: "4001-01-01T00:00:00Z")!,
            createdAt: dateFormatter.date(from: "2026-07-20T05:11:57Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "5E7C39D2-F528-4FA0-8957-365577984ADA"), lat: 44.71037114407371,
            lon: -93.4343887319214, arrivalDate: dateFormatter.date(from: "2026-07-20T05:09:13Z")!,
            departureDate: dateFormatter.date(from: "2026-07-20T21:14:38Z")!,
            createdAt: dateFormatter.date(from: "2026-07-20T21:15:05Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "058659AA-D7B4-460F-B343-9EBA5618DEE9"), lat: 44.727559232283724,
            lon: -93.41069614309458, arrivalDate: dateFormatter.date(from: "2026-07-20T21:25:00Z")!,
            departureDate: dateFormatter.date(from: "4001-01-01T00:00:00Z")!,
            createdAt: dateFormatter.date(from: "2026-07-20T21:28:11Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "4A7CAF3B-44B1-455A-9921-D8B40B3F9727"), lat: 44.727526028223814,
            lon: -93.41055047247076, arrivalDate: dateFormatter.date(from: "2026-07-20T21:25:00Z")!,
            departureDate: dateFormatter.date(from: "2026-07-21T00:34:17Z")!,
            createdAt: dateFormatter.date(from: "2026-07-21T00:35:04Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "49F33504-0B3F-432D-830B-442EBAF718D8"), lat: 44.72747021620179,
            lon: -93.41050706227546, arrivalDate: dateFormatter.date(from: "2026-07-21T00:42:52Z")!,
            departureDate: dateFormatter.date(from: "2026-07-21T05:35:58Z")!,
            createdAt: dateFormatter.date(from: "2026-07-21T05:36:53Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "C395A546-E429-41C1-9B2B-ECC6F029F0F8"), lat: 44.79449092670244,
            lon: -93.53374191465699, arrivalDate: dateFormatter.date(from: "2026-07-21T13:07:29Z")!,
            departureDate: dateFormatter.date(from: "4001-01-01T00:00:00Z")!,
            createdAt: dateFormatter.date(from: "2026-07-21T13:08:27Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "E8C3FB90-F114-476F-BD54-75F05EC995BA"), lat: 44.795212519697586,
            lon: -93.52739191502488, arrivalDate: dateFormatter.date(from: "2026-07-21T13:08:16Z")!,
            departureDate: dateFormatter.date(from: "4001-01-01T00:00:00Z")!,
            createdAt: dateFormatter.date(from: "2026-07-21T13:12:46Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "E483C26A-A9F4-41D1-B3CB-A93DF2B06684"), lat: 44.710360157997826,
            lon: -93.43442975681432, arrivalDate: dateFormatter.date(from: "2026-07-21T15:09:57Z")!,
            departureDate: dateFormatter.date(from: "2026-07-21T21:16:24Z")!,
            createdAt: dateFormatter.date(from: "2026-07-21T21:16:52Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "3340D028-37E8-48D6-AC98-9F12AA746C2E"), lat: 44.69567711677788,
            lon: -93.44763562123912, arrivalDate: dateFormatter.date(from: "2026-07-21T21:19:38Z")!,
            departureDate: dateFormatter.date(from: "4001-01-01T00:00:00Z")!,
            createdAt: dateFormatter.date(from: "2026-07-21T21:24:08Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "B4761263-CE41-4DBF-8718-452137FC49FD"), lat: 44.69583017854293,
            lon: -93.44773513827026, arrivalDate: dateFormatter.date(from: "2026-07-21T21:19:38Z")!,
            departureDate: dateFormatter.date(from: "2026-07-21T21:42:58Z")!,
            createdAt: dateFormatter.date(from: "2026-07-21T21:43:41Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "D13AE375-A63A-4B73-A6A4-DED42B62E153"), lat: 44.74897281077106,
            lon: -93.38076292369388, arrivalDate: dateFormatter.date(from: "2026-07-21T21:52:04Z")!,
            departureDate: dateFormatter.date(from: "4001-01-01T00:00:00Z")!,
            createdAt: dateFormatter.date(from: "2026-07-21T21:56:35Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "E2A295D9-2675-4875-91AB-E6C0B2B749F6"), lat: 44.7489758122501,
            lon: -93.38067914982356, arrivalDate: dateFormatter.date(from: "2026-07-21T21:52:04Z")!,
            departureDate: dateFormatter.date(from: "2026-07-21T22:03:29Z")!,
            createdAt: dateFormatter.date(from: "2026-07-22T06:08:17Z")!))
    modelContext.insert(
        LocationVisit(
            id: UUID(uuidString: "6D43B49C-06C7-4DDB-8C64-96EBD33E8AC5"), lat: 44.71035946282377,
            lon: -93.43437226295018, arrivalDate: dateFormatter.date(from: "2026-07-22T06:08:00Z")!,
            departureDate: dateFormatter.date(from: "4001-01-01T00:00:00Z")!,
            createdAt: dateFormatter.date(from: "2026-07-22T06:13:05Z")!))

    
    modelContext.insert(
        LogEntry(body: "sample data inserted into model context successfully")
    )
    
    modelContext.insert(
        QuickVisit(
            arrival: Date.now - TimeInterval(integerLiteral: 10),
            departure: Date.now,
            source: .app,
            lat: 37.33473020,
            lon: -122.00891890
        )
    )
    
    modelContext.insert(
        QuickVisit(
            arrival: Date.now - TimeInterval(integerLiteral: 30),
            source: .app,
            lat: 37.33473020,
            lon: -122.00891890
        )
    )
}
