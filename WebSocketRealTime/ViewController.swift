import UIKit

protocol WebSockets {
    func ping()
    func close()
    func send()
    func receive()
}

class ViewController: UIViewController {

    private var webSocket: URLSessionWebSocketTask?

    override func viewDidLoad() {
        super.viewDidLoad()

        let urlSession = URLSession(
                configuration: .default,
                delegate: self,
                delegateQueue: OperationQueue()
        )

        let url = URL(string: "wss://demo.piesocket.com/v3/channel_1?api_key=oCdCMcMPQpbvNjUIzqtvF1d2X2okWpDQj4AwARJuAgtjhzKxVEjQU6IdCjwm&notify_self")!
        webSocket = urlSession.webSocketTask(with: url)
        webSocket?.resume()
    }
}

extension ViewController : WebSockets {
    func ping() {
    }

    func close() {
    }

    func send() {
    }

    func receive() {
    }
}

extension ViewController : URLSessionWebSocketDelegate {
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Did open connection")
    }

    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Did close connection")
    }
}
