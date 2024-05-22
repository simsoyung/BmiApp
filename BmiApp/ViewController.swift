//
//  ViewController.swift
//  BmiApp
//
//  Created by 심소영 on 5/21/24.
//

import UIKit

class ViewController: UIViewController {

    
    // MARK: Outlet,Button
    
    @IBOutlet var largeTitle: UILabel!
    @IBOutlet var subTitle: UILabel!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    
    @IBOutlet var image: UIImageView!
    
    @IBOutlet var eyesButton: UIButton!
    @IBOutlet var randomButton: UIButton!
    @IBOutlet var resultButton: UIButton!
    
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    
    // MARK: Prooerty
    var heightNum = 0.0
    var weightNum = 0.0
    var caseResult = ""
    var numResult = 0.0
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        largeTitleSetting()
        textTitleSetting(setTitle: subTitle, text: "당신의 BMI 지수를  알려드릴게요.", line: 2)
        textTitleSetting(setTitle: heightLabel, text: "키가 어떻게 되시나요?", line: 1)
        textTitleSetting(setTitle: weightLabel, text: "몸무게가 어떻게 되시나요?", line: 1)
        
        image.image = UIImage(named: "image")
        image.contentMode = .scaleAspectFill

        textFieldSetting(text: heightTextField)
        textFieldSetting(text: weightTextField)
        weightTextField.isSecureTextEntry = true
        
        
        randomButtonSetting()
        resultButtonSetting()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        eyesButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        eyesButton.tintColor = .gray
        
    }
    
    // MARK: Action
    
    @IBAction func randomButtonTapped(_ sender: UIButton) {
        // 랜덤버튼 누르면 랜덤 변수(키,몸무게)만들어서 랜덤으로 뽑아온 값을 calcBmi함수 실행하고 결과값을 buttonClicked로 보내기 (얼럿)#selector(buttonClicked) 결과보여주기(숫자 00까지만 표시))
        let randomHeight = Int.random(in: 140...200)
        let randomWeight = Int.random(in: 40...100)
        heightNum = Double(randomHeight)
        weightNum = Double(randomWeight)
        let value = heightNum / 100
        heightNum = value * value
        numResult = weightNum / heightNum
        calcBmi()
        buttonClicked()
    }
    
    @IBAction func resultButtonTapped(_ sender: UIButton) {
        //버튼 누르면 property변수에 들어있는 값을 calcBmi함수 실행하고 결과값을 buttonClicked로 보내기,
        
        if heightNum != 0.0 {
            let value = heightNum / 100
            heightNum = value * value
            numResult = weightNum / heightNum
            calcBmi()
            buttonClicked()
        } else {
            errorAlert()
        }
    }
    
    @IBAction func heightTextResult(_ sender: UITextField) {
        //입력받은 글자를 변수에 넣어주고,
        //텍스트필드 text 초기화,
        //아무곳이나 클릭하면 키패드 내려가기,
        let text = sender.text ?? "0"
        if Double(text) != nil {
            heightNum = Double(text) ?? 0
        } else {
            errorAlert()
        }
        //빈칸 없애기
        //숫자만 입력
    }
    
    @IBAction func weightTextResult(_ sender: UITextField) {
        // 입력받은 글자를 변수에 넣어주고, 텍스트필드 text 초기화, 입력값 안보여주기
        let text = sender.text ?? "0"
        if Double(text) != nil {
            weightNum = Double(text) ?? 0
        } else {
            errorAlert()
        }
    }
    
    
    @IBAction func eyesButtonTapped(_ sender: UIButton) {
        // 눈 버튼 누르면 -> 몸무게 보이게
        sender.setImage(UIImage(systemName: "eye.slash"),for: .highlighted)
        sender.setTitle(weightTextField.text, for: .highlighted)
        sender.setImage(UIImage(systemName: "eye.slash.fill"),for: .normal)
        sender.setTitle(weightTextField.text, for: .normal)

    }
        
    // MARK: func
    
    func largeTitleSetting(){
        largeTitle.text = "BMI Calculator"
        largeTitle.font = .systemFont(ofSize: 22, weight: .bold)
        largeTitle.textColor = .black
        largeTitle.textAlignment = .left
    }
    
    func textTitleSetting(setTitle title: UILabel, text: String, line: Int){
        title.text = text
        title.font = .systemFont(ofSize: 13, weight: .medium)
        // 텍스트줄의 lineSpacing 간격 설정!!!
        let attrString = NSMutableAttributedString(string: title.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        title.attributedText = attrString
        //
        title.textColor = .black
        title.textAlignment = .left
        title.numberOfLines = line
    }
    
    func randomButtonSetting(){
        //randomButton.titleLabel?.text = "랜덤으로 BMI 계산하기"
        randomButton.setTitleColor(.red, for: .normal)
        randomButton.setTitle("랜덤으로 BMI 계산하기", for: .normal)
        randomButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        randomButton.backgroundColor = .clear
    }
    
    func textFieldSetting(text: UITextField){
        text.layer.cornerRadius = 10
        text.layer.borderColor = UIColor.black.cgColor
        text.layer.borderWidth = 1
        text.frame.size.height = 40
        text.clearsOnBeginEditing = false
        text.returnKeyType = .done
        text.keyboardType = .numberPad
    }
    
    func resultButtonSetting(){
        resultButton.setTitle("결과 확인", for: .normal)
        resultButton.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        resultButton.setTitleColor(.white, for: .normal)
        resultButton.backgroundColor = .purple
        resultButton.layer.cornerRadius = 20
    }
    
    @objc func buttonClicked(){
    
        let alert = UIAlertController(
            title: "BMI 결과",
            message: "\(String.init(format: "%.2f", numResult))로 \(caseResult)입니다",
            preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "살 뺄게요", style: .destructive)
        let check = UIAlertAction(title: "더 먹을래요", style: .default)
        
        alert.addAction(cancel)
        alert.addAction(check)
        
        present(alert, animated: true)
        
        heightNum = 0.0
        weightNum = 0.0
        caseResult = ""
        numResult = 0.0
        heightTextField.text = ""
        weightTextField.text = ""
    }
    
    @objc func errorAlert(){
        let alert = UIAlertController(
            title: "경고",
            message: "숫자를 입력해주세요",
            preferredStyle: .alert)
        
        let check = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(check)
        present(alert, animated: true)
    }
    
    func calcBmi(){
        //텍스트 필드에서 받아온 키, 몸무게 받아서 BMI 계산해주기 결과값 tappedbutton
        let result = numResult
        if result <= 18.40 {
            caseResult = "저체중"
        }else if result <= 22.90{
            caseResult = "정상체중"
        }else if result <= 24.90 {
            caseResult = "과체중"
        }else if result <= 29.90 {
            caseResult = "비만"
        }else {
            caseResult = "고도비만"
        }
        
    }
}


