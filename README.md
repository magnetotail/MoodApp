# mood

A mood tracker with skill suggestions

## Todo
- add option to add entry
    - ~~stresslevel (slider 0-100)~~
    - ~~current activity (text)~~
    - ~~mood (text)~~
    - ~~round icon that changes color from green to red in intervals of 20 depending on stresslevel~~
    - rate for mood (slider 1-10)
    - ask if user wants to see skills for current stresslevel or mood rating
      - selection for timed notification
      - ask if user wants to be asked how well it worked
      - add button to mood card if skill was used to rate effectiveness
      - mood/stress was better, unchanged or worse
- skills
  - add huge list of skills to choose from 
  - option to add skills
  - choose skills to use
    - search 
    - select stresslevel multiple selection possible
      - selection for low, medium high
      - option to switch to detailed setting to select stresslevel range from 0-100
    - select moodlevel 1-10, multiple selection possible
  - View to manage selected skills
    - show how often used
    - show list of mood entries when used
    - show rating of how well it worked
- settings
    - set stresslevels
- timed notifications for new entries
- calendar representation of moods
- diagram representation of day/month
    

model:

- skill
  - id
  - name
  - description

- stresslevel
  - stresslevel_id
  - stresslevel_min
  - stresslevel_max
  
- effectiveness
  - id
  - description (better, no change, worse)

- used_skill
  - id
  - skillid
  - active
  - stresslevel_min
  - stresslevel_max
  - moodlevel_min
  - moodlevel_max

- skill_use
  - id
  - used_skill_id
  - mood_entry_id
  - effectiveness
  - use_date_time