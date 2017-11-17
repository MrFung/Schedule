//
//  SetWeekViewController.swift
//  EasySchedule
//
//  Created by 应吕鹏 on 16/4/20.
//  Copyright © 2016年 应吕鹏. All rights reserved.
//

import UIKit

protocol SetWeekViewControllerDelegate {
  func didSetWeek(_ week:[Int])
}

class SetWeekViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
  @IBOutlet weak var weekCV: UICollectionView!
  var selectedWeek:[Int] = Array.init(repeating: 0, count: 25)
  let selecedColor = UIColor(red: 128/288, green: 169/255, blue: 1/255, alpha: 1)
  let unselectedColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
  var layView:UIView?
  var delegate:SetWeekViewControllerDelegate?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.modalPresentationStyle = .overFullScreen
    self.view.backgroundColor = UIColor.clear
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    layView = UIView(frame: CGRect(x: 0,y: 0,width: SCREEN_WIDTH,height: SCREEN_HEIGHT-240))
    layView?.backgroundColor = UIColor.black
    layView?.alpha = 0.2
    self.view.addSubview(layView!)
    let tap = UITapGestureRecognizer(target: self, action: #selector(SetWeekViewController.cancle))
    layView?.addGestureRecognizer(tap)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: - UICollectionViewDataSource
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 25
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekCell", for: indexPath) as! SetWeekCell
    cell.weekNumLabel.text = "\(indexPath.row + 1)"
    return cell
    
  }
  
  //MARK: - UICollectionViewDelegate
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let currentCell = collectionView.cellForItem(at: indexPath) as! SetWeekCell
    if !currentCell.choosen {
      currentCell.contentView.backgroundColor = selecedColor
      self.selectedWeek[indexPath.row] = 1
    }else{
      currentCell.contentView.backgroundColor = unselectedColor
      self.selectedWeek[indexPath.row] = 0
    }
    currentCell.choosen = !currentCell.choosen
  }
  
  //MARK: - UICollectionViewDelegateFlowLayout
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height:CGFloat = collectionView.frame.size.height/5
    let width = collectionView.frame.size.width/5
    return CGSize(width: width, height: height)
  }
  //MARK - Custom Function
  @IBAction func doneBtnClicked(_ sender: AnyObject) {
    self.delegate?.didSetWeek(self.selectedWeek)
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc func cancle(){
    self.layView?.isHidden = true
    self.dismiss(animated: true, completion: nil)
  }
  
}

