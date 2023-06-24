import UIKit
import WebKit




class KakaoZipCodeVC: UIViewController {

    // MARK: - Properties
    var webView: WKWebView?
    let indicator = UIActivityIndicatorView(style: .medium)
    var address = ""

//    weak var delegate: KakaoZipCodeDelegate?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

    // MARK: - UI
    private func configureUI() {
        // Set it to the left of the navigation bar.
        
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(backButtonPressed))
        navigationItem.leftBarButtonItem = dismissButton

        view.backgroundColor = .white
        setAttributes()
        setContraints()
    }

    private func setAttributes() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "callBackHandler")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController

        webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView?.navigationDelegate = self

        guard let url = URL(string: "https://altese.github.io/kakao-address/"),
            let webView = webView
            else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        indicator.startAnimating()
    }

    private func setContraints() {
        guard let webView = webView else { return }
        
        
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false

        webView.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        

        
        NSLayoutConstraint.activate([
            
            
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            indicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor),
        ])
    }
    
    
}



extension KakaoZipCodeVC: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let data = message.body as? [String: Any] {
            address = data["roadAddress"] as? String ?? ""
        }
//        guard presentingViewController is UpdateViewController else { return }

        // 텍스트 필드를 받아온 address로 채워준다.

//        previousVC.lblAddress.text = address
        Message.address = address
        
        self.dismiss(animated: true, completion: nil)
    }
    
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//
//        
//        if let data = message.body as? [String: Any] {
//            let address = data["roadAddress"] as? String ?? ""
//            delegate?.didSelectAddress(address) // 델리게이트 메서드 호출하여 주소 전달
//            print("checkaddress \(address)")
//        }
//        
//
//        self.dismiss(animated: true, completion: nil)
//    }
    
    @objc private func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        }
}

extension KakaoZipCodeVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}


