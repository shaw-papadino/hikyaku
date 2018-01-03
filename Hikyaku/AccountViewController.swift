//
//  AccountViewController.swift
//  Hikyaku
//
//  Created by 岡山将也 on 2017/12/30.
//  Copyright © 2017年 shouya.okayama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AccountViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var plofileImageview: UIImageView!
    @IBOutlet weak var nameText: UITextField!

    
    @IBAction func nextButton(_ sender: Any) {
        
        if let name = nameText.text {
            if name.characters.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                return
            }
        }
        
        let user = Auth.auth().currentUser
        if let user = user {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = nameText.text
            changeRequest.commitChanges { error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                }
                print("DEBUG_PRINT: [displayName = \(String(describing: user.displayName))]の設定に成功しました。")
                let imageData = UIImageJPEGRepresentation(self.plofileImageview.image!, 0.5)
                let imageString = imageData?.base64EncodedString(options: .lineLength64Characters)
                let userID = Auth.auth().currentUser!.uid
                
                if imageString != nil {
                    let userRef = Database.database().reference().child(Const.Users).child(userID)
                    let userData = ["image": imageString, "name": self.nameText.text]
                    userRef.setValue(userData)
                    
                    let idokeidoViewController = self.storyboard?.instantiateViewController(withIdentifier: "IdoKeido")
                    self.present(idokeidoViewController!, animated: true, completion: nil)
                
                }
            }
        } else {
            print("DEBUG_PRINT: displayNameの設定に失敗しました。")
        }
    }
        //let imageData = UIImageJPEGRepresentation(self.plofileImageview.image!, 0.5)
        //let imageString = imageData.base64EncodedString(options: .lineLength64Characters)

    
    
    
    @IBAction func libraryButton(_ sender: Any) {
        // ライブラリ（カメラロール）を指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
        
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            // 撮影/選択された画像を取得する
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.plofileImageview.image = image
        }
        
        // 閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "hikyaku")
        self.plofileImageview.image = image

        // Do any additional setup after loading the view.
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
