import Flutter
import UIKit

public class SwiftSocketIoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "socket_io", binaryMessenger: registrar.messenger())
    let instance = SwiftSocketIoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as! Dictionary<String, Any>;
    let domain = args["socketDomain"]
    let path = args["socketNameSpace"]
    let callback = args["socketCallback"]
    
    switch call.method {
    case "socketInit":
        
        break
    default:
        break
    }
    
    //result("iOS " + UIDevice.current.systemVersion)
  }
}
