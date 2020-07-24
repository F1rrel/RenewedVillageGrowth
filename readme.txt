                ******************************
                *   Renewed Village Growth   *
                *  A GameScript for OpenTTD  *
                ******************************


Usefull URL's:
- forum topic: https://www.tt-forums.net/viewtopic.php?f=65&t=87052
- last stable version: 3


Content:
* 1. How the script works
* 2. Settings
* 3. Requirements
* 4. License
* 5. Credits


1. How the script works

Renewed Village Growth (RVG) is a game script which changes the way towns
grow in OTTD. Various cargo requirements and passanger/mail percentage 
transported are defined - monthly - for each town. Towns only grow 
if those requirements are - partially or completely - satisfied. RVG 
supports several industry sets: Baseset, FIRS 1.3.0 and 3.0.12, ECS 1.2, 
YETI 0.1.6, NAIS.

The script only defines requirements for towns who are exchanging
passengers (meaning that a delivery of passengers coming from a town
is detected). Unless a town exchange passengers, it is not monitored
and you will not see any cargo requirement. The check is done
monthly. When a town stops exchanging passengers for six month, it
gets out from the list of monitored towns.

If passenger delivery is detected, the script defines some cargo
requirements for the ongoing month. Cargo requirements are not defined
by cargo types but by more general cargo categories, each of them
containing several cargo types. For example, cargo category 1 contains
Passengers and Mail cargo types. To achieve a cargo category
requirement, you can deliver to the town any of the category's cargo
type (for category 1, you can deliver indifferently Passengers or
Mail). If you delivery more cargo than necessary, the surplus is
stockpiled to be consumed next month (towns can stockpile a quantity
of 10 * cargotype requirement). Note that the cargo requirements
originally defined in the Arctic and Tropical climate (food and
water/food) are disabled by the script.

Depending on the used industry set, there are 3 or 5 categories
(though those can be reduced in settings). Here are the basic
categories:
*For baseset industries (all climate):*
- Cat 1: Passengers and Mail
- Cat 2: General goods (includes food and goods)
- Cat 3: Industrial materials (includes coal, wood, grain...)
*For FIRS, ECS and YETI:*
- Cat 1: Passengers and mail (includes also ECS Tourists)
- Cat 2: General food (includes: food, alcohol, fruit...)
- Cat 3: General goods (includes: goods, petrol, building material...)
- Cat 4: Raw industrial goods (includes: coal, oil, wood...)
- Cat 5: Transformed industrial goods (includes: chemicals, lumber,
  manufacturing supplies, farm supplies...)
Notes about categories:
- In the storybook, you can find a comprehensive list of cargotypes
  for each category and some other data.
- For industry sets which uses 5 categories, you can make the
  challenge easier by reducing them (merge categories 2 and 3, and/or
  categories 4 and 5). See settings below.
  
Cargo category requirements increase relatively to town population, in
two ways:
- for each cargo category, requirement increases linearly depending on
town size. The bigger a town is, bigger is the requirement for a given
category.
- each category starts being required only on a defined town
size. Passengers and mail are required whatever the town's size is,
while General food cargos are required only for towns bigger
500. General goods cargos, for towns bigger than 1500.
Hence, little towns only need Cat.1 cargos (Passengers and mail) to
grow, while towns with at least 500 habitants also need - increasingly
- food. When cities grow more, other categories come in play. That
means, that in the end, you can only expect to have a full - and long
term - city growth when developing some local industry, to which
deliver raw and transformed industrial materials. For details about
each industry set watch at cargo.nut.

The informations that the script gives are:
- Under each town name, a text indicates the actual town growth
  rate, only for the monitored towns; the number indicates how many
  days will you'll have to wait between each town expansion.
- In townboxes, first page is detailed informations about cargo 
  requirements are given for each category, in the form:
  *category: actual goal / last month supply / stockpiled cargo.
  Note that the town window only displays informations for cargo
  categories which are required in a given town at a given
  moment. Thus, in little towns, it is normal to only see an
  indication for category 1.
- In townboxes, second page is information about required and achieved
  percentage of transported passangers and mails is given
- Townbox pages switch automatically every 3 seconds or can be a 
  specific page, see "Town info display mode" GS setting.
- The StoryBook also gives informations: there you can find a general
  description of the categories used in the game, according to your
  settings. It also gives you some additional informations, such as
  the population limit at which each category becomes necessary for
  towns to grow.

Each month, for each town, a new town growth rate is recalculated. Its
level depends on the part of required cargo which have been
supplied. If you deliver all the required cargo, you will have the
maximum growth rate for a town (its maximum growth rate depends on its
size). If you deliver only a part of cargo, growth rate will be
lower. If you only deliver 50% of the requirements, town growth rate
is arbitrarily set to 10000. If you deliver a larger part of
requirements, the town growth rate increases exponentially. Hence, the
town growth rate is at the same time progressive and exponential.

The town growth rate calculated each month for a town is not used as
it: the script uses a moving average of the town growth rates from the
last 8 months. This feature allows to avoid big gaps in town's growth
rate. Changes in towns growth rates are smoothened and progressive.

The town growth is stopped completely for that month if the required 
percentage of passangers and/or mails is not fulfilled.

Finally, note that towns data (goals, supplies, stockpiles, growth
rates...) are saved, so that you can safely reload the game without
losses.

Have fun !


2. Settings

Normal settings:
- "Town info display mode": changes the mode of displaying town 
  information 
    - Automatic - switches between all pages at 3s interval 
	(higher town count can increase this interval)
	- Cargo information - displays cargo categories required / 
	supplied / stockpiled
	- Limiter information - displays passangers/mails transported / 
	required
- "Which industry set is being used?": this is necessary to determine
  what cargotypes are used by the game and build categories.
- "Difficulty level": a general factor for calculating cargo
  requirement. The higher it is, the higher are cargo requirements.
- "Merge categories 2 (food) and 3 (goods)": enabling this reduces the
  number of cargo categories by merging "General Food" and "General
  Goods" categories into only one, thus making the game easier. This
  setting only has effect when using industry sets which use 5
  categories (essentially FIRS and ECS).
- "Merge categories 4 (raw ind.) and 5 (transf. ind.)": same as
  previous setting, for categories 4 and 5.
- "Show growth rate text under town names": disabling this allows to
  discard the signs under town names, which show growth rate. On big
  games, disabling those signs can significantly reduce gamescript's
  load.
- "Eternal love from towns": Every month, change the rating of all
  local authorities to be at least of the set level
- "Debug": allows to define the amount of informations which are
  printed in GS' log. Set it to 2 if you want to see current cargo 
  labels and their index numbers. Set it to 3 if you want check 
  details about calculations.
  
Limit growth settings:
- "Minimum Percentage of Passangers Transported": how much of the 
  passangers generated by the town that month must be transported
- "Minimum Percentage of Mails Transported": how much of the mails 
  generated by the town that month must be transported
- "Minimum size of town before the limit rules kicks in": at what 
  population of the town the growth limitation will start

Expert settings:
These settings are for people who want finely tweak the script
behaviour. Most people shouldn't change them and can just change
requirements level with the "Difficulty level" setting described
above. Expert settings should only be changed when having a decent
understanding of their impact. Changing them is harmless though and
they can safely be changed while the game is running:
- "town growth factor": this value changes the maximum town growth
  rate of a town. Increasing it will result in *lower* town growth
  rate (town growing slower) and decreasing it will result in faster
  town growth.
- "minimum supply percentage for TGR growth": when calculating town
  growth rate, the script scales the growth rate to the percentage of
  required cargo supplied. But, by default, at least 50% of
  requirements needs to be supplied for this to happen and hence, the
  town growth rate is only scaled relatively to 50% until 100% of
  supply. This setting allows to change that percentage. Also see:
  http://dev.openttdcoop.org/projects/gs-rcg/wiki
- "TGR growth exponentiality factor": when the script scales the town
  growth rate to the percentage of achieved requirement, this relation
  is not linear but exponential. By increasing this setting you can
  increase exponentiality. To put it simple: the higher is this
  number, the more you need to approach a 100% supply to have a decent
  growth. Also See: http://dev.openttdcoop.org/projects/gs-rcg/wiki
- "lowest TGR if requirements are not meet": for some reason, when
  requirements are not met at all for a town, but this still is under
  active monitoring (because exchanging passengers), it is better not
  disabling completely town growth but setting it to an extremely low
  rate. The default is 10000 (which means that a new house is created
  only each 10000 days = 27 years). It can be increased until 30000.


3. Requirements

- OpenTTD, v. 1.10.x or newer.
- GS SuperLib, v. 40 (you can find it on BaNaNaS, also accessible
  through OTTD's "Online Content").
- Industry sets: you can use Baseset (all climates), FIRS 1.3.0 and 
  3.0.12 (all economies), ECS 1.2 (any combination), YETI 0.1.6, 
  NAIS 1.0.6. Using RVG with any other unsupported industry 
  set may result in odd - or unstable - behaviours.


4. License

Renewed Village Growth is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License as
published by the Free Software Foundation, version 2 of the License
(see file license.txt).


5. Credits

Author: Firrel
Thanks to:
- keoz for the Renewed City Growth GS
- Sylf for the City Growth Limiter GS
