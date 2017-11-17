//
//  ViewController.swift
//  EasySchedule
//
//  Created by 应吕鹏 on 16/4/16.
//  Copyright © 2016年 应吕鹏. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
let ArchiveURL = DocumentsDirectory.appendingPathComponent("courses")

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,EditCourseViewControllerDelegate {
  @IBOutlet weak var weekCV: UICollectionView!
  @IBOutlet weak var mainCV: UICollectionView!
  var showCount = 0
  var weekItems = ["周一", "周二", "周三", "周四", "周五","周六","周日"]
  var currentSelected:IndexPath?
  var imageView = UIImageView()
  
  var courseCellSize:CGSize!
  
  let courseColor = UIColor(red: 74/255, green: 187/255, blue: 230/255, alpha: 1)
  
  var courseArray = [Course]()
  var courseLabelArray = [UILabel]()
  
  lazy var editVC:EditCourseViewController = {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditCourseViewController") as! EditCourseViewController
    vc.delegate = self
    return  vc
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let bgImageView = UIImageView(frame: self.view.frame)
    bgImageView.image = UIImage(named: "bg")
    self.view.insertSubview(bgImageView, belowSubview: weekCV)
    
    weekCV.register(UINib(nibName: "WeekDayCell", bundle: nil), forCellWithReuseIdentifier: "WeekDayCell")
    mainCV.register(UINib(nibName: "WeekDayCell", bundle: nil), forCellWithReuseIdentifier: "WeekDayCell")
    mainCV.register(UINib(nibName: "CourseCell", bundle: nil), forCellWithReuseIdentifier: "CourseCell")
    
    weekCV.alpha = 0.5
    mainCV.alpha = 0.5
    self.automaticallyAdjustsScrollViewInsets = false
    mainCV.reloadData()
    loadCourse()
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if showCount == 0{
      for courseItem in self.courseArray {
        drawCourse(courseItem)
      }
      self.showCount += 1
    }
    
    
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: - UICollectionViewDataSource
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    var number = 0
    if collectionView == self.weekCV{
      number = 1
    }else if collectionView == self.mainCV {
      number = 1
    }
    return number
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == self.weekCV {
      return weekItems.count + 1
    }else if collectionView == self.mainCV {
      return ( (self.weekItems.count+1) * 12 )
    }
    return 0
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    
    if collectionView == self.weekCV {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCell", for: indexPath) as! WeekDayCell
      
      if indexPath.row == 0 {
        cell.dayLabel.text = ""
      }else{
        cell.dayLabel.text = self.weekItems[indexPath.row-1]
        
      }
      return cell
      
    }else {
      if indexPath.row % 8 == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCell", for: indexPath) as! WeekDayCell
        cell.dayLabel.text = "\(indexPath.row / (self.weekItems.count + 1) + 1)"
        return cell
      }else{
        let courseCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseCell", for: indexPath) as! CourseCell
        courseCell.courseLabel.text = ""
        return courseCell
      }
      
    }
    
    
    
  }
  
  //MARK: - UICollectionViewDelegateFlowLayout
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == self.weekCV {
      if (indexPath.row == 0) {
        return CGSize(width: 30, height: 30)
      }
      else
      {
        return CGSize(width: (SCREEN_WIDTH - 30) / 7, height: 30)
      }
      
    }else if collectionView == self.mainCV {
      let rowHeight = CGFloat((SCREEN_HEIGHT - 64  - 30)/12)
      if (indexPath.row % 8 == 0) {
        return CGSize(width: 30, height: rowHeight)
      }
      else
      {
        self.courseCellSize = CGSize(width: (SCREEN_WIDTH - 30) / 7, height: rowHeight)
        return self.courseCellSize
      }
      
    }
    
    return CGSize(width: 0, height: 0)
  }
  
  
  //MARK: - UICollectionViewDelegate
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == self.mainCV && indexPath.row % (self.weekItems.count + 1) != 0{
      var cell:CourseCell?
      if let currentSelected = currentSelected {
        cell = collectionView.cellForItem(at: currentSelected) as? CourseCell
        cell?.contentView.backgroundColor = UIColor.clear
        for item in cell!.contentView.subviews { item.removeFromSuperview() }
      }
      //点击出现加号
      self.currentSelected = indexPath
      cell = collectionView.cellForItem(at: currentSelected!) as? CourseCell
      cell?.contentView.backgroundColor = UIColor.lightGray
      
      imageView.contentMode = .scaleAspectFit
      imageView.center = cell!.contentView.center
      imageView.bounds.size = CGSize(width: 20, height: 20)
      imageView.image = UIImage(named: "plus")
      cell?.contentView.addSubview(imageView)
      
      //为加号添加事件
      let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.addCourse))
      imageView.addGestureRecognizer(tap)
      imageView.isUserInteractionEnabled = true
      
      
    }
  }
  
  //MARK: - 自定义方法
  
  @objc func addCourse(){
    let selectedCell = self.mainCV.cellForItem(at: currentSelected!)
    self.imageView.removeFromSuperview()
    selectedCell?.contentView.backgroundColor = UIColor.clear
    currentSelected = nil
    let addCourseVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditCourseViewController") as! EditCourseViewController
    addCourseVC.delegate = self
    
    self.navigationController?.pushViewController(addCourseVC, animated: true)
  }
  
  @objc func editCourse(_ recognizer:UITapGestureRecognizer) {
    let label = recognizer.view as! UILabel
    editVC.stateTag = 1
    editVC.course = self.courseArray[label.tag]
    editVC.courseTag = label.tag
    self.navigationController?.pushViewController(editVC, animated: true)
    
  }
  func drawCourse(_ course:Course){
    //计算要画的位
    //        let index = 8*(course.start) + course.day
    //        let startRowIndexPath = NSIndexPath(forRow: index, inSection: 0)
    //
    //        let startCell = self.mainCV.cellForItemAtIndexPath(startRowIndexPath)
    
    
    let rowNum = course.end - course.start + 1
    let width = courseCellSize.width
    let height = courseCellSize.height * CGFloat(rowNum)
    let x = CGFloat(30) + CGFloat(course.day - 1 ) * courseCellSize.width
    let y = CGFloat(30 + 64) + CGFloat(course.start - 1) * courseCellSize.height
    let courseView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
    //        courseView.backgroundColor = courseColor
    courseView.alpha = 0.8
    self.view.insertSubview(courseView, aboveSubview: self.mainCV)
    
    let courseInfoLabel = UILabel(frame: CGRect(x: 0,y: 2,width: courseView.frame.size.width-2,height: courseView.frame.size.height-2))
    courseInfoLabel.numberOfLines = 5
    courseInfoLabel.font = UIFont.systemFont(ofSize: 12)
    courseInfoLabel.textAlignment = .left
    courseInfoLabel.textColor = UIColor.white
    courseInfoLabel.text = "\(course.courseName)@\(course.classroom)"
    courseInfoLabel.tag = self.courseArray.index(of: course)!
    courseInfoLabel.layer.cornerRadius = 5
    courseInfoLabel.layer.masksToBounds = true
    courseInfoLabel.backgroundColor = courseColor
    courseView.addSubview(courseInfoLabel)
    
    self.courseLabelArray.append(courseInfoLabel)
    let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.editCourse(_:)))
    
    courseInfoLabel.addGestureRecognizer(tap)
    courseInfoLabel.isUserInteractionEnabled = true
    
    
    
  }
  
  
  //MARK: - EditCourseViewControllerDelegate
  func didSetCourse(_ course: Course) {
    courseArray.append(course)
    saveCourse()
    drawCourse(course)
    
    
  }
  func didEditCourse(_ course: Course,tag:Int) {
    self.courseArray[tag] = course
    saveCourse()
    let courseLabel = self.courseLabelArray[tag]
    courseLabel.text = "\(course.courseName)@\(course.classroom)"
    self.courseArray[tag] = course
    saveCourse()
  }
  
  func didDeleteCourse(_ course:Course,tag:Int){
    let courseView = self.courseLabelArray[tag].superview
    courseView?.removeFromSuperview()
    self.courseArray.remove(at: tag)
    self.courseLabelArray.remove(at: tag)
    saveCourse()
  }
  
  
  //MARK: - 数据持久化
  func saveCourse() {
    let data = NSMutableData()
    //申明一个归档处理对象
    let archiver = NSKeyedArchiver(forWritingWith: data)
    //将lists以对应Checklist关键字进行编码
    archiver.encode(self.courseArray, forKey: "courses")
    //编码结束
    archiver.finishEncoding()
    //数据写入
    data.write(toFile: ArchiveURL.path, atomically: true)
  }
  
  func loadCourse(){
    //获取本地数据文件地址
    let path = ArchiveURL.path
    //声明文件管理器
    let defaultManager = FileManager()
    
    //通过文件地址判断数据文件是否存在
    if defaultManager.fileExists(atPath: path) {
      //读取文件数据
      let data = try? Data(contentsOf: URL(fileURLWithPath: path))
      //解码器
      let unarchiver = NSKeyedUnarchiver(forReadingWith: data!)
      //通过归档时设置的关键字Checklist还原lists
      self.courseArray = unarchiver.decodeObject(forKey: "courses") as! Array
      //结束解码
      unarchiver.finishDecoding()
      for item in courseArray {
        print(item.courseName)
      }
    }
    
  }
  
  
  
  
}

