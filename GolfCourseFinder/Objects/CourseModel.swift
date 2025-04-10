//
//  Item.swift
//  GolfCourseFinder
//
//  Created by Hans Heidmann on 4/10/25.
//

import Foundation
import SwiftData

@Model
final class CourseModel {
    var id: Int
    var clubName: String
    var courseName: String
    var address: String

    init(id: Int, clubName: String, courseName: String, address: String) {
        self.id = id
        self.clubName = clubName
        self.courseName = courseName
        self.address = address
    }
}



/*servers:
 - url: https://api.golfcourseapi.com/
paths:
 /v1/search:
   get:
     summary: Search for a golf course
     description: >
       This endpoint allows clients to search for a golf course based on
       either the course name or the club name. (The service will return
       the most relevant matches first.)
     security:
       - ApiKeyAuth: []
     operationId: getCoursesBySearch
     parameters:
       - in: query
         name: search_query
         required: true
         description: The search term used to retrieve a given golf course or golf club.
         schema:
           type: string
           example: pinehurst
     responses:
       '200':
         description: Successful get request
         content:
           application/json:
             schema:
               $ref: '#/components/schemas/CourseSearch'
       '401':
         $ref:  '#/components/responses/UnauthorizedError'
 
 
 Course:
   type: object
   properties:
     id:
       type: integer
       format: int64
       example: 99
     club_name:
       type: string
       example: Murray Golf Club
     course_name:
       type: string
       example: Course No. 1
     location:
       type: object
       properties:
         address:
           type: string
           example: 124 Golf Course Lane, Murray, KY 42071, USA
         city:
           type: string
           example: Murray
         state:
           type: string
           example: KY
         country:
           type: string
           example: United States
         latitude:
           type: number
           format: float
           example: 39.621742
         longitude:
           type: number
           format: float
           example: -80.34734
     tees:
       type: object
       properties:
         female:
           type: array
           items:
             $ref: '#/components/schemas/TeeBox'
         male:
           type: array
           items:
             $ref: '#/components/schemas/TeeBox'
 CourseSearch:
   type: object
   properties:
     courses:
       type: array
       items:
         $ref: '#/components/schemas/Course'
       example:
         - id: 34
           club_name: Lubbock Country Club
           course_name: Lubbock Country Club
           location:
             address: 124 Golf Course Lane, Murray, KY 42071, USA
 TeeBox:
   type: object
   properties:
     tee_name:
       type: string
       example: Blue
     course_rating:
       type: number
       format: float
       example: 75.7
     slope_rating:
       type: integer
       example: 132
     bogey_rating:
       type: number
       format: float
       example: 106.7
     total_yards:
       type: integer
       example: 6348
     total_meters:
       type: integer
       example: 5805
     number_of_holes:
       type: integer
       example: 18
     par_total:
       type: integer
       example: 73
     front_course_rating:
       type: number
       format: float
       example: 37.6
     front_slope_rating:
       type: integer
       example: 134
     front_bogey_rating:
       type: number
       format: float
       example: 53.4
     back_course_rating:
       type: number
       format: float
       example: 38.1
     back_slope_rating:
       type: integer
       example: 129
     back_bogey_rating:
       type: number
       format: float
       example: 53.3
     holes:
       $ref: '#/components/schemas/ArrayOfHoles'
 ArrayOfHoles:
   type: array
   items:
     type: object
     properties:
       par:
         type: integer
       yardage:
         type: integer
       handicap:
         type: integer
   example:
     - par: 4
       yardage: 484
       handicap: 9
     - par: 3
       yardage: 189
       handicap: 17
     - par: 5
       yardage: 587
       handicap: 2
     - par: 4
       yardage: 484
       handicap: 9
     - par: 3
       yardage: 189
       handicap: 17
     - par: 5
       yardage: 587
       handicap: 2
     - par: 4
       yardage: 484
       handicap: 9
     - par: 3
       yardage: 189
       handicap: 17
     - par: 5
       yardage: 587
       handicap: 2
 RegisterForm:
   type: object
   properties:
     email:
       type: string
   example:
     email: joesmith@gmail.com
 ActivatePayload:
   type: object
   properties:
     email:
       type: string
   example:
     token: L57K6IY7WLMF76K6ZN3AENZ7YM
 Metadata:
   type: object
   properties:
     current_page:
       type: integer
     page_size:
       type: integer
     first_page:
       type: integer
     last_page:
       type: integer
     total_records:
       type: integer
responses:
 UnauthorizedError:
   description: API key is missing or invalid
   headers:
     WWW-Authenticate:
       schema:
         type: string
         example: Key
   content:
     application/json:
       schema:
         type: object
         properties:
           error:
             type: string
             example: API key is missing or invalid
   
        
 */
