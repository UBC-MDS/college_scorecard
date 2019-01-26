## Impact of School Size on Higher Education

Authors: <br>
[Sarah Watts](https://github.com/smwatts)   
[Socorro Dominguez](https://github.com/sedv8808)

### Milestone 3

Our deployed Shiny App can be found [here](https://sedv8808.shinyapps.io/College_scorecard/)

## Feedback links:

I. We talked to Simran and Sreya about their wine app. 
Our feedback can be found [here](https://github.com/UBC-MDS/DSCI-532-wine-data/issues/14).

II. We also talked to Hayley and Tony about their Boston crime Shiny app.
Our feedback can be found [here](https://github.com/UBC-MDS/DSCI_532-boston-crime-rate/issues/27).



## Reflection on the usefulness of the feedback we received.

During the feedback session, we think our peers did not have a lot of difficulty handling our app. Most of them reported liking the plots and how easy it was to interact with them. A suggestion we received was to include the `data table` and to be able to select the `school size` in a checkbox input rather than a tab input. Widgets were implemented to be able to do Multiselect on `school size`. 

We explained to our users that in our scenarios, we want to be able to suggest schools. We were reminded that although some people might just want to consider schools from one state, others might be interested in multiple states. We hadn't thought about this. However, this new feature was implemented.

Some of the graphs seem to not have had correct labels or label ticks. These were formatted for user readability.


There are some improvements that we are considering making:

- Remove the y-axis for the "school count" and just display the count on top of the bar. We don't want it to look like an eligible box. 

- We found a bug: When there is only 1 school (or no schools) according to the user's selection, the distribution plots cannot be made. We would want to implement an error message when there is too little information to provide a distribution plot. Ideally, we should give back a graph with value 0 or a message that there is not enough information to display that selection.

It was really good to have two teams to observe and rate our app so we could understand what we needed to improve. We heard new ideas and it was easier to see some details that made the app less user friendly. We think this helped us improve our app.

Design improvements that were implemented thanks to the received feedback:
* The scale for percentage values has been changed
* The y-axis for the charts with distributions has been removed
* Titles have been changed to be more descriptive (i.e. Distribution of xyz..)
* A theme has been applied to the dashboard look more visually appealing.
* A dropdown widget to have multiple selection for the states.
* More descriptive naming has been added to the admission rate range filter.
* Full name of the different states.
* The school size is now a multi-select option for users.
* The tabs now include a table that alphabetically lists the schools and their attributes for a particular set of features.

## Wishlist
* Display message when there is not enough information to draw the plots.
* Distribution plots are grouped by school size. Write a new function to make code more efficient.


[Milestone 2](https://github.com/UBC-MDS/college_scorecard/releases/tag/V2.0)
[Proposal Release](https://github.com/UBC-MDS/college_scorecard/releases/tag/V1.0)
