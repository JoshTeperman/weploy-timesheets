# README

Date datatype
Time datatype
time zones

Postgres stores dates/times as UTC

Timezones to consider:
"Darwin" => "Australia/Darwin", 
"Adelaide" => "Australia/Adelaide", 
"Canberra" => "Australia/Melbourne", 
"Melbourne" => "Australia/Melbourne", 
"Sydney" => "Australia/Sydney", 
"Brisbane" => "Australia/Brisbane", 
"Hobart" => "Australia/Hobart", 

Assumptions:
Jobs start and finish on the same day, or timesheets are only recorded for work that day
7am - 7pm means 7:00pm inclusive (therefore 7:00am is max_rate, as is 7:00pm)

Solving Amount calculation 
Attempt 1: 

if else / case hell:

if start_time is before min_rate_start
  if end_time is also before min_rate start
    then the total is end_time - start_time * min_rate
  else if end_time is after min_rate end_time
    then total is end time - min_rate_end * min_rate
    plus min_rate start_time - start_time * min_rate
    plus total max_rate time * min_rate
  else (end_time is during max_rate time)
    then total is end_time - min_rate_start * max_rate
    plus min_rate_start - start_time * min_rate
  end
else if start_time is after min_rate start && start_time is also after max_rate end
  then the total is end_time - start_time * min_rate
else (start_time is during max_rate time)
  if end_time is before min_rate end
    then the total is end_time - start_time * max_rate
  else (end_time is after min_rate_end)
    then the total is end_time - min_rate_end * min_rate
    plus min_rate_end - start_time * max_rate
  end
end

case start_time
when start_time is before min_rate_start
  case end_time
  when end_time is also before min_rate start
    then the total is end_time - start_time * min_rate
  when end_time is after min_rate end_time
    then total is end time - min_rate_end * min_rate
    plus min_rate start_time - start_time * min_rate
    plus total max_rate time * min_rate
  else (end_time is during max_rate time)
    then total is end_time - min_rate_start * max_rate
    plus min_rate_start - start_time * min_rate
  end
when start_time is after min_rate start && also after max_rate end
  then the total is end_time - start_time * min_rate
else (start_time is during max_rate time)
  case end_time
  when end_time is before min_rate end
    then the total is end_time - start_time * max_rate
  else (end_time is after min_rate_end)
    then the total is end_time - min_rate_end * min_rate
    plus min_rate_end - start_time * max_rate
  end
end
    

    
Attempt 2:
Intersection

For example Mon, Wed, Fri
Between 7am and 7pm, rate is $22 / hour
Otherwise, the rate is $33 / hour

If we think of our timesheet start_time and end_time as a Set of numbers, where each number is a unit of time in the range (12:00..11:59)
`day = Set.new( [(12:00..11:59)] )`
If we think of the max-rate range as another set:
`min_rate_set = Set.new( [(7:00..19:00)] )`
max_rate_set = day - max_rate

Then we we have a new Timesheet:
`timesheet = Set.new( timesheet_range )`
... we can check the overlapping sections of that timesheet with our max_rate and min_rate ranges:
min_overlap = timesheet.intersection(min_rate_set)

... and return the the salary value for each range:

total_min = min_overlap.length * min_rate
total_max = max_overlap.length * max_rate

total_timesheet_amount = total_min + total_max

pros: 
Don't have to worry about decision trees or control flow to check whether a timesheet should be calculated using min_rate, max_rate, or both. Just compare the timesheet with the relavent set and return the overlapping units of time * relavent rate.
Less code.
Should be fairly fast - Set's provide the useability of arrays with the speed gains of hashes

cons:
A little more obscure, not as easy to understand what's going on at first glance
Not sure of the performance cost of rang -> array -> set conversion, Set class methods (.length on a Set, for example)

Rate class with base_rate and overtime_rate works fairly well for base/overtime pairs, but would need to be reconfigured should there be more than two rates for a given day.
Also works fairly well assuming that rates are configured based on weekday. You could theoretically create a new rule for a one-off day (ie a holiday / Christmas etc) by saying if timesheet.date = '2019/12/26' then rate = Rate.new().

https://tosbourn.com/set-intersection-in-ruby/

TESTING:
Wasn't sure whether I should be using constants to help define my tests. I defined min_rate, max_rate and start & end_times in my tests to calculate the expected answer, then let my actual code produce results that I could test. I thought this would help me test the code itself rather than risk false positives from errors being replicated in my tests. However at the same time It led to a lot of additional repeated code, and changing constants like RateSchema instances would require a lot of changes in my tests as well. 

EXTENDING:
Error Handling:
- minimum timesheet of 5 minutes?
- handle overlapping days

add option for different Australian timezones
- drop down
- default timezone set to Melbourne in config, but should be able to override it depending on input from user.

Incorporating Rubocop
Rails scaffolded files throw a bunch of Rubocop offenses. Too much noise, no signal. 
Need to learn more about how to configure Rubocop work with Rails.

time_select
date_select
with strong_params
https://stackoverflow.com/questions/3677531/separate-date-and-time-form-fields-in-rails



# TODO: it 'can handle different timezones'
# TODO: it 'handles incorrect datatypes correctly'

# TODO: allow user to fix errors and try again (without page refreshing) - take params and render with params
# TODO: display all timesheets as expected
# TODO: how to test views render as expected: https://relishapp.com/rspec/rspec-rails/v/2-0/docs/view-specs/view-spec
# TODO: display date in readable format
# TODO: display start_time and end_time in readable format

# ! additional optional CRUD:
# TODO: get all timesheets
# TODO: get single timesheet
# TODO: edit timesheet
# TODO: delete timesheet