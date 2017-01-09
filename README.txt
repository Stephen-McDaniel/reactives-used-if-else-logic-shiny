# 2017-01-09 in response to Google Groups thread by mattek
Response from Stephen McDaniel at PowerTrip Analytics

Topic: Shiny, using inputs in if else logic checks and triggering reactives

Program: app.R 
   Data: randomly generated 

This should work without modification
However, if you comment out the cat() line in the dataInBoth reactive
You will see that input action button inDataGen2 is ignored once
   input inDataGen1 is used at least once
The morale of this example app is to use direct retrieval of inputs 
   to guarantee they are available for if else logic checks

![alt tag](/raw/master/images/reactives-used-if-else-logic-shiny.png)

License: MIT License
Attribution, package authors for shiny on CRAN.
