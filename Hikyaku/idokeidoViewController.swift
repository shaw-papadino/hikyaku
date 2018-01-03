//
//  idokeidoViewController.swift
//  Hikyaku
//
//  Created by 岡山将也 on 2018/01/02.
//  Copyright © 2018年 shouya.okayama. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseAuth

class idokeidoViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var latitudo: Double!
    var longitude: Double!

    @IBOutlet weak var idoTextView: UILabel!
    @IBOutlet weak var keidoTextView: UILabel!
    @IBAction func idokeidoButton(_ sender: Any) {
        
        //緯度経度取得
        locationManager.requestLocation()
        //それをテキストビューに表示する
        idoTextView.text = String(latitudo)
        keidoTextView.text = String(longitude)
        
        
    }
    @IBAction func finishButton(_ sender: Any) {
        
        if let ido = idoTextView.text , let keido = keidoTextView.text {
            if ido.characters.isEmpty || keido.characters.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                return
            }
            else {
                //緯度と経度を保存する
                let userID = Auth.auth().currentUser!.uid
                let userRef = Database.database().reference().child(Const.Users).child(userID)
                let idokeidoData = ["ido": latitudo, "keido": longitude]
                userRef.updateChildValues(idokeidoData)
                
                let nextView = storyboard?.instantiateViewController(withIdentifier: "Slide")
                present(nextView!, animated: true, completion: nil)

            }
        }
        


    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        
        // Do any additional setup after loading the view.
    }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
