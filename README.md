# NFL_Kaggle_Bowl
A look at NFL Special teams
This study developed from a phone call from my old black belt instructor.   The 2022 NFL Kaggle bowl
promised a $100K prize for the best insights into special teams.   I chose to ignore the obvious player
bio-metrics on performance, and chose to look at clusters of players set up to return, and defend, punts and 
kickoffs.   NFL Next Gen Stats provided wonderful, clean data in CSV format, so data cleanup was not an issue.
Each special team play was logged for 4 or 5 seasons, with kick length, return yardage, blockers, etc. 
With help from the NFL folks, I was able to hack an existing animation, complete with little players and a tiny 
football moving down the field, in R.    Tweaking the player line of scrimmage set ups between the hashmarks, I 
saw that there were several configurations of tackles and blockers that suggested a short return.    On-side and 
squibbed (muffed) kicks were dicarded.   Not suprisingly, longer kicks (into endzone excluded) resulted in shorter 
returns, as the kicking team has more time to get downfield.   More subtle was the setup of the gunners, the players
designated to tackle the returner.    Using the animation tool rather than quantitative analysis, I was able to simulate
some optimal configurations for the gunners and blockers for the kicking team.    A screen snip of the animation 
is included. 
Unfortunately, two of my other group members backed out of the competition due to work/school conflicts, and we
were not able to take it further.   I miss that $100k prize.....
