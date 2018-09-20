//
//  UserMap.swift
//  Bublit
//
//  Created by Jake Smith on 04/01/2018.
//  Copyright © 2018 Nebultek. All rights reserved.
//

import Foundation
import Firebase
import GoogleMaps

class UserMap: NSObject, CLLocationManagerDelegate {
   
    weak var delegate: UserMapDelegate?
    let locationManager = CLLocationManager()
    let database = Database.database().reference()
    let sc = MapData.userBubbleScale
    var visibleUsers = [String: CLLocationCoordinate2D]()
    var usersOnMap = [String:GMSMarker]()
    var mapView = GMSMapView()
    var deviceMarker = GMSMarker()
    
    init(map: GMSMapView? = nil) {
        mapView = map ?? GMSMapView()
        
    }
    
    func startTracking() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    var gotInitial = false
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        if gotInitial == false {
            deviceMarker.position = locValue
            let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 6.0)
            mapView.animate(to: camera)
            gotInitial = true
        }
        deviceMarker.position = locValue
        let database = Database.database().reference()
        let postData: [String:AnyObject] = ["lat":manager.location!.coordinate.latitude as AnyObject,"long" :manager.location!.coordinate.longitude as AnyObject]
        database.child("Users").child(UserDetails.UID).updateChildValues(postData)
    }
    
    func fetchNearby() {
        database.child("Users").observe(.value, with: {
            snapshot in
            let snapshotChildren = snapshot.children.allObjects
            for child in snapshotChildren {
                let childSnapshot = child as! DataSnapshot
                let childData = childSnapshot.value as? [String:AnyObject]
                //print(childSnapshot)
                if let lat = childData?["lat"] as? Double {
                    if let long = childData?["long"] as? Double {
                        self.visibleUsers[childSnapshot.key] = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    }
                }
            }
            self.visibleUsers.removeValue(forKey: UserDetails.UID)
            self.updateUserLocations()
        })
    }
    
    func addDeviceMarker() {
        deviceMarker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        let imframe = CGRect(x: 0, y: 0, width: 45, height: 45)
        let imview = UIImageView(frame: imframe)
        imview.contentMode = .scaleAspectFill
        //imview.layer.cornerRadius = 23
        //imview.layer.borderWidth = 2.0
        //imview.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        imview.clipsToBounds = false
        imview.image = #imageLiteral(resourceName: "19598443_1341517582611572_6872384681347386621_n").circleMasked
        deviceMarker.iconView = imview
        deviceMarker.layer.frame.size = CGSize(width: 50, height: 50)
        deviceMarker.title = "Me"
        deviceMarker.map = mapView
        deviceMarker.iconView?.clipsToBounds = false
        deviceMarker.layer.masksToBounds = false
        mapView.selectedMarker = deviceMarker
    }
    
    var prevCameraZoom: Float = 0
    func scaleUserIcons() {
        if (mapView.camera.zoom != prevCameraZoom) {
            deviceMarker.iconView?.frame = CGRect(x: 0, y: 0, width: 45*CGFloat(mapView.camera.zoom*sc), height: 45*CGFloat(mapView.camera.zoom*sc))
            for child in usersOnMap {
                let userMarker = child.value
                userMarker.iconView?.frame = CGRect(x: 0, y: 0, width: 45*CGFloat(mapView.camera.zoom*sc), height: 45*CGFloat(mapView.camera.zoom*sc))
            }
            prevCameraZoom = mapView.camera.zoom
        }
    }
    
    func updateUserLocations() {
        for child in visibleUsers {
            if (usersOnMap[child.key] != nil) {
                usersOnMap[child.key]?.position = child.value as CLLocationCoordinate2D
            } else {
                usersOnMap[child.key] = GMSMarker()
                usersOnMap[child.key]?.title = child.key
                let imframe = CGRect(x: 0, y: 0, width: 45, height: 45)
                let imview = UIImageView(frame: imframe)
                imview.contentMode = .scaleAspectFill
                imview.clipsToBounds = false
                imview.image = #imageLiteral(resourceName: "woman").circleMasked
                usersOnMap[child.key]?.iconView = imview
                usersOnMap[child.key]?.layer.frame.size = CGSize(width: 50, height: 50)
                usersOnMap[child.key]?.position = child.value as CLLocationCoordinate2D
                usersOnMap[child.key]?.map = mapView
                usersOnMap[child.key]?.iconView?.frame = CGRect(x: 0, y: 0, width: 45*CGFloat(mapView.camera.zoom*sc), height: 45*CGFloat(mapView.camera.zoom*sc))
            }
        }
    }
    
}

protocol UserMapDelegate: class {
    //func updateUserLocations()
}
