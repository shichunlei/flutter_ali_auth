import AVFoundation
import SDWebImage
import UIKit
import WebKit

final class PNSBackgroundView: UIView {
    var gifURL: URL?
    var videoURL: URL?

    private var imageView: UIImageView?
    private var playerLayer: AVPlayerLayer?

    func show() {
        if let gifURL {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = .black
            imageView.sd_setImage(with: gifURL)
            addSubview(imageView)
            self.imageView = imageView
        }
        if let videoURL {
            let player = AVPlayer(playerItem: AVPlayerItem(url: videoURL))
            player.isMuted = true
            let layer = AVPlayerLayer(player: player)
            layer.videoGravity = .resizeAspectFill
            layer.backgroundColor = UIColor.black.cgColor
            self.layer.addSublayer(layer)
            playerLayer = layer
            try? AVAudioSession.sharedInstance().setCategory(.ambient)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(playbackFinished),
                name: .AVPlayerItemDidPlayToEndTime,
                object: player.currentItem
            )
            player.play()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = bounds
        playerLayer?.frame = bounds
    }

    @objc private func playbackFinished() {
        playerLayer?.player?.seek(to: .zero)
        playerLayer?.player?.play()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

class PNSBaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initSubviews()
        setLayoutSubviews()
    }

    func initSubviews() {}
    func setLayoutSubviews() {}
    func shouldSetStatusBarStyleLight() -> Bool { true }
    func shouldHiddenStatusBar() -> Bool { false }

    override var prefersStatusBarHidden: Bool { false }
    override var preferredStatusBarStyle: UIStatusBarStyle { .default }
    override var shouldAutorotate: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .allButUpsideDown }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

final class PNSBaseNavigationController: UINavigationController {
    override var shouldAutorotate: Bool { topViewController?.shouldAutorotate ?? true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        topViewController?.supportedInterfaceOrientations ?? .allButUpsideDown
    }
}

final class PrivacyWebViewController: PNSBaseViewController, WKNavigationDelegate, WKUIDelegate {
    var isHiddenNavgationBar = false

    private let url: String
    private let urlName: String
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.preferences.minimumFontSize = 0
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        let view = WKWebView(frame: .zero, configuration: configuration)
        view.allowsBackForwardNavigationGestures = true
        view.navigationDelegate = self
        view.uiDelegate = self
        return view
    }()

    init(url: String, urlName: String) {
        self.url = url
        self.urlName = urlName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = urlName.isEmpty ? "服务协议" : urlName
        if let targetURL = URL(string: url) {
            webView.load(URLRequest(url: targetURL))
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isHiddenNavgationBar {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isHiddenNavgationBar {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }

    override func initSubviews() {
        super.initSubviews()
        view.addSubview(webView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
}
