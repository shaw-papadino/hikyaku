//
//  LoginViewController.swift
//  Hikyaku
//
//  Created by 岡山将也 on 2017/12/27.
//  Copyright © 2017年 shouya.okayama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    var userProfile : NSDictionary!
    
    
    @IBAction func facebookLoginButton(_ sender: Any) {
        LoginManager().logIn([.publicProfile, .email], viewController: self, completion: {
            result in
            switch result {
            case let .success( permission, declinePemisson, token):
                print("token:\(token),\(permission),\(declinePemisson)")
                let credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
                self.signIn(credential: credential)
            case let .failed(error):
                print("error:\(error)")
            case .cancelled:
                print("cancelled")
            }
            
        })
    }
    func signIn(credential:AuthCredential){
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("error:\(error)")
                return
            } else {
                self.getUserInfo()
            }
            return
        }
    }
    @IBAction func LoginButton(_ sender: Any) {
        if let address = mailTextField.text, let password = passwordTextField.text {
            
            // アドレスとパスワード名のいずれかでも入力されていない時は何もしない
            if address.characters.isEmpty || password.characters.isEmpty {
                return
            }
            
            Auth.auth().signIn(withEmail: address, password: password) { user, error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    return
                } else {
                    print("DEBUG_PRINT: ログインに成功しました。")
                    
                    DispatchQueue.main.async {
                        let slideViewController = self.storyboard?.instantiateViewController(withIdentifier: "Slide")
                        self.present(slideViewController!, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    @IBAction func CreateButton(_ sender: Any) {
        if let address = mailTextField.text, let password = passwordTextField.text {
            
            // アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
            if address.characters.isEmpty || password.characters.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                return
            }
            
            // アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログインする
            Auth.auth().createUser(withEmail: address, password: password) { user, error in
                if let error = error {
                    // エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    return
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
                DispatchQueue.main.async {
                    let accountViewController = self.storyboard?.instantiateViewController(withIdentifier: "Account")
                    self.present(accountViewController!, animated: true, completion: nil)
                }
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //let loginButton = LoginButton(readPermissions: [ .PublicProfile ])
        //loginButton.delegate = UIApplication.shared.delegate as! AppDelegate
        //loginButton.center = view.center
        
        //view.addSubview(loginButton)
        
        // Do any additional setup after loading the view.
    }
    func isLoggedInWithFacebook() -> Bool {
        let loggedIn = AccessToken.current != nil
        return loggedIn
    }
    
    func getUserInfo (){
        //Facebookのユーザー情報を取得する処理
        GraphRequest(graphPath: "me", parameters: ["fields": "name, picture.type(large"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: GraphAPIVersion.defaultVersion).start({
            response, result in
                switch result {
                case .success(let response) :
                    print("response:\(response)")
                    // プロフィール情報をディクショナリに入れる
                    self.userProfile = result as! NSDictionary
                    print(self.userProfile)
                    let profileImageURL : String = ((self.userProfile.object(forKey: "picture") as AnyObject).object(forKey: "data") as AnyObject).object(forKey: "url") as! String
                    let profileImage = UIImage(data: try! Data(contentsOf: URL(string: profileImageURL)!))
                    let name = self.userProfile.object(forKey:"name") as? String
                    let imageData2 = UIImageJPEGRepresentation(profileImage!, 0.5)
                    let imageString = imageData2?.base64EncodedString(options: .lineLength64Characters)
                    let userID = Auth.auth().currentUser!.uid
                    
                    if imageString != nil {
                        let userRef = Database.database().reference().child(Const.Users).child(userID)
                        let userData = ["image": imageString, "name": name]
                        userRef.setValue(userData)
                     
                        let idokeidoViewController = self.storyboard?.instantiateViewController(withIdentifier: "IdoKeido")
                        self.present(idokeidoViewController!, animated: true, completion: nil)
                    }
                //let data: [String : AnyObject] = response
                //let name = data["name"] as! String
                //let profilePictureURLStr = (data["picture"]!["data"]!! as! [String : AnyObject])["url"]
                //let imgURL = NSURL(string: profilePictureURLStr as! String)
                //let imageData = NSData(contentsOf: imgURL! as URL)
                //let image = UIImage(data: imageData! as Data)
                //let imageData2 = UIImageJPEGRepresentation(image!, 0.5)
                //let imageString = imageData2?.base64EncodedString(options: .lineLength64Characters)

                    break
                case .failed(let error):
                    print("error:\(error.localizedDescription)")
                
                }
            
            })
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // currentUserがnilならログインしていない
        if Auth.auth().currentUser != nil {
            // ログインしているときの処理
            // viewDidAppear内でpresent()を呼び出しても表示されないためメソッドが終了してから呼ばれるようにする
            DispatchQueue.main.async {
                let slideViewController = self.storyboard?.instantiateViewController(withIdentifier: "Slide")
                self.present(slideViewController!, animated: true, completion: nil)
            }
        }
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
