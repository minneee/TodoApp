//
//  TodoDetailViewController.swift
//  Todo
//
//  Created by 김민희 on 2022/02/19.
//

import UIKit
import Alamofire

class TodoDetailViewController: UIViewController {

    @IBOutlet weak var detailTitleLabel: UILabel!
    
    @IBOutlet weak var detailDateLabel: UILabel!
    
    @IBOutlet weak var detailContentLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var receiveTitle = ""
    var receiveDate = ""
    var receiveContent = ""
    var receiveNo = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailTitleLabel.text = receiveTitle
        detailDateLabel.text = receiveDate
        detailContentLabel.text = receiveContent
        
        self.navigationItem.title = "상세보기"
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        print("삭제 버튼 클릭")
        let deleteActionSheet = UIAlertController(title: nil, message: "할 일을 삭제하시겠습니까?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "삭제", style: UIAlertAction.Style.destructive, handler: {
            ACTION in
            
            let userid = UserDefaults.standard.string(forKey: "id") ?? ""
            let param = DeleteTodoRequest(no: self.receiveNo, userid: userid)
            self.postDeleteTodo(param)
            
        })
        let deleteCancle = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        deleteActionSheet.addAction(deleteAction)
        deleteActionSheet.addAction(deleteCancle)
        
        self.present(deleteActionSheet, animated: true, completion: nil)
        
        
        
    }
    
    
    func postDeleteTodo(_ parameters: DeleteTodoRequest) {
        AF.request("http://13.209.10.30:4004/todo/delete", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: DeleteTodoResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        print(response.message)
                        //성공 로직
                        self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        print(response.message)
                        //실패 로직
                        let deleteFailAlert = UIAlertController(title: "경고", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        
                        let deleteFailAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                        deleteFailAlert.addAction(deleteFailAction)
                        self.present(deleteFailAlert, animated: true, completion: nil)
                    }
                
                case .failure(let error):
                    print("서버 통신 실패\(error.localizedDescription)")
                    let signUpFailAlert = UIAlertController(title: "경고", message: "서버 통신에 실패하였습니다.", preferredStyle: UIAlertController.Style.alert)
                    
                    let signUpFailAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                    signUpFailAlert.addAction(signUpFailAction)
                    self.present(signUpFailAlert, animated: true, completion: nil)
                }
            }
        
    }
}
