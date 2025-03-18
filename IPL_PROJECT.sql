use project;

-- Q1. What are the top 5 players with the most players of the match awards?

select player_of_match,count(*) as awards_count
from project.matches group by player_of_match
order by awards_count desc
limit 5;

-- Q2. How many mathes were won by each team in each season?

select season,winner as team,count(*) as mathches_won
from project.matches group by season,winner;

-- Q3. What is the average strike rate of batsman in the IPL dataset?

select avg(strike_rate) as average_strike_rate
from(
select batsman,(sum(total_runs)/count(ball))*100 as strike_rate
from project.deliveries group by batsman)as batsman_stats;

select batsman,(sum(total_runs)/count(ball))*100 as strike_rate
from project.deliveries group by batsman;



-- Q4. What is number of matches won by team batting first versus batting second?

select batting_first, count(*) as mathes_won 
from(
select case when win_by_runs>0 then team1
else team2
end as batting_first
from project.matches
where winner!="tie") as batting_first_teams
group by batting_first;

-- Q5. Which batsman has the highest strike rate(minimum 200 runs scored)?

select batsman,(sum(batsman_runs)*100/count(*))
as strike_rate
from project.deliveries group by batsman
having sum(batsman_runs)>=200
order by strike_rate desc
limit 1;

-- Q6. HOW MANY TIMES HAS EACH BATSMAN BEEN DISMISSED BY THE BOWLER 'MALINGA'?

select batsman,count(*) as total_dismissals
from project.deliveries 
where player_dismissed is not null 
and bowler='SL Malinga'
group by batsman;

-- Q7. WHAT IS THE AVERAGE PERCENTAGE OF BOUNDARIES (FOURS AND SIXESCOMBINED) HIT BY EACH BATSMAN?

select batsman,avg(case when batsman_runs=4 or batsman_runs=6
then 1 else 0 end)*100 as average_boundaries
from deliveries group by batsman;

-- Q8. WHAT IS THE AVERAGE NUMBER OF BOUNDARIES HIT BY EACH TEAM IN EACH SEASON?

select season,batting_team,avg(fours+sixes) as average_boundaries
from(select season,match_id,batting_team,
sum(case when batsman_runs=4 then 1 else 0 end)as fours,
sum(case when batsman_runs=6 then 1 else 0 end) as sixes
from deliveries,matches 
where deliveries.match_id=matches.id
group by season,match_id,batting_team) as team_boundaries
group by season,batting_team;

-- Q9. WHAT IS THE HIGHEST PARTNERSHIP (RUNS) FOR EACH TEAM IN EACH SEASON?

select season,batting_team,max(total_runs) as highest_partnership
from(select season,batting_team,partnership,sum(total_runs) as total_runs
from(select season,match_id,batting_team,'over',
sum(batsman_runs) as partnership,sum(batsman_runs)+sum(extra_runs) as total_runs
from deliveries,matches where deliveries.match_id=matches.id
group by season,match_id,batting_team,'over') as team_scores
group by season,batting_team,partnership) as highest_partnership
group by season,batting_team; 

-- Q10. HOW MANY EXTRAS (WIDES & NO-BALLS) WERE BOWLED BY EACH TEAM IN EACH MATCH?

select m.id as match_no,d.bowling_team,
sum(d.extra_runs) as extras
from matches as m
join deliveries as d on d.match_id=m.id
where extra_runs>0
group by m.id,d.bowling_team;

-- Q11. WHICH BOWLER HAS THE BEST BOWLING FIGURES (MOST WICKETS TAKEN) IN A SINGLEMATCH?

select m.id as match_no,d.bowler,count(*) as wickets_taken
from matches as m
join deliveries as d on d.match_id=m.id
where d.player_dismissed is not null
group by m.id,d.bowler
order by wickets_taken desc
limit 1;

-- Q12. HOW MANY MATCHES RESULTED IN A WIN FOR EACH TEAM IN EACH CITY?

select m.city,case when m.team1=m.winner then m.team1
when m.team2=m.winner then m.team2
else 'draw'
end as winning_team,
count(*) as wins
from matches as m
join deliveries as d on d.match_id=m.id
where m.result!='Tie'
group by m.city,winning_team;

-- Q13. HOW MANY TIMES DID EACH TEAM WIN THE TOSS IN EACH SEASON?


select season,toss_winner,count(*) as toss_wins
from matches group by season,toss_winner;

-- Q14. HOW MANY MATCHES DID EACH PLAYER WIN THE "PLAYER OF THE MATCH" AWARD?

select player_of_match,count(*) as total_wins
from matches 
where player_of_match is not null
group by player_of_match
order by total_wins desc;

-- Q15. WHAT IS THE AVERAGE NUMBER OF RUNS SCORED IN EACH OVER OF THE INNINGS IN EACH MATCH?

select m.id,d.inning,d.over,
avg(d.total_runs) as average_runs_per_over
from matches as m
join deliveries as d on d.match_id=m.id
group by m.id,d.inning,d.over;

-- Q16. WHICH TEAM HAS THE HIGHEST TOTAL SCORE IN A SINGLE MATCH?

select m.season,m.id as match_no,d.batting_team,
sum(d.total_runs) as total_score
from matches as m
join deliveries as d on d.match_id=m.id
group by m.season,m.id,d.batting_team
order by total_score desc
limit 1;

-- Q17. WHICH BATSMAN HAS SCORED THE MOST RUNS IN A SINGLE MATCH?

select m.season,m.id as match_no,d.batsman,
sum(d.batsman_runs) as total_runs
from matches as m
join deliveries as d on d.match_id=m.id
group by m.season,m.id,d.batsman
order by total_runs desc
limit 1;






