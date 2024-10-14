//
//  WebViewController.swift
//  MovieSuggest
//
//  Created by Akshay Mamidwar    on 28/08/24.
//

import WebKit

class WebViewController: UIViewController {

    // MARK: - Properties

    private let url: URL?
    fileprivate let syncCookiesNeeded: Bool
    private let webView = WKWebView()
 
    // MARK: - Initializers

    init(url: URL?, syncCookiesNeeded: Bool = false) {
        self.url = url
        self.syncCookiesNeeded = syncCookiesNeeded
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("WebViewController viewDidLoad")
        view.addSubview(webView)
        self.webView.navigationDelegate = self
        webView.frame = view.bounds
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard syncCookiesNeeded else { return }
        synchronizeCookies(from: webView)
    }

    private func synchronizeCookies(from webView: WKWebView) {
        let httpCookieStore = webView.configuration.websiteDataStore.httpCookieStore
        httpCookieStore.getAllCookies { cookies in
            cookies.forEach {
                HTTPCookieStorage.shared.setCookie($0) }
        }
    }
}
