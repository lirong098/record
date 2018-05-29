wrk.method = "POST"
wrk.headers["Content-Type"] = "application/json;charset=UTF-8"
wrk.headers["src"] = "test"
wrk.headers["userType"] = "1"
-- wrk.headers["userId"] = "1"..math.random(100)
wrk.headers["userId"] = "123"
wrk.body = '{ "timeZone": "+8", "studentId": 350692, "instrumentType": 1, "beginTimeStr": "2018-05-30", "beginTime": 1527609600, "classTime": [{ "classStartTime": "15:00", "classTimeType": 1, "dayOfWeek": 3, "g8t": "3-15:00", "time": 900 }] }'
`wrk.path  = "/guarder/v1/fixedClass/teacherList"

-- https://guarder-v1-pre.peilian.com/guarder/v1/fixedClass/teacherList

-- wrk -t 4 -c 500 -d 30s -s teacherList.lua http://guarder-v1-pre.peilian.com


