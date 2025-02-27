import Foundation
import AudioToolbox.AudioServices

// 'Peek' feedback (weak boom)
let vibPeek = SystemSoundID(1519)
// 'Pop' feedback (strong boom)
let vibPop = SystemSoundID(1520)
// 'Cancelled' feedback (three sequential weak booms)
let vibCancelled = SystemSoundID(1521)
// 'Try Again' feedback (week boom then strong boom)
let vibTryAgain = SystemSoundID(1102)
// 'Failed' feedback (three sequential strong booms)
let vibFailed = SystemSoundID(1107)

let colorYellow = hexStringToUIColor(hex:"FFC400")
let colorGreen = hexStringToUIColor(hex:"4AD863")
let colorRed = hexStringToUIColor(hex:"FF6060")
var colorGray = hexStringToUIColor(hex:"A4A4A4")
var colorPoint = hexStringToUIColor(hex:"FFDC67")
var colorLightBackground = hexStringToUIColor(hex:"252B53")
var colorDeepBackground = hexStringToUIColor(hex:"0B102F")
var colorText = hexStringToUIColor(hex:"FFFFFF")

let deviceCategory: Int = UIDevice.current.value(forKey: "_feedbackSupportLevel")! as! Int

let snackBarWaitTime = 6.0
protocol Control2VCDelegate {
    func sendData(data:Int)
}
protocol VC2ControlDelegate {
    func sendData(data:Int)
}

let notched_display_height: [Int] = [2436, 2688, 1792]

func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
}


func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func dateToDayConverter(date: Date) -> Day{
    let initFormatter = DateFormatter()
    initFormatter.dateFormat = "d"
    let day = initFormatter.string(from: date)
    initFormatter.dateFormat = "M"
    let month = initFormatter.string(from: date)
    initFormatter.dateFormat = "yyyy"
    let year = initFormatter.string(from: date)
    
    return Day(year: NumberFormatter().number(from: year)!.intValue, month: NumberFormatter().number(from: month)!.intValue, day: NumberFormatter().number(from: day)!.intValue)
}

func dateToMonthConverter(date: Date) -> Day{
    let initFormatter = DateFormatter()
    initFormatter.dateFormat = "M"
    let month = initFormatter.string(from: date)
    initFormatter.dateFormat = "yyyy"
    let year = initFormatter.string(from: date)
    
    return Day(year: NumberFormatter().number(from: year)!.intValue, month: NumberFormatter().number(from: month)!.intValue, day:nil)
}

var isLastMonth = 0
var monthmonth = dateToMonthConverter(date: Calendar.current.date(byAdding: .month, value: isLastMonth, to: Date())!)

func setSucceededLastMonth(){
    let tempMonth = dateToMonthConverter(date: Calendar.current.date(byAdding: .month, value: -1, to: Date())!)
    var isEnabled:[Int] = []
    if(isDaysOfMonthEnabled(month: tempMonth)){
        isEnabled.append(0)
    }
    if(isStreakOfMonthEnabled(month: tempMonth)){
        isEnabled.append(1)
    }
    if(isCurrentExpenseEnabled(month: tempMonth)){
        isEnabled.append(2)
    }
    if(isCaloriesOfMonthEnabled(month: tempMonth)){
        isEnabled.append(3)
    }
    
    var i = 0
    var goalValue:[Float] = []
    for item in isEnabled{
        switch item {
        case 0 :
            if(isDaysOfMonthEnabled(month: tempMonth)){
                goalValue.append(Float(getDaysOfMonthStatus(month: tempMonth)) / Float(getDaysOfMonthLimit(month: tempMonth)))
            }
        case 1 :
            if(isStreakOfMonthEnabled(month: tempMonth)){
                goalValue.append(Float(getStreakOfMonthStatus(month: tempMonth)) / Float(getStreakOfMonthLimit(month: tempMonth)))
            }
        case 2 :
            if(isCurrentExpenseEnabled(month: tempMonth)){
                goalValue.append(Float(getCurrentExpenseStatus(month: tempMonth)) / Float(getCurrentExpenseLimit(month: tempMonth)))
            }
        case 3 :
            if(isCaloriesOfMonthEnabled(month: tempMonth)){
                goalValue.append(Float(getCaloriesOfMonthStatus(month: tempMonth)) / Float(getCaloriesOfMonthLimit(month: tempMonth)))
            }
        default :
            defaultSwitch()
        }
        i += 1
    }
    for item in goalValue{
        if item > 1.0{
            userSetting.succeededLastMonth = false
            userSetting.adIsOff = false
            break
        }
        else{
            userSetting.succeededLastMonth = true
        }
    }
}

func firstLaunchAction(){
    print("///first launch")
    setFavouriteSul(index: 2, set: true)
    setFavouriteSul(index: 0, set: true)
    
    snackBar(string: "술케줄에 오신 것을 환영합니다!", buttonPlaced: false)
}

func firstMonthLaunchAction(){
    transferGoalFromLastRecordMonth()
}

func snackBar(string: String, buttonPlaced: Bool){
    if(rootViewDelegate?.isSnackBarOpen() ?? false){
        rootViewDelegate?.hideSnackBar(animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) {
            rootViewDelegate?.showSnackBar(string: string, buttonPlaced: buttonPlaced, animated: true)
        }
    }
    else{
        rootViewDelegate?.showSnackBar(string: string, buttonPlaced: buttonPlaced, animated: true)
    }
}

func defaultSwitch(){
    print("///Not Accepted Switch Value")
}

extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let section = self.numberOfSections
        if section > 0 {
            let row = self.numberOfRows(inSection: section - 1)
            if row > 0 {
                self.scrollToRow(at: NSIndexPath(row: row - 1, section: section - 1) as IndexPath, at: .bottom, animated: animated)
            }
        }
    }
    func scrollToTop(animated: Bool = true) {
        let indexPath = NSIndexPath(row: NSNotFound, section: 0)
        self.scrollToRow(at: indexPath as IndexPath, at: .top, animated: animated)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class NoEditUITextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)){
            return false
        }
        if action == #selector(UIResponderStandardEditActions.cut(_:)){
            return false
        }
        if action == #selector(UIResponderStandardEditActions.delete(_:)){
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect(x: 0, y: 0, width: 0, height: 0)
    }
}
