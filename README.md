## Impact of School Size on Higher Education

Authors: 
[Sarah Watts](https://github.com/smwatts)
[Socorro Dominguez](https://github.com/sedv8808)

### Milestone 1

#### Overview

Many people value higher education for an unlimited number of reasons; some link it to becoming able to solve problems, others to learning how to work with different kinds of people, and others think it will teach them how to handle real life tasks. It has also been considered an asset to have in order to pursue a more lucrative career. These monetary benefits might allow a person to increase their living condition or to step out of poverty. 

However, we know that not all post-secondary institutions are created equal. Many factors contribute to the prosperity of students attending these post-secondary institutions. To narrow our focus, we decided to examine one dimension that many students ponder, what size school should I attend?

Using the data collected in the College Scorecard Project, we want to visually explore how the size of a school impacts students. We will create an app that will be used to show the distribution of factors students care about (financial aid, earning potential etc.), broken down by the size of a school. We will also allow users to explore different aspects of this data by filtering and re-ordering on different variables such as their state or admission rate that can contribute to the performance of a school size for each factor.

Our definition of school size is as follows (in terms of undergraduate students);    
Large school: 15,000 +   
Medium school: 5,000-15,000   
Small school: 0-5,000   

#### Description of the data

The data available from the College Scorecard Project covers a wide range of topics. The following is a general overview of the topics available in our dataset, as well as some sample features: 
-	Root:  Basic information in the data set.
  o	Different IDs for each school.

-	<u>School:</u> Basic descriptive information for each school.
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

-	<u>Aid:</u> Financial aid can provide an important look at how much debt students take on to attend the college. This includes the share of students who receive federal grants and how much the typical student can expect to owe each month after graduating.
  o	Share of students who received a federal loan while in school

-	<u>Earnings:</u> One of the most common reasons for students to go to college is the expansion of employment opportunities: 
  o	Average and Median Earnings, Disaggregated by Student Subgroups
  o	Share of Former Students Earning Over $25,000

A complete description of the dataset can be found here: [https://collegescorecard.ed.gov/assets/FullDataDocumentation.pdf](https://collegescorecard.ed.gov/assets/FullDataDocumentation.pdf). This dataset provides access to information for 8,000 schools and 2,000 features.

----------------------------

To begin understanding the impact of school size on different features, we have created a data cleaning script. The data cleaning script can be found in [src/01_load_and_clean_data.R](src/01_load_and_clean_data.R). This script loads the data and keeps the following variables:

- <u>UNITID:</u> Unit ID for institution [Integer]
- <u>STABBR:</u> Code of State [Character]
- <u>loan_ever:</u> Percentage of students with a loan [Float]
- <u>female:</u> Percentage of female students [Float]
- <u>age_entry:</u> Age at which students start school [Float]
- <u>md_faminc:</u> Medium family income [Float]
- <u>md_earn_wne_p10:</u> Medium wage 10 years after entry [Float]

In the next iteration of this script, we will add in the following features, creating a complete set of features for our app:

- <u>UNITID:</u> Unit ID for institution [Integer]
- <u>UGDS: </u> Enrollment of all undergraduate students [Integer]
- <u>ADM_RATE: </u> Admission rate [Float]

#### Usage scenario & tasks / question to explore

<u>**Scenario I:**</u><br>
Sage is a high school counselor who helps high school students pursue higher education in several states. She wants to help students navigate post-secondary education. This includes helping students understand what size school is right for them. Using factors such as the student's academic standing and the state they want to attend post-secondary school in, she would like to understand how soci-economic factors change via school choice.

<u>**Scenario II:**</u><br>
Mary is a policy maker in the Ministry of Education in the United States. She wants to understand the impact that school size has on many soci-economic factors for Americans. Specifically, she would like to know where she needs to focus resources for the highest payoff. Are the small schools in California suffering on metrics that larger schools are excelling in? She can work towards establishing programs that put more resources towards supporting these smaller schools.


#### Description of your app & sketch

The app contains a landing page that shows the distribution of our factors (financial aid, average family income, post education income) in the US, aggregated by school size (small, medium, large). 

From a dropdown list, users are able to filter for a particular state of interest. They are also able to filter by the average admission rate score per school, to get an understanding of how the academic standard of a school varies performance of our factors by school size.

An example sketch is shown below: 
![Alt text](images/sketch_of_college_scorecard.png?raw=true "App sketch")
