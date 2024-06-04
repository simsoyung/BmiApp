//
//  ViewController.swift
//  BmiApp
//
//  Created by 심소영 on 5/21/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    
    // MARK: Outlet,Button
    
    let largeTitle = UILabel()
    let subTitle = UILabel()
    let heightLabel = UILabel()
    let weightLabel = UILabel()
    
    let image = UIImageView()
    
    let eyesButton = UIButton()
    let randomButton = UIButton()
    let resultButton = UIButton()
    let resetButton = UIButton()
    
    let heightTextField = UITextField()
    let weightTextField = UITextField()
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
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
        
        resultButtonSetting(resetButton, text: "처음으로")
        resultButtonSetting(resultButton, text: "결과 확인")
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        eyesButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        eyesButton.tintColor = .gray
        
    }
    
    // MARK: Action
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        //리셋버튼 누르면 키, 몸무게, bmi결과 숫자, bmi결과 텍스트 리셋!
        reset()
    }
    
    @IBAction func randomButtonTapped(_ sender: UIButton) {
        // 랜덤버튼 누르면 랜덤 변수(키,몸무게)만들어서 랜덤으로 뽑아온 값을 calcBmi함수 실행하고 결과값을 buttonClicked로 보내기 (얼럿)#selector(buttonClicked) 결과보여주기(숫자 00까지만 표시))
//        let randomHeight = Int.random(in: 140...200)
//        let randomWeight = Int.random(in: 40...100)
//        heightNum = Double(randomHeight)
//        weightNum = Double(randomWeight)
//        let value = heightNum / 100
//        heightNum = value * value
//        numResult = weightNum / heightNum
        var randomHeight = Double.random(in: 140...200)
        let randomWeight = Double.random(in: 40...100)
        UserDefaults.standard.set(randomHeight, forKey: "heightNum")
        UserDefaults.standard.set(randomWeight, forKey: "weightNum")
        //랜덤 더블값 뽑아서 UserDefaults에 몸무게, 키 저장
        
        let value = randomHeight / 100
        randomHeight = value * value
        let numResult = randomWeight / randomHeight
        UserDefaults.standard.set(numResult, forKey: "numResult")
        //계산 후 bmi 결과 값 UserDefaults에 저장
        
        calcBmi()
        //bmi결과에 맞는 텍스트를 담아둠
        buttonClicked()
    }
    
    @IBAction func resultButtonTapped(_ sender: UIButton) {
        //버튼 누르면 property변수에 들어있는 값을 calcBmi함수 실행하고 결과값을 buttonClicked로 보내기,
        var height = UserDefaults.standard.double(forKey: "heightNum")
        let weight = UserDefaults.standard.double(forKey: "weightNum")
        
        if height != 0.0 {
            let value = height / 100
            height = value * value
            let numResult = weight / height
            UserDefaults.standard.set(numResult, forKey: "numResult")
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
            let height = text
            UserDefaults.standard.set(height, forKey: "heightNum")
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
            let weight = text
            UserDefaults.standard.set(weight, forKey: "weightNum")
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
    
    func configureLayout(){
        view.addSubview(largeTitle)
        view.addSubview(subTitle)
        view.addSubview(heightLabel)
        view.addSubview(weightLabel)
        
        view.addSubview(image)
        
        view.addSubview(eyesButton)
        view.addSubview(randomButton)
        view.addSubview(resultButton)
        view.addSubview(resetButton)
        
        view.addSubview(heightTextField)
        view.addSubview(weightTextField)
    }
    
    func configureHierarchy(){
        largeTitle.snp.makeConstraints { make in
            make.top.equalTo(42)
            make.leading.equalTo(16)
            make.width.equalTo(170)
            make.height.equalTo(38)
        }
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(largeTitle.snp.bottom)
            make.leading.equalTo(largeTitle.snp.leading)
            make.width.equalTo(100)
            make.height.equalTo(38)
        }
        heightLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom).offset(140)
            make.leading.equalTo(subTitle.snp.leading)
            make.width.equalTo(160)
            make.height.equalTo(30)
        }
        heightTextField.snp.makeConstraints { make in
            make.top.equalTo(heightLabel.snp.bottom).offset(4)
            make.leading.equalTo(heightLabel.snp.leading)
            make.width.equalTo(300)
            make.height.equalTo(35)
        }
        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(heightTextField.snp.bottom).offset(48)
            make.leading.equalTo(heightTextField.snp.leading)
            make.width.equalTo(160)
            make.height.equalTo(30)
        }
        
    }
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
    
    func resultButtonSetting(_ sender: UIButton, text: String){
        sender.setTitle(text, for: .normal)
        sender.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = .purple
        sender.layer.cornerRadius = 20
    }
    
    @objc func buttonClicked(){
    
        let bmiNum = UserDefaults.standard.double(forKey: "numResult")
        let bmiText = UserDefaults.standard.string(forKey: "textResult")
        let alert = UIAlertController(
            title: "BMI 결과",
            message: "\(String.init(format: "%.2f", bmiNum))로 \(bmiText ?? "")입니다",
            preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "살 뺄게요", style: .destructive)
        let check = UIAlertAction(title: "더 먹을래요", style: .default)
        
        alert.addAction(cancel)
        alert.addAction(check)
        
        present(alert, animated: true)
        
        reset()
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
    
    func reset(){
        UserDefaults.standard.removeObject(forKey: "numResult")
        UserDefaults.standard.removeObject(forKey: "textResult")
        UserDefaults.standard.removeObject(forKey: "heightNum")
        UserDefaults.standard.removeObject(forKey: "weightNum")
        heightTextField.text = ""
        weightTextField.text = ""
    }
    
    func calcBmi(){
        //텍스트 필드에서 받아온 키, 몸무게 받아서 BMI 계산해주기 결과값 tappedbutton
        
        let result = UserDefaults.standard.double(forKey: "numResult")
        if result <= 18.40 {
            let text = "저체중"
            UserDefaults.standard.set(text, forKey: "textResult")
        }else if result <= 22.90{
            let text = "정상체중"
            UserDefaults.standard.set(text, forKey: "textResult")
        }else if result <= 24.90 {
            let text = "과체중"
            UserDefaults.standard.set(text, forKey: "textResult")
        }else if result <= 29.90 {
            let text = "비만"
            UserDefaults.standard.set(text, forKey: "textResult")
        }else {
            let text = "고도비만"
            UserDefaults.standard.set(text, forKey: "textResult")
        }
    }
}


