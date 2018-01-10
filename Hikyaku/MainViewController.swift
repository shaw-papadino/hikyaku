//
//  MainViewController.swift
//  Hikyaku
//
//  Created by 岡山将也 on 2017/12/26.
//  Copyright © 2017年 shouya.okayama. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import Firebase
import FirebaseDatabase
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {

    @IBAction func friendButton(_ sender: Any) {
        
        //ユーザーid使ってデータを取得する
        
        //データをWriteに渡す
        
        let nextView = storyboard?.instantiateViewController(withIdentifier: "Write")
        present(nextView!, animated: true, completion: nil)
    }
    @IBOutlet weak var hikyaku: UIImageView!
    
//    @IBAction func leftButton(_ sender: Any) {
//        openLeft()
//    }
    
    var userArray: [userData] = []
    var locationManager: CLLocationManager!
    var latitudo: Double!
    var longitude: Double!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userID = Auth.auth().currentUser!.uid
        self.hikyaku.layer.cornerRadius = 100
        let ref = Database.database().reference().child(Const.Users).child(userID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print("DEBUG_PRINT: .childAddedイベントが発生しました。")
            
            if let uid = Auth.auth().currentUser?.uid {
                let UserData2 = userData(snapshot: snapshot, myId: uid)
                self.userArray.insert(UserData2, at: 0)
                
                if snapshot.hasChild("ido"){
                    print("要素あり")
                }else{
                    print("要素なし")
                }
                print(snapshot)
                let name: String! = UserData2.name
                let keido: Double! = UserData2.keido
                self.hikyaku.image = UserData2.image
                print(self.userArray)
            }
        })
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setuserData(UserData: userData) {
        self.hikyaku.image = UserData.image
        
        
    }
//    override func viewWillAppear(_ animated: Bool) {
//        setupLocationManager()
//    }
    func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        latitudo = location?.coordinate.latitude
        
        longitude = location?.coordinate.longitude
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報の取得に失敗しました")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
