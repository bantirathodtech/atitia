import Flutter
import UIKit
import GoogleSignIn

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Configure Google Sign-In
    guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
          let plist = NSDictionary(contentsOfFile: path),
          let clientId = plist["CLIENT_ID"] as? String else {
      print("❌ Error: Could not load GoogleService-Info.plist")
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    print("✅ Google Sign-In Client ID: \(clientId)")
    GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientId)
    print("✅ Google Sign-In configured successfully")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    print("🔄 Handling URL: \(url)")
    let handled = GIDSignIn.sharedInstance.handle(url)
    print("✅ URL handled by Google Sign-In: \(handled)")
    return handled
  }
}
