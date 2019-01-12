## Beyond education!
### Helping students choose their future!

Authors: 
[Sarah Watts](https://github.com/smwatts)
[Socorro Dominguez](https://github.com/sedv8808)


### Milestone 1

#### Overview

Many people value higher education for an unlimited number of reasons: Some link it to becoming able to solve problems, others to learning how to work with different kinds of people, and some others think it will teach them how to handle real life tasks. It has also been considered an asset to have in order to pursue a more lucrative career with a better salary. These monetary benefits might allow a person to increase their living condition or to step out of poverty. 

However, how do we choose which school will provide us with the tools that we need for the future? 

Thousands of students in the United States ask themselves this question every year. And they should be aware that there are different kinds of postsecondary institution throughout the country that offer a wide range of programs. 

Choosing the right institution is just as important as choosing the right career. Not all students start off on the same foot. Some students might require more financial aid than others depending on their families' income. Some others might be interested in the demographics of the school: what is the age of most of their to be classmates or how many females access these programs. Most students would likely be interested into looking at what their future incomes might look like if partaking into these cohorts. 

The College Scorecard Project gives us information to compare how well postsecondary institutions prepare their students in order to be successful. We can compare the cost of education and how many graduates are working even several years after entry in the institution. 

#### Description of the data

The data available from this website covers a wide range of topics. The following is just a general overview of this categories and as the app is in development, we will just keep the variables that we need: 
-	Root:  Basic information in the data set.
  o	Different IDs for each school.

-	<u>School:</u> Basic descriptive information about the school in question.
  o	Name
  o	City
  o	State Postcode

-	<u>Student:</u> Items that identify demographic and other details about the student body of the school.
  o	Undergraduate Student Body by Race/Ethnicity
  o	Undergraduate Students by Part-Time status
  o	Marital Status
  o	Income Brackets of Federal Financial Aid Recipients,
  o	Gender
  o	Age at entry
  o	Veteran status

-	<u>Aid:</u> Financial aid can provide an important look at how much debt students take on to attend the college, the share of students who receive federal grants and loans to help pay for college, and how much the typical student can expect to owe each month after graduating.
  o	Share of students who received a federal loan while in school

-	<u>Earnings:</u> One of the most common reasons for students to go to college is the expansion of employment opportunities: 
  o	Average and Median Earnings, Disaggregated by Student Subgroups
  o	Share of Former Students Earning Over $25,000

https://collegescorecard.ed.gov/assets/FullDataDocumentation.pdf

A prototype script has been written by Sarah Watts and is included in this repository. This script loads the data and keeps the following variables:

- <u>STABBR:</u> Code of State [Character]
- <u>loan_ever:</u> Percentage of students with a loan [Float]
- <u>female:</u> Percentage of female students [Float]
- <u>age_entry:</u> Age at which students start school [Float]
- <u>md_faminc:</u> Medium family income [Float]
- <u>md_earn_wne_p10:</u> Medium wage 10 years after entry [Float]

The data that we are keeping will change as the app is being developed. 
#### Usage scenario & tasks / question to explore

<u>**Scenario I:**</u><br>
Sage is a councelour who helps high school students pursue higher education in several states. From personal experience, Sage knows that it is not always possible to pursue higher education at all institutions as some are not affordable for everyone. Sages tries to help students assess their possibile choices: they should consider mostly based on their location, families' current income and if there is any financial aid or loans available. Sage would also like to provide an estimate of the expected income a student would have 10 years after entering the school. This would motivate a lot of them to purusue education even if that means to ask for a loan. 
Sage knows some students might feel scared of going back to school as they age or if they are married. Hence, an app that informs of the average entry age or marital status would also be helpful as a lot of students would realize that many people take a break between high school and higher education or go back even after marriage. Sage really believes into convincing everyone to pursue a higher education to help them achieve their dreams and improve their current financial situation - regardless of what it currently looks like.

<u>**Scenario II:**</u><br>
Mary is a policy maker in the Ministry of Education in the United States. She understands that getting into higher education is crucial for a wide range of young nationals in order to step out of poverty or improve their current living situation. She has empirically identified that females tend to be more marginalized than others and she would want to change this. She would want to show to different financial institutions that providing financial aid to females to help them pursue higher education helps them step out of poverty. She would use our app to shows what a female's family income currently looks like and how her income improves x number of years after entering college/university. That way, she would look to convince banks and schools to offer more loans, incentives, and help to females who want to purusue higher education. If successful, Mary would want to take this initiative forward to create financial aid directed to veterans or people belonging to different racial groups. 


#### Description of your app & sketch

The app contains a landing page that shows the average or count of our dataset factors (financial aid, average family income, post education income) broken down by gender and ethnic groups (white, black, asian, hispanic) in the US in bar charts. 

From a dropdown list, users are able to filter based on state, school, and family income (identify poverty rate). 

An example sketch is shown below: 
![Alt text](images/sketch_of_college_scorecard.png?raw=true "App sketch")