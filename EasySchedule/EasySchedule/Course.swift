//
//  Course.swift
//  EasySchedule
//
//  Created by 应吕鹏 on 16/4/17.
//  Copyright © 2016年 应吕鹏. All rights reserved.
//

import UIKit

class Course: NSObject,NSCoding {
  var courseName:String!
  var teacher:String!
  var classroom:String!
  var start:Int!
  var end:Int!
  var day:Int!
  var weekNum:[Int]!
  override init(){
    
  }
  
  func encode(with aCoder: NSCoder){
    aCoder.encode(self.courseName, forKey: "courseName")
    aCoder.encode(self.teacher, forKey: "teacher")
    aCoder.encode(self.classroom, forKey: "classroom")
    aCoder.encode(self.start, forKey: "start")
    aCoder.encode(self.end, forKey: "end")
    aCoder.encode(self.day, forKey: "day")
    aCoder.encode(self.weekNum, forKey: "weekNum")
    
  }
  required init?(coder aDecoder: NSCoder){
    super.init()
    self.courseName = aDecoder.decodeObject(forKey: "courseName") as! String
    self.teacher = aDecoder.decodeObject(forKey: "teacher") as! String
    self.classroom = aDecoder.decodeObject(forKey: "classroom") as! String
    self.start = aDecoder.decodeObject(forKey: "start") as! Int
    self.end = aDecoder.decodeObject(forKey: "end") as! Int
    self.day = aDecoder.decodeObject(forKey: "day") as! Int
    self.weekNum = aDecoder.decodeObject(forKey: "weekNum") as! [Int]
    
    
  }
}

