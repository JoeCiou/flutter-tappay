import Flutter
import UIKit
import TPDirect

public class FlutterTappayPlugin: NSObject, FlutterPlugin {
    var channel: FlutterMethodChannel!
    var linePay: TPDLinePay?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_tappay", binaryMessenger: registrar.messenger())
        let instance = FlutterTappayPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setup":
            let arguments = call.arguments as! [String: Any?]
            let appId = arguments["appId"] as! Int
            let appKey = arguments["appKey"] as! String
            let isProduction = arguments["isProduction"] as! Bool
            
            TPDSetup.setWithAppId(Int32(appId), withAppKey: appKey, with: isProduction ? TPDServerType.production : TPDServerType.sandBox)
            TPDLinePay.addExceptionObserver(#selector(tappayLinePayExceptionHandler(notification:)))
            result(nil)
        case "isLinePayAvailable":
            result(TPDLinePay.isLinePayAvailable())
        case "installLineApp":
            TPDLinePay.installLineApp()
            result(nil)
        case "getLinePayPrime":
            let arguments = call.arguments as! [String: Any?]
            let returnUrl = arguments["returnUrl"] as! String
            
            linePay = TPDLinePay.setup(withReturnUrl: returnUrl)
            linePay!
                .onSuccessCallback { prime in
                    self.channel.invokeMethod(
                        "onLinePayCallback",
                        arguments: [
                            "status": "success",
                            "prime": prime,
                        ])
                }
                .onFailureCallback { statusCode, message in
                    self.channel.invokeMethod(
                        "onLinePayCallback",
                        arguments: [
                            "status": "failure",
                            "message": message,
                            "code": statusCode,
                        ])
                }
                .getPrime()
            result(nil)
        case "redirectToLinePay":
            let arguments = call.arguments as! [String: Any?]
            let paymentUrl = arguments["paymentUrl"] as! String
            let vc = UIApplication.shared.delegate!.window!!.rootViewController!
            
            linePay!.redirect(paymentUrl, with: vc) { linePayResult in
                var resultJson: [String:Any] = ["status": linePayResult.status]
                if let recTradeId = linePayResult.recTradeId { resultJson["recTradeId"] = recTradeId }
                if let bankTransactionId = linePayResult.bankTransactionId { resultJson["bankTransactionId"] = bankTransactionId}
                if let orderNumber = linePayResult.orderNumber {resultJson["orderNumber"] = orderNumber}
                result(resultJson)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    @objc func tappayLinePayExceptionHandler(notification: Notification) {
        let linePayResult = TPDLinePay.parseURL(notification)
        var resultJson: [String:Any] = ["status": linePayResult.status]
        if let recTradeId = linePayResult.recTradeId { resultJson["recTradeId"] = recTradeId }
        if let bankTransactionId = linePayResult.bankTransactionId { resultJson["bankTransactionId"] = bankTransactionId}
        if let orderNumber = linePayResult.orderNumber {resultJson["orderNumber"] = orderNumber}
        
        channel.invokeMethod("onLinePayException", arguments: resultJson)
    }
    
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let tabPayHandled = TPDLinePay.handle(url)
        return tabPayHandled
    }
}
