# SplashAnimate
A simple App splash animation

![](https://github.com/zyphs21/SplashAnimate/blob/master/splashanimate.gif)

## 准备工作：
首先我们需要确定作为宣传的图片的宽高比，这个一般是与 UI 确定的。一般启动屏展示会有上下两部分，上面是宣传图片，下面是 App 的 Logo。
## 实现基本思路：
在 LaunchScreen 结束后，在 AppDelegate 中将 rootViewController 指向展示广告用的 AdViewController，在AdViewController 中设置一段时间后自己销毁，并提供回调方法在 AppDelegate 中将 rootViewController 指向 App 真正的首页。
## 实现细节：
新建一个 AdViewController 用于放置广告宣传等展示.注意有一个回调方法。
```Swift
class AdViewController: UIViewController {

// 用于 AdViewController 销毁后的回调
var completion: (() -> Void)?

var adImage: UIImage?
var adView: UIImageView?

override func viewDidLoad() {
// ....
}
}
```
在 ViewDidLoad 方法中配置广告图,同时判断 iPhoneX的特殊情况
```Swift
override func viewDidLoad() {
super.viewDidLoad()

var adViewHeight = (1040 / 720) * screenWidth
var imageName = "start_page"
if UIDevice.isiPhoneX() {
adViewHeight = (1920 / 1124) * screenWidth
imageName = "start_page_x"
}

adView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: adViewHeight))
adView?.image = UIImage(named: imageName)
adView?.contentMode = .scaleAspectFill
self.view.addSubview(adView!)

let bottomHolderView = UIView(frame: CGRect(x: 0, y: screenHeight-120, width: screenWidth, height: 120))
self.view.addSubview(bottomHolderView)


let logo = UIImageView(frame: CGRect(x: (screenWidth-120)/2, y: (120-50)/2, width: 120, height: 50))
logo.image = UIImage(named: "start_logo")
bottomHolderView.addSubview(logo)

let time: TimeInterval = 1.0
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
self.dismissAdView()
}
}
```
上面代码中有几个注意的:

因为图片要撑满屏幕的宽度，所以宽度是固定的，根据图片的高宽比，算出图片实际应有的高度，这样图片可以在各个尺寸的 iPhone 中才不会因为拉伸而变形。但是因为 iPhoneX 特殊的宽高比，所以还是要为它特定一张图片，不然即使图片在 iPhoneX 上不变形，图片所占的高度会太小，或者顶部被刘海遮挡内容而不美观。
```Swift
var adViewHeight = (1040 / 720) * screenWidth
var imageName = "start_page"
if UIDevice.isiPhoneX() {
adViewHeight = (1920 / 1124) * screenWidth
imageName = "start_page_x"
}
```
上面判断是否为 iPhoneX 我是在 UIDevice 里扩展了一个方法：
```Swfit
extension UIDevice {
public static func isiPhoneX() -> Bool {
if UIScreen.main.bounds.height == 812 {
return true
}
return false
}
}
```
还有注意在执行销毁时调用回调方法
```Swift
let time: TimeInterval = 1.0
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
self.dismissAdView()
}
```

在 AppDelegate 中 didFinishLaunchingWithOptions 方法中调用下面的 setUpWindowAndRootView() 来管理页面展示
```Swift
extension AppDelegate {

func setUpWindowAndRootView() {
window = UIWindow(frame: UIScreen.main.bounds)
window!.backgroundColor = UIColor.white
window!.makeKeyAndVisible()

let adVC = AdViewController()
adVC.completion = {
let vc = ViewController()
vc.adView = adVC.view
self.window!.rootViewController = vc
}
window!.rootViewController = adVC
}
}
```
注意在 AdViewController 销毁的回调方法中，将 AdViewController 的 view 传给真正的首页，让首页来执行动画
```Swift
adVC.completion = {
let vc = ViewController()
// 将 AdViewController 的 view 传给真正的首页，让首页来执行动画
vc.adView = adVC.view
self.window!.rootViewController = vc
}
```

在首页 ViewController 里我们有如下方法来执行 AdViewController 的销毁动画，这里配置的动画是常见的扩大渐变消失
```Swift
private var advertiseView: UIView?
var adView: UIView? {
didSet {
advertiseView = adView!
advertiseView?.frame = self.view.bounds
self.view.addSubview(advertiseView!)
UIView.animate(withDuration: 1.5, animations: { [weak self] in
self?.advertiseView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
self?.advertiseView?.alpha = 0
}) { [weak self] (isFinish) in
self?.advertiseView?.removeFromSuperview()
self?.advertiseView = nil
}
}
}
```

至此，一个简单的启动屏动画就完成了.
[我的博客myhanson](www.myhanson.com)
