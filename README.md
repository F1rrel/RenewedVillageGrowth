# Renewed Village Growth (RVG)

![Renewed Village Growth](https://i.imgur.com/37J9Kn4.png)

RVG is a Game Script for OpenTTD that manages towns growth in a new and balanced way, making growth depend on varied cargo delivery (passengers, food, goods, ...) and sustained transportation of passangers and mails. The script supports all NewGRF industry replacement sets. It is born as a combination of [keoz's Renewed City Growth GS](https://www.tt-forums.net/viewtopic.php?f=65&t=69827) and [Sylf's City Growth Limiter GS](https://www.tt-forums.net/viewtopic.php?t=58238).

Forum topic: https://www.tt-forums.net/viewtopic.php?f=65&t=87052<br/>
BaNaNaS: https://bananas.openttd.org/package/game-script/52455649

## Requirements

- OpenTTD, v. 12.x or newer.
- GS SuperLib v. 40, ToyLib v. 1, Script Communication for GS v. 45 (you can find it on BaNaNaS, also accessible
  through OTTD's "Online Content").
- Industry sets: you can use any industry NewGRF
    - these are specifically supported industry NewGRF: Baseset (all climates), FIRS 1.4, 2, 3, 4.3
  (all economies), ECS 1.2 (any combination), YETI 0.1.6
  (all except Simplified), NAIS 1.0.6, ITI 1.6, 2, XIS 0.6, OTIS 05, IOTC 0.1, LJI 0.1, WRBI 1200,
  Real Beta, Minimalist, PIRS 2022
    - using RVG with any other unsupported industry set will contain proceduraly generated categories

## Translations
Currently available languages:
- English
- French (rmnvgr, Elarcis)
- Slovak
- Czech
- Simplified Chinese (SuperCirno, WenSimEHRP)
- Polish (qamil95)
- Galician (pvillaverde)
- German (pnkrtz)
- Japanese (fmang)
- Traditional Chinese (WenSimEHRP)
- Russian (Shkarlatov)

If you want to contribute to a translation, you can do it by modifying a file [english.txt](lang/english.txt) and posting it to the forum topic or creating a new issue/pull request with this file included. All instances of `{STRING[number]}` need to be replaced by `{STRING}` in all other languages.

## License

Renewed Village Growth is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License as
published by the Free Software Foundation, version 2 of the License
(see file license.txt).

## Credits

Author: Firrel<br><br>
Thanks to:
- keoz for the Renewed City Growth GS
- Sylf for the City Growth Limiter GS

Thanks to contributors:
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
- Shkarlatov
- JGRennison