//
//  ViewController.swift
//  Unlock
//
//  Created by 簡吟真 on 2021/5/5.
//

import UIKit
import LocalAuthentication  //FaceID

class ViewController: UIViewController {

    @IBOutlet var pwImage: [UIImageView]!
    @IBOutlet var number: [UIButton]!
    
    
    @IBOutlet var stateView: UIView!
    @IBOutlet weak var faceIDLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var pwText: UILabel!
    var passcode = "1122"
    var enter = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }

    func imageshow(){
        switch enter.count {
        case 1:
            pwImage[0].isHidden = false
            for i in 1...3{
                pwImage[i].isHidden = true
            }
        case 2:
            for i in 0...3{
                if i > 1{
                    pwImage[i].isHidden = true
                }
                else{
                    pwImage[i].isHidden = false
                }
            }
        case 3:
            for i in 0...2{
                pwImage[i].isHidden = false
            }
            pwImage[3].isHidden = true
        case 4:
            for i in 0...3{
                pwImage[i].isHidden = false
            }
            checkpw()
        default:
            reset()
        }
    }
    
    
    func checkpw(){
        if enter == passcode{
            let controller = UIAlertController(title: "密碼正確", message: "歡迎回來", preferredStyle: .alert)
            pwText.text = "密碼正確。"
            let action = UIAlertAction(title: "確認", style: .default) { (_) in
                self.reset()
            }
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
            
        }
        else if enter != passcode{
            let controller = UIAlertController(title: "密碼錯誤", message: "請再試一次", preferredStyle: .alert)
            pwText.text = "密碼錯誤。"
            let action = UIAlertAction(title: "重新輸入", style: .default){ (_) in
                self.reset()
            }
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
        }
        
    }

    
    
    @IBAction func enterpw(_ sender: UIButton) {
        //密碼長度不等於4
        if enter.count != 4 {
            if let inputNumber = sender.currentTitle {
                //字串相加
                enter.append(inputNumber)
            }
        }
        imageshow()
    }
    
    
    @IBAction func deletenum(_ sender: UIButton) {
        if enter.count != 0 {
            enter.removeLast()
        }
        imageshow()
    }
    func reset(){
        for i in 0...3{
            pwImage[i].isHidden = true
        }
        enter = ""
        pwText.text = "請輸入密碼。"
    }
    
    
    
    
    
    // FaceID or TouchID
    

    @IBAction func logging(_ sender: UIButton) {
        // 創建 LAContext 實例
        let context = LAContext()
        // 設置取消按鈕標題
        context.localizedCancelTitle = "Cancel"
        var error: NSError?
        // 評估是否可以針對給定方案進行身份驗證
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Log in to your account"
            // 評估指定方案
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, error) in
                if success {
                    DispatchQueue.main.async { [unowned self] in
                        self.showMessage(title: "Login Successful", message: nil)
                    }
                } else {
                    DispatchQueue.main.async { [unowned self] in
                        self.showMessage(title: "Login Failed", message: error?.localizedDescription)
                    }
                }
            }
        } else {
            showMessage(title: "Failed", message: error?.localizedDescription)
        }
    }
    
    func showMessage(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
