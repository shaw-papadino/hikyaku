//
//  WriteLetterViewController.swift
//  Hikyaku
//
//  Created by 岡山将也 on 2017/12/27.
//  Copyright © 2017年 shouya.okayama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class WriteLetterViewController: UIViewController, UITextViewDelegate {
    
    var ido: Double!
    var keido: Double!
    var sendname: String!
    

    @IBOutlet weak var honbunText: UITextView!
    @IBOutlet weak var atenaLabel: UILabel!
    @IBAction func sendButton(_ sender: Any) {
        
        //let senduser =
        let honbun = self.honbunText.text
        let time = NSDate.timeIntervalSinceReferenceDate
        let userID = Auth.auth().currentUser!.uid
        
//        if honbun != nil ||  senduser != nil {
//            let userRef = Database.database().reference().child(Const.Letters).child(userID)
//            let userData = ["Honbun": honbun,"arrivalTime": ,"senduser": ]
//            userRef.setValue(userData)
//        }
        let nextView = storyboard?.instantiateViewController(withIdentifier: "Success")
        present(nextView!, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        atenaLabel.text = sendname
        
        honbunText.delegate = self
        
        honbunText.text = "本文を入力してな"
        honbunText.textColor = UIColor.lightGray
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if honbunText.textColor == UIColor.lightGray {
            honbunText.text = nil
            honbunText.textColor = UIColor.black
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if honbunText.text.isEmpty {
            honbunText.text = "本文を入力してな"
            honbunText.textColor = UIColor.lightGray
        }
    }
    func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
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
