import UIKit

protocol WebSockets {
    func ping()
    func close()
    func send()
    func receive()
}

class ViewController: UIViewController {

    private var webSocket: URLSessionWebSocketTask?
    private let closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBlue

        let urlSession = URLSession(
                configuration: .default,
                delegate: self,
                delegateQueue: OperationQueue()
        )

        // The url test online is this one
        // https://www.piesocket.com/websocket-tester
        let url = URL(string: "wss://demo.piesocket.com/v3/channel_1?api_key=oCdCMcMPQpbvNjUIzqtvF1d2X2okWpDQj4AwARJuAgtjhzKxVEjQU6IdCjwm&notify_self")!
        webSocket = urlSession.webSocketTask(with: url)
        webSocket?.resume()
        closeButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.center = view.center
    }
}

extension ViewController: WebSockets {
    func ping() {
        webSocket?.sendPing { error in
            if let error = error {
                print("Error en ping\(error.localizedDescription)")
            }
        }
    }

    @objc func close() {
        webSocket?.cancel(with: .goingAway, reason: "Demo ended".data(using: .utf8))
    }

    func send() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.send()
            self.webSocket?.send(.string("Enviar el siguiente mensaje \(Int.random(in: 0...100))")) { error in
                if let error = error {
                    print("Error en send\(error.localizedDescription)")
                }
            }
        }
    }

    func receive() {
        webSocket?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Got data: \(data)")
                case .string(let message):
                    print("Got message: \(message)")
                @unknown default:
                    break
                }
            case .failure(let error):
                print("Error en send\(error.localizedDescription)")
            }

            self?.receive()
        }
    }
}

extension ViewController: URLSessionWebSocketDelegate {
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        ping()
        send()
        receive()
        print("Did open connection")
    }

    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Did close connection")
    }
}
