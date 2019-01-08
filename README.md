## Discovering how ethnicity impacts higher education and beyond. 

Authors: Socorro Dominguez (sedv8808), Sarah Watts (smwatts)

### Milestone 1

#### Overview

Many people value higher education for an unlimited number of reasons: Some link it to becoming able to solve problems, others to learning how to work with different kinds of people, and some others think it will teach them how to handle real life tasks. It has also been considered an asset to have in order to pursue a more lucrative career with a better salary. These monetary benefits might allow a person to increase their living condition or to step out of poverty. 

There are different kinds of postsecondary institution throughout the United States that offer a wide range of programs. However, some people might face more challenges than others in order to enter higher education. To understand these challenges, and to see if there are groups or minorities that tend to be more marginalized, we are proposing to build an app that can help us track which social groups tend to be more hindered when entering a postsecondary institution. This could either be because of race, gender, or average income level. We would also like to see how entering a specific postsecondary institution benefits an individual overall in their future life.

The College Scorecard Project gives us information to compare how well postsecondary institutions prepare their students in order to be successful. We can compare the cost of education and how many graduates are working even several years after entry in the institution. 

#### Description of the data

The data available from this website covers a wide range of topics. The following is just a general overview of this categories and as the app is in development, we will just keep the variables that we need: 
-	Root:  Basic information in the data set.
  o	Different IDs for each school.

-	School: Basic descriptive information about the school in question.
  o	Name
  o	City
  o	State Postcode

-	Student: Items that identify demographic and other details about the student body of the school.
  o	Undergraduate Student Body by Race/Ethnicity
  o	Undergraduate Students by Part-Time status
  o	Marital Status
  o	Income Brackets of Federal Financial Aid Recipients,
  o	Gender
  o	Age at entry
  o	Veteran status

-	Aid: Financial aid can provide an important look at how much debt students take on to attend the college, the share of students who receive federal grants and loans to help pay for college, and how much the typical student can expect to owe each month after graduating.
  o	Share of students who received a federal loan while in school

-	Earnings: One of the most common reasons for students to go to college is the expansion of employment opportunities: 
  o	Average and Median Earnings, Disaggregated by Student Subgroups
  o	Share of Former Students Earning Over $25,000

(Missing dataset, it should be uploaded on the Github repository, but it is still missing, hence, I do not know how many observations there are.)

https://collegescorecard.ed.gov/assets/FullDataDocumentation.pdf


#### Usage scenario & tasks / question to explore

Mary is a policy maker in the Ministry of Education in the United States. She understands that getting into higher education is crucial for a wide range of young nationals in order to step out of poverty or improve their current living situation. She has empirically identified that some groups tend to be more marginalized than others and she would want to change this. She thinks that reducing costs is important. But in order to force the government to provide with more aid to possible students, she wants to prove the positive outcomes of people who have had access to higher education as a mean to improve their living situation. 

To understand and improve higher education opportunities for disadvantaged students, she needs to measure the enrollment of these groups at the different institutions and how well they currently are doing. She wants to measure by: ethnicity, gender and students within the poverty rate. 


#### Description of your app & sketch

The app contains a landing page that shows the average or count of our dataset factors (number of students, financial aid, average family income, post education income) broken down by ethnic group (white, black, asian, hispanic) in the US in bar charts. From a dropdown list, users are able to filter based on state, school and year. Users can also hover over bars in the bar charts to get the exact values for each ethnic group.

An example sketch is shown below: 
![Alt text](/milestone_1/sketch_of_college_scorecard.png?raw=true "App sketch")