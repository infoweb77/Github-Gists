import UIKit
import SnapKit

protocol LoginViewDelegate: class {
    func login(login: String, password: String)
}

class LoginView: UIView, UITextFieldDelegate {
    
    weak var delegate: LoginViewDelegate?
    
    private let loginInput = UITextField()
    private let passwordInput = UITextField()
    private let loginButton = UIButton()
    
    let leftBorder: CGFloat = 50.0
    let rightBorder: CGFloat = -50.0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ASColor.white
        initializeView()
    }
    
    private func initializeView() {
        buildLoginInput()
        buildPasswordInput()
        buildLoginButton()
        
        addObservers()
        //disableLoginButton()
    }
    
    internal func show() {
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 1
        })
    }
    
    internal func hide() {
        self.alpha = 0
    }
    
    private func buildLoginInput() {
        loginInput.borderStyle = .none
        loginInput.clearButtonMode = .whileEditing
        loginInput.placeholder = "Please, enter you login"
        
        loginInput.autocapitalizationType = .none
        loginInput.autocorrectionType = .no
        loginInput.spellCheckingType = .no
        
        loginInput.accessibilityIdentifier = "loginField"
        loginInput.keyboardType = .default
        loginInput.returnKeyType = .next
        loginInput.setBottomBorder(color: ASColor.silver, width: 1.0)
        
        addSubview(loginInput)
        loginInput.snp.makeConstraints { (make) in
            make.top.equalTo(150)
            make.left.equalTo(leftBorder)
            make.right.equalTo(rightBorder)
        }
    }
    
    private func buildPasswordInput() {
        passwordInput.borderStyle = .none
        passwordInput.clearButtonMode = .whileEditing
        passwordInput.placeholder = "and password"
        
        passwordInput.isSecureTextEntry = true
        passwordInput.delegate = self
        
        passwordInput.autocapitalizationType = .none
        passwordInput.autocorrectionType = .no
        passwordInput.spellCheckingType = .no
        
        passwordInput.accessibilityIdentifier = "passwordField"
        passwordInput.returnKeyType = .done
        passwordInput.setBottomBorder(color: ASColor.silver, width: 1.0)
        
        
        addSubview(passwordInput)
        passwordInput.snp.makeConstraints { (make) in
            make.top.equalTo(220)
            make.left.equalTo(leftBorder)
            make.right.equalTo(rightBorder)
        }
    }

    private func buildLoginButton() {
        loginButton.setTitle("Login with Github", for: .normal)
        loginButton.accessibilityIdentifier = "loginButton"
        loginButton.setTitleColor(ASColor.white, for: .normal)
        
        loginButton.titleLabel?.font = ASFonts.fontSemibold(size: 20)
        loginButton.backgroundColor = ASColor.clearBlue
        loginButton.layer.cornerRadius = 25
        loginButton.clipsToBounds = true
        
        addSubview(loginButton)
        loginButton.snp.makeConstraints { btn in
            btn.top.equalTo(310)
            btn.centerX.equalToSuperview()
            btn.size.equalTo(CGSize(width: 205, height: 50))
        }
    }

    private func enableLoginButton() {
        loginButton.isEnabled = true
        loginButton.alpha = 1
    }
    
    private func disableLoginButton() {
        loginButton.isEnabled = false
        loginButton.alpha = 0.3
    }

    private func addObservers() {
        let taptRecognizer = UITapGestureRecognizer(target: self, action: #selector(onViewTap))
        isUserInteractionEnabled = true
        addGestureRecognizer(taptRecognizer)
        
        loginInput.addTarget(self, action: #selector(inputEditing(_:)), for: .allEditingEvents)
        loginInput.addTarget(self, action: #selector(loginEditingDidEnd(_:)), for: .editingDidEnd)
        
        passwordInput.addTarget(self, action: #selector(inputEditing(_:)), for: .allEditingEvents)
        passwordInput.addTarget(self, action: #selector(passwordEditingDidEnd(_:)), for: .editingDidEnd)
        
        loginButton.addTarget(self, action: #selector(loginButtonPress), for: .touchUpInside)
    }

    private func inputEditingDidEnd(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.setBottomBorder(color: ASColor.silver, width: 1.0)
    }
    
    private func proceedLogin() {
        endEditing()
        if !isFormFieldIn() { return }
        delegate!.login(login: loginInput.text!, password: passwordInput.text!)
    }
    
    private func endEditing() {
        self.endEditing(true)
    }
    
    private func isFormFieldIn() -> Bool {
        return !loginInput.text.isNilOrEmpty && !passwordInput.text.isNilOrEmpty
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isFormFieldIn() {
            proceedLogin()
        }
        return true
    }
    
    //observer delegates
    @objc private func inputEditing(_ textField: UITextField) {
        textField.setBottomBorder(color: ASColor.black, width: 2.0)
        isFormFieldIn() ? enableLoginButton() : disableLoginButton()
    }
    
    @objc private func loginEditingDidEnd(_ textField: UITextField) {
        inputEditingDidEnd(textField)
        passwordInput.becomeFirstResponder()
    }
    
    @objc private func passwordEditingDidEnd(_ textField: UITextField) {
        inputEditingDidEnd(textField)
    }
    
    @objc private func loginButtonPress() {
        endEditing()
        proceedLogin()
    }

    @objc private func onViewTap() {
        endEditing()
    }
}
