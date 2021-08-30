//
//  MapView.swift
//  PotLuck
//
//  Created by Sierra Seabrease on 4/1/21.
//
import Foundation
import SwiftUI
import CoreLocation
import MapKit
import FirebaseFirestore
import FirebaseStorage

enum Locations: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case ElktonHall = "Elkton Hall"
    case AnnapolisHall = "Annapolis Hall"
    case Varsity = "Varsity Apartments"
    case Stamp = "Adele H. Stamp Student Union"
    case Commons7 = "South Campus Commons 7"
    case Courtyards200 = "The Courtyards 200"
    
    
    static private let _ElktonHall = CLLocationCoordinate2D(latitude: 38.9924827,longitude: -76.9490289)
    static private let _AnnapolisHall = CLLocationCoordinate2D(latitude:38.9823,longitude: -76.9401)
    static private let _Varsity = CLLocationCoordinate2D(latitude: 38.991530900690606,longitude: -76.93414886274806)
    static private let _Stamp = CLLocationCoordinate2D(latitude: 38.988360143144014,longitude: -76.94406698758150)
    static private let _Commons7 = CLLocationCoordinate2D(latitude: 38.9816048454883,longitude: -76.94463338692935)
    static private let _Courtyards200 = CLLocationCoordinate2D(latitude: 39.0019267,longitude: -76.9425926)
    
    
    
    func location() -> CLLocationCoordinate2D {
        switch self {
        case .ElktonHall: return Self._ElktonHall
        case .AnnapolisHall: return Self._AnnapolisHall
        case .Varsity: return Self._Varsity
        case .Stamp: return Self._Stamp
        case .Commons7: return Self._Commons7
        case .Courtyards200: return Self._Courtyards200
        }
        
    }
    
}

struct Coordinate: Identifiable {
    let id = UUID()
    var position: CLLocationCoordinate2D
}

struct MapView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var locationManager: LocationManager
    
    private var db = Firestore.firestore()
    
    @State var coords: [Coordinate] = []
    
    @State var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 38.99,longitude: -76.94),
        span: MKCoordinateSpan(latitudeDelta: 0.02,longitudeDelta: 0.02)
    )
    
    func loadMarkers() {
        let coord = locationManager.location?.coordinate
        if let coord = coord {
            coordinateRegion.center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
        }
        db.collection("users").getDocuments() { (users, err) in
            if let err = err {
                print("Error getting user documents: \(err)")
            } else {
                for document in users!.documents {
                    db.collection("users").document(document.documentID).collection("dishes").getDocuments() { (dishes, err) in
                        if let err = err {
                            print("Error getting dishes documents: \(err)")
                        } else {
                            var placeholder: [Coordinate] = []
                            for dish in dishes!.documents {
                                do {
                                    let result = try dish.data(as: Dish.self)
                                    placeholder.append(Coordinate(position: CLLocationCoordinate2D(latitude: CLLocationDegrees(result!.lat), longitude: CLLocationDegrees(result!.long))))
                                } catch {
                                    print("parse dish failed")
                                }
                            }
                            coords = placeholder
                        }
                    }
                }
            }
        }
    }
        
        var body: some View {
            return VStack {
                Map(coordinateRegion: $coordinateRegion,
                    interactionModes: .all,
                    showsUserLocation: true,
                    annotationItems: coords) { coord in
                        MapMarker(coordinate: coord.position, tint: .red)
                }
            }.onAppear(perform: loadMarkers)
        }
    }
