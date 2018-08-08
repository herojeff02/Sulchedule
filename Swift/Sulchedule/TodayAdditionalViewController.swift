//table view input
import UIKit

class TodayAdditionalViewController: UITableViewController {

    @IBOutlet var backgroundView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = colorPoint
        backgroundView.backgroundColor = colorDeepBackground
        self.tabBarController?.tabBar.backgroundColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        if(!isDarkTheme){
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        }
        else{
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        }
        backgroundView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayAdditionalIdentifier", for: indexPath)
        var flag2 = false

        guard let customCell = cell as? TodayAdditionalTableViewCell else{
            return cell
        }
        
        customCell.bottleLabel.text = "3병"
        customCell.titleLabel.text = "Dummy Data"
        if(!isDarkTheme){
            customCell.bottleLabel.textColor = .black
            customCell.titleLabel.textColor = .gray
        }
        else{
            customCell.bottleLabel.textColor = .white
            customCell.titleLabel.textColor = colorGray
        }
        customCell.contentView.backgroundColor = colorDeepBackground
        customCell.bottleStepper.tintColor = colorPoint
        
        if(isDarkTheme){
            if(flag2){
                customCell.starButtonOutlet.setImage(UIImage(named: "star_empty"), for: UIControlState())
                flag2.toggle()
            }
            else{
                customCell.starButtonOutlet.setImage(UIImage(named: "star"), for: UIControlState())
                flag2.toggle()
            }
        }
        else{
            if(flag2){
                customCell.starButtonOutlet.setImage(UIImage(named: "star_blue_empty"), for: UIControlState())
                flag2.toggle()
            }
            else{
                customCell.starButtonOutlet.setImage(UIImage(named: "star_blue"), for: UIControlState())
                flag2.toggle()
            }
        }
        
        return customCell
    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class TodayAdditionalTableViewCell: UITableViewCell {
    
    var flag = false
    
    @IBOutlet weak var starButtonOutlet: UIButton!
    @IBAction func starButtonAction(_ sender: Any) {
        if(isDarkTheme){
            if(flag){
                starButtonOutlet.setImage(UIImage(named: "star_empty"), for: UIControlState())
                flag.toggle()
            }
            else{
                starButtonOutlet.setImage(UIImage(named: "star"), for: UIControlState())
                flag.toggle()
            }
        }
        else{
            if(flag){
                starButtonOutlet.setImage(UIImage(named: "star_blue_empty"), for: UIControlState())
                flag.toggle()
            }
            else{
                starButtonOutlet.setImage(UIImage(named: "star_blue"), for: UIControlState())
                flag.toggle()
            }
        }
    }
    @IBOutlet weak var bottleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottleStepper: UIStepper!
    @IBAction func bottleStepper(_ sender: UIStepper) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if(!isDarkTheme){
            bottleStepper.tintColor = colorPoint
            bottleLabel.textColor = .black
            titleLabel.textColor = .gray
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
