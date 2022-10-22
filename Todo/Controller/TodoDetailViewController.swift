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
    
    @IBOutlet weak var detailContentTextView: UITextView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(buttonPressed(_:)))
        
        return button
    }()
    var receiveTitle = ""
    var receiveDate = ""
    var receiveContent = ""
    var receiveNo = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailTitleLabel.text = receiveTitle
        detailDateLabel.text = receiveDate
        detailContentTextView.text = receiveContent
        
        self.navigationItem.title = "상세보기"
        self.navigationItem.rightBarButtonItem = rightButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc private func buttonPressed(_ sender: Any) {
        //편집 버튼 클릭
        print("편집 버튼 클릭")
        
        let storyBoard = UIStoryboard(name: "todo", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "AddTodoViewController") as! AddTodoViewController
        VC.navigationItem.title = "할일 편집"
        self.navigationController?.pushViewController(VC, animated: true)
        print("음름음")
   
        
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        print("삭제 버튼 클릭")
        let deleteActionSheet = UIAlertController(title: nil, message: "할 일을 삭제하시겠습니까?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "삭제", style: UIAlertAction.Style.destructive, handler: {
            ACTION in
            let userid = UserDefaults.standard.string(forKey: "id") ?? ""
            let param = DeleteTodoRequest(uuid: userid, todo_id: self.receiveNo)
            self.postDeleteTodo(param)
            
        })
        let deleteCancle = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        deleteActionSheet.addAction(deleteAction)
        deleteActionSheet.addAction(deleteCancle)
        
        self.present(deleteActionSheet, animated: true, completion: nil)
        
        
        
    }
    
    
    func postDeleteTodo(_ parameters: DeleteTodoRequest) {
        AF.request("http://54.180.25.129:8080/todo", method: .delete, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: DeleteTodoResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.success == true {
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
