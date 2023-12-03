                ******************************
                *   Renewed Village Growth   *
                *  A GameScript for OpenTTD  *
                ******************************

Version: 9.3

Usefull URL's:
- forum topic: https://www.tt-forums.net/viewtopic.php?f=65&t=87052
- github: https://github.com/F1rrel/RenewedVillageGrowth


Content:
* 1. How the script works
* 2. Settings
* 3. Requirements
* 4. License
* 5. Credits
* 6. FAQ


1. How the script works

Renewed Village Growth (RVG) is a game script which changes the way towns
grow in OTTD. Various cargo requirements and passenger/mail percentage
transported are defined - monthly - for each town. Towns only grow
if those requirements are - partially or completely - satisfied. RVG
supports all industry sets.

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

Depending on the used industry set, there are 3 to 5 categories.
Here are the basic categories:
*For baseset industries (all climate):*
- Cat 1: Public services
- Cat 2: Raw materials
- Cat 3: Products (processed raw materials)
*For FIRS, ECS and YETI:*
- Cat 1: Public services (includes also ECS Tourists)
- Cat 2: Raw food (includes: livestock, coffee, fruit...)
- Cat 3: Raw materials (includes: goods, petrol, building material...)
- Cat 4: Processed materials (includes: chemicals, lumber, engineering supplies...)
- Cat 5: Final products (includes: vehicles, building materials, food, goods...)
Notes about categories:
- In the storybook, you can find a comprehensive list of cargotypes
  for each category and some other data.
- You can select a randomization, so every town will have randomly selected
  cargos per category. More on it in the Settings.
- There is also added a special randomization, that selects industries instead
  of cargos so that the category is defined as inputs to a specific industry type

Cargo category requirements increase relatively to town population, in
two ways:
- for each cargo category, requirement increases linearly depending on
town size. The bigger a town is, bigger is the requirement for a given
category.
- each category starts being required only on a defined town
size. Passengers and mail are required whatever the town's size is,
while Raw food cargos are required only for towns bigger
500. Raw materials cargos, for towns bigger than 1500.
Hence, little towns only need Cat.1 cargos (Public services) to
grow, while towns with at least 500 habitants also need - increasingly
- raw food. When cities grow more, other categories come in play. That
means, that in the end, you can only expect to have a full - and long
term - city growth when developing some local industry, to which
deliver raw and transformed industrial materials. For details about
each industry set watch at cargo.nut.

Each town decides on a new Contributor at the start of a new month. This
Contributor is chosen by the level of contribution to the categories of
the town. The contributor then receives points for this town for the
next month based on its growth and is displayed in the player's
statistics.
Example of deciding on the Contributor:
Player 1 supplies category 1 to 80%, category 2 to 40% and category 3 to 0%.
Player 2 supplies category 1 to 100%, category 2 to 20% and category 3 to 15%.
Player 1 contributes 120%, Player 2 contributes 135% and is the Contributor.

The informations that the script gives are:
- Under each town name, a text indicates the actual town growth
  rate, only for the monitored towns; the number indicates how many
  days will you'll have to wait between each town expansion.
- In townboxes, there are four parts:
    - Largest population - the maximum achieved population of that town
    - Contributor - company name that contributed the most to the town
    - Limiter - information about the cargo that limits the growth
    - Categories - cargo categories and their supplied/required info
  Note that the town window only displays informations for cargo
  categories which are required in a given town at a given
  moment. Thus, in little towns, it is normal to only see an
  indication for category 1.
- There are five possible modes of showing the townboxes:
    - Automatic
    - Cargo deliveries
    - Cargo list
    - Combined
    - Full cargo list
  See "Town info display mode" GS setting.
- The StoryBook also gives informations:
    - Cargo page - there you can find a general description of
      the categories used in the game, according to your settings.
      It also gives you some additional informations, such as the
      population limit at which each category becomes necessary for
      towns to grow.
    - Welcome page - shows description how this GS works and where
      to find more information.
    - Custom page - if enabled, shows custom information like server
      rules.
- The Goals display statistics of a player containing:
    - Growth points - receive a point for every new habitant of a town
                      over the maximum achieved town size
    - Average town category - average of number of categories of
                              contributed towns
    - Number of contributed towns
    - Number of not growing towns
    - Biggest town - population
    - Fastest growing town in days

Each month, for each town, a new town growth rate is recalculated. Its
level depends on the part of required cargo which have been
supplied. If you deliver all the required cargo, you will have the
maximum growth rate for a town (its maximum growth rate depends on its
size). If you deliver only a part of cargo, growth rate will be
lower. If you only deliver 50% of the requirements, town growth rate
is arbitrarily set to minimum. If you deliver a larger part of
requirements, the town growth rate increases exponentially. Hence, the
town growth rate is at the same time progressive and exponential.

The town growth rate calculated each month for a town is not used as
it: the script uses a moving average of the town growth rates from the
last 8 months. This feature allows to avoid big gaps in town's growth
rate. Changes in towns growth rates are smoothened and progressive.

The town growth is stopped completely for that month if the required
percentage of passengers and/or mails is not fulfilled.

Finally, note that towns data (goals, supplies, stockpiles, growth
rates...) are saved, so that you can safely reload the game without
losses. This release supports up to 1400 towns to be saved.

Have fun !


2. Settings

Normal settings:
- "Town info display mode": changes the mode of displaying town
  information
    - Automatic - switches between pages at 3s interval
    (higher town count can increase this interval)
    - Category deliveries - displays passengers/mails transported /
    required and cargo categories required / supplied / stockpiled
    - Cargo list - displays accepted cargo per category
    - Combined - displays cargo categories and accepted cargo per category
    - Full cargo list - displays all categories of accepted cargo
- "Difficulty level": a general factor for calculating cargo
  requirement. The higher it is, the higher are cargo requirements.
- "Show growth rate text under town names": disabling this allows to
  discard the signs under town names, which show growth rate. On big
  games, disabling those signs can significantly reduce gamescript's
  load. (locked on start)
- "Eternal love from towns": Every month, change the rating of all
  local authorities to be at least of the set level
- "Debug": allows to define the amount of informations which are
  printed in GS' log. Set it to 2 if you want to see current cargo
  labels and their index numbers. Set it to 3 if you want check
  details about calculations.

Randomization settings:
- "Randomization: Type": all towns will have randomly selected
  cargos/industries per category based on selection (locked on start)
    - None - no randomization, all cargos per category are accepted
    - Industry ascending/descending - each category represent an industry
    - 1,2,3,5,7 per category - fixed amount of cargos per category
    - 1-2, 1-3, 2-3, 3-5, 3-7 - minimum to maximum amount of cargos
      per category
    - Descending/ascending - the number of cargo types per category
      is ascending (1 to 5) or descending (5 to 1)
- "Randomization: Probability to use nearby cargo types [%]": when selecting
  cargos for each category, specifies probability of using a cargo belonging
  to that category that is accepted by an existing nearby industry
- "Randomization: Show town cargos from start": if selected, all randomized
  cargos can be visible for each town, otherwise only reached
  categories are displayed (locked on start)

Industry stabilizer:
- "Raw industry density": maintain a set amount of raw industries on
  the map by funding new. Can be used to start a map with only raw
  industries.

Limit growth settings:
- "Minimum Percentage of transported cargo from town": how much of the
  cargo generated by the town that month must be transported
- "Minimum size of town before the limit rules kicks in": at what
  population of the town the growth limitation will start
- "Stop growth after set amount of months": keep growing for the amount
  of months after limiter stops the growth

Subsidies:
- "Subsidies: Create subsidies for contributed towns": enable/disable/select
  which type of subsidy should be generated. Passanger subsidy creates link
  from biggest town to a closest unclaimed town. Cargo subsidy creates link
  from unused industry to a contributed town's industry.

Category settings:
These settings change the cargo category values and can only be changed
before the game start.
- "category_X_min_pop": change the minimum population at which the demand
  for that category starts. The categories are sorted based on selected
  values. Choosing value -1 uses the economy's default value.

Expert settings:
These settings are for people who want finely tweak the script
behaviour. Most people shouldn't change them and can just change
requirements level with the "Difficulty level" setting described
above. Expert settings should only be changed when having a decent
understanding of their impact. Changing them is harmless though and
they can safely be changed while the game is running:
- "town growth factor": this value changes the maximum town growth
  rate of a town. Increasing it will result in slower town growth
  and decreasing it will result in faster town growth. The value
  represents the maximum town growth at 0 population.
- "minimum fulfilled percentage for TGR growth": this value specifies the
  minimum fulfillment percentage of cargo categories for which
  the growth rate is calculated. When this percentage is not fulfilled,
  the lowest growth rate is used. The growth is still scaled to 100% of
  the fulfillment.
- "TGR growth exponentiality factor": when the script scales the town
  growth rate to the percentage of achieved requirement, this relation
  is not linear but exponential. By increasing this setting you can
  increase exponentiality. To put it simple: the higher is this
  number, the more you need to approach a 100% supply to have a decent
  growth.
- "lowest TGR if requirements are not met": for some reason, when
  requirements are not met at all for a town, but this still is under
  active monitoring (because exchanging passengers), it is better not
  disabling completely town growth but setting it to an extremely low
  rate. The default is 880 (which means that a new house is created
  only each 880 days). It can be increased until 880.
- "allow_0_days_growth": the town growth rate can go to zero days.


3. Requirements

- OpenTTD, v. 1.10.x or newer.
- GS SuperLib, v. 40 (you can find it on BaNaNaS, also accessible
  through OTTD's "Online Content").
- Industry sets: you can use any industry NewGRF
    - these are specifically supported industry NewGRF: Baseset
    (all climates), FIRS 1.4, 2, 3, 4.3 (all economies), ECS 1.2
    (any combination), YETI 0.1.6 (all except Simplified),
    NAIS 1.0.6, ITI 1.6, 2, XIS 0.6, OTIS 05, IOTC 0.1, LJI 0.1,
    WRBI 1200, Real Beta, Minimalist, PIRS 2022.
  Using RVG with any other unsupported industry set will contain
  proceduraly generated categories


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

Contributors:
- rmnvgr
- pr0saic
- audunmaroey
- SuperCirno
- qamil95
- 2TallTyler
- pvillaverde
- pnkrtz
- fmang
- Elarcis
- lezzano000
- WenSimEHRP

6. FAQ

Q: Where do I have to deliver the required cargo?
A: Some of the cargo types are accepted by the towns, so they can be
   directly delivered there. Other cargo types need to be delivered
   to a industry which accepts it. The station accepting the cargo
   needs to be near the town. The best indicator is that if the name
   of the station is same as the town, the cargo will be counted
   towards that town.

Q: What to do when no industry accepts that cargo near the town?
A: If no industry accepts the cargo, the industry has to be funded
   near the town. The best way to place the industry is to firstly
   place down a few stations and if the stations have the same name
   as the town, the industry placed there will be near enough the town.

Q: What to do when procedural cargo generation fails?
A: Some economies cannot be proceduraly created. You can choose from more
   than 30 supported economies or submit issue to github/tt-forums stating
   the unsupported economy. Another cause is that an industry is not
   considered raw until it is placed on the map. Having at least
   one of each raw industry on map will improved procedural generation.

Q: What to do when procedural industry generation fails?
A: Some economies cannot be procedurally industry generated. This can be
   due to not enough industries with specific number of outputs to create
   industry randomization list or economy with not specified raw/processing
   industries. Another cause is that an industry is not considered raw
   until it is placed on the map. Having at least one of each raw industry
   on map will improved procedural generation.