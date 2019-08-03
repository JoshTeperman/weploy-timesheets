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


EXTENDING:

extract Rates / Days of the week into a Helper Class
.. you should be able to create a new schema for rates for a particular day of the week:
eg: 
new Rate( 
  day: 'Monday',
  min_rate: {
    start_time: Times.zone.parse('7:00')
    end_time: Times.zone.parse('19:00')
  }  
)
.. or something

add option for different Australian timezones
- drop down
- default timezone set to Melbourne in config, but should be able to override it depending on input from user.