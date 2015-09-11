/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

private let _sharedService = RestaurantDetailService()
class RestaurantDetailService {
  class var sharedService: RestaurantDetailService {
    return _sharedService
  }
  
  lazy var restaurants: [Restaurant] = {
    let cupcakesUUID = NSUUID(UUIDString: "EC6F3659-A8B9-4434-904C-A76F788DAC43")
    //let cupcakesUUID = NSUUID(UUIDString: "3EDA0696-F41C-4768-B34E-6B9298500F22")
    let cupcakes = Restaurant(uuid: cupcakesUUID!, name: "Core Cupcakes")
    cupcakes.motdHeader = "Straight to the Core"
    cupcakes.motdBody = "Our cupcakes our foundational. We consider them to be a core part of everyone's diet. Forget about being in shape... Round is a shape too."
    cupcakes.image = UIImage(named: "Cupcakes")
    
    let saladsUUID = NSUUID(UUIDString: "7B377E4A-1641-4765-95E9-174CD05B6C79")
    //let saladsUUID = NSUUID(UUIDString: "BFCB66B8-AAF2-472E-ACAE-A0B45D3C6465")

    let salads = Restaurant(uuid: saladsUUID!, name: "@synthesize salads")
    salads.motdHeader = "Nothing Automatic About Them"
    salads.motdBody = "You might be used to things being done automatically for you lately. But here at @synthesize salads we aren't lazy and pick our ingredients from the best farming @properties in town."
    salads.image = UIImage(named: "Salad")
    
    let wrapsUUID = NSUUID(UUIDString: "2B144D35-5BA6-4010-B276-FC4D4845B292")
    let wraps = Restaurant(uuid: wrapsUUID!, name: "Weak Wraps")
    wraps.motdHeader = "Retain Cycle Guaranteed"
    wraps.motdBody = "These wraps are so good, you will wish you had used a weak reference. We guarantee you will be stuck here forever."
    wraps.image = UIImage(named: "Wrap")
    
    return [cupcakes, salads, wraps]
    }()
  
  func restaurant(withUUID: NSUUID) -> Restaurant? {
    let filteredRestaurants = restaurants.filter { r in
      r.uuid == withUUID
    }
    
    return filteredRestaurants.first
  }
}
