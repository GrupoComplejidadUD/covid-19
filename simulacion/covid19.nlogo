;; MIT License
;;
;; Copyright (c) 2020 GrupoComplejidadUD
;;
;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "covid-19"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:
;;
;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

extensions [ py array]

breed [ people person ]

globals [ number-of-deaths contagion-memory current-contagion number-contagion count_men count_women count_uninfected count_infected count_infected_women count_infected_men count_mild count_moderate count_serious count_asymptomatic count_recovered confirmed_cases]

__includes [ "people.nls" "probabilities.nls" ]

people-own[
  age
  district
  vulnerability_index
  gender
  place_of_care
  mobility
  status
  level_of_infection
  time_infection
  previous_medical_condition
  viral_number
  personal-immunity-time
  latency-time
  infected_someone
]

to setup
  py:setup py:python3
  py:run "from python_files import functions "
  clear-all
  reset-ticks
  set number-of-deaths 0
  set contagion-memory infected-quantity
  create-uninfected-people
  create-infected-people infected-quantity
end

to start
  if ((count people with [status = "infected"]) = 0)[ stop ]
  evaluate-quarantine
  step-people

  set current-contagion count people with [status = "infected"]
  if (contagion-memory != 0)and((ticks mod 24) = 0) [
    let calculate-contagion (current-contagion - contagion-memory ) / contagion-memory
    if (calculate-contagion > 0)[
      set number-contagion calculate-contagion
      set contagion-memory current-contagion
    ]
  ]
  ;; Assign ouputs
  outputs

  if (stop-condition? = true and time-stop = ticks)[ stop ]

  ;; increate time
  tick
end

to evaluate-quarantine
  if ((ticks mod 24) = 0)[
    let day ticks / 24
    if ((day mod quarantine-days) = 0)[
      ifelse (rule-ages = true)[ set rule-ages false][ set rule-ages true ]
      ifelse (not-move? = true)[ set not-move? false ][ set not-move? true]
    ]
  ]
end

to outputs
  set count_men count people with [gender = "male"]
  set count_women count people with [gender = "female"]
  set count_uninfected count people with [status = "uninfected"]
  set count_infected count people with [status = "infected"]
  set count_infected_women count people with [(gender = "female") and (status = "infected")]
  set count_infected_men count people with [(gender = "male") and (status = "infected")]
  set count_mild count people with[level_of_infection = "mild"]
  set count_moderate count people with[level_of_infection = "severe"]
  set count_serious count people with[level_of_infection = "critical"]
  set count_asymptomatic count people with[level_of_infection = "asymptomatic" and status = "infected"]
  set count_recovered count people with [status = "recovered"]
  set confirmed_cases count_mild + count_moderate + count_serious
end
@#$#@#$#@
GRAPHICS-WINDOW
290
10
728
449
-1
-1
13.05
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
8
10
74
43
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
86
10
149
43
Start
start
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
9
166
128
226
population
584.0
1
0
Number

INPUTBOX
138
165
274
225
infected-quantity
3.0
1
0
Number

PLOT
1159
11
1464
176
Contagion curve
Ticks
Count
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Infected" 1.0 0 -2674135 true "" "plot count people with [status = \"infected\"]"
"Uninfected" 1.0 0 -12087248 true "" "plot count people with [status = \"uninfected\"]"
"Died" 1.0 0 -10146808 true "" "plot number-of-deaths"
"Recovered" 1.0 0 -4079321 true "" "plot count people with [status = \"recovered\"]"

MONITOR
1495
12
1574
57
Uninfected
count people with [status = \"uninfected\"]
17
1
11

MONITOR
1584
13
1661
58
Infected
count people with [status = \"infected\"]
17
1
11

MONITOR
1590
67
1719
112
number-of-deaths
number-of-deaths
17
1
11

MONITOR
1495
66
1575
111
Recovered
count people with [status = \"recovered\"]
17
1
11

PLOT
1497
621
1806
841
Contagions per tick
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -13791810 true "" "plot count people with [time_infection = 1]"

BUTTON
161
10
224
43
step
start
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1161
619
1467
841
Per gender
Ticks
Count
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Male" 1.0 0 -13791810 true "" "plot count people with[status = \"infected\" and gender = \"male\"]"
"Female" 1.0 0 -2674135 true "" "plot count people with[status = \"infected\" and gender = \"female\"]"

MONITOR
18
697
97
742
Male
count people with [gender = \"male\"]
17
1
11

MONITOR
110
697
186
742
Female
count people with [gender = \"female\"]
17
1
11

SWITCH
12
381
146
414
not-move?
not-move?
0
1
-1000

SLIDER
18
819
283
852
immunity-time
immunity-time
0
360
240.0
1
1
Days
HORIZONTAL

TEXTBOX
19
791
275
810
Warning: Immunity time is on DAYS scale
12
15.0
1

SWITCH
16
607
281
640
show-who-infected-who
show-who-infected-who
1
1
-1000

PLOT
1159
180
1466
413
Infection level on people
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"asymptomatic" 1.0 0 -8630108 true "" "plot count people with[level_of_infection = \"asymptomatic\" and status = \"infected\"]"
"mild" 1.0 0 -10899396 true "" "plot count people with[level_of_infection = \"mild\"]"

MONITOR
1681
13
1809
58
NIL
number-contagion
17
1
11

PLOT
1495
421
1809
611
Daily average contagion
NIL
NIL
0.0
10.0
0.0
3.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot number-contagion"

TEXTBOX
1983
507
2103
591
Condiciones:\nmundo: 16 x 16\nTotal: 100 personas\nInfectados: 1\nTotal ticks hasta final propagacion: 2550
11
0.0
1

TEXTBOX
1856
504
1966
588
Condiciones \nmundo 32 x 32\ntotal 100 personas\ninfectados 1\ntotal ticks hasta final propagacion 364
11
0.0
1

INPUTBOX
18
862
283
922
latency-period
48.0
1
0
Number

TEXTBOX
20
759
290
787
Agents configuration
14
0.0
1

TEXTBOX
11
130
212
164
Simulation configuration
14
0.0
1

SLIDER
10
235
278
268
min-age-to-go-outside
min-age-to-go-outside
0
100
18.0
1
1
ages
HORIZONTAL

SLIDER
10
279
277
312
max-age-to-go-outside
max-age-to-go-outside
0
100
60.0
1
1
ages
HORIZONTAL

SWITCH
12
328
129
361
rule-ages
rule-ages
0
1
-1000

TEXTBOX
138
324
288
366
This rule allow that people between min age and max age to go outsite
11
0.0
1

MONITOR
1617
126
1712
171
Men Infected
count people with [(gender = \"male\") and (status = \"infected\")]
17
1
11

MONITOR
1497
126
1605
171
Women infected
count people with [(gender = \"female\") and (status = \"infected\")]
17
1
11

BUTTON
17
651
120
684
Add infected
;add_infected_people
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
154
369
281
424
This rule avoid that cases of confirmed of infected people can move
11
0.0
1

PLOT
1159
420
1468
612
Infection Level 2
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Severe" 1.0 0 -8431303 true "" "plot count people with[level_of_infection = \"severe\"]"
"Critical" 1.0 0 -2674135 true "" "plot count people with[level_of_infection = \"critical\"]"

MONITOR
1826
13
1905
58
count mild
count people with[level_of_infection = \"mild\"]
17
1
11

MONITOR
1924
13
2035
58
count moderate
count people with[level_of_infection = \"severe\"]
17
1
11

MONITOR
1827
65
1928
110
Count serious
count people with[level_of_infection = \"critical\"]
17
1
11

MONITOR
1943
64
2082
109
count asymptomatic
count people with[level_of_infection = \"asymptomatic\" and status = \"infected\"]
17
1
11

TEXTBOX
1857
431
2007
449
Transmisión comunitaria
12
0.0
1

INPUTBOX
15
534
164
594
patch-meters
4.0
1
0
Number

TEXTBOX
170
546
320
588
1 patch -> 4 m so the maximum distance of contagion is 0.5 patch
11
0.0
1

INPUTBOX
12
60
85
120
time-stop
0.0
1
0
Number

SWITCH
103
61
259
94
stop-condition?
stop-condition?
1
1
-1000

PLOT
1497
180
1808
412
Confirmed Cases
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"cases" 1.0 0 -2674135 true "" "plot confirmed_cases"

MONITOR
1720
126
1839
171
Confirmed Cases
confirmed_cases
17
1
11

SWITCH
13
432
166
465
switch-quarantine
switch-quarantine
0
1
-1000

INPUTBOX
14
470
163
530
quarantine-days
15.0
1
0
Number

@#$#@#$#@
## WHAT IS IT?

This is a simulation that tries to simulate the 

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)

## MIT License

MIT License

Copyright (c) 2020 GrupoComplejidadUD

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "covid-19"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="todos los casos" repetitions="2" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>start</go>
    <exitCondition>(count people with [status = "infected"]) = 0</exitCondition>
    <metric>number-contagion</metric>
    <metric>number-of-deaths</metric>
    <metric>count_men</metric>
    <metric>count_women</metric>
    <metric>count_uninfected</metric>
    <metric>count_infected</metric>
    <metric>count_infected_women</metric>
    <metric>count_infected_men</metric>
    <metric>count_mild</metric>
    <metric>count_moderate</metric>
    <metric>count_serious</metric>
    <metric>count_asymptomatic</metric>
    <metric>count_recovered</metric>
    <metric>confirmed_cases</metric>
    <metric>current-contagion</metric>
    <enumeratedValueSet variable="rule-ages">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="latency-period">
      <value value="48"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="not-move?">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-age-to-go-outside">
      <value value="18"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infected-quantity">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population">
      <value value="529"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-age-to-go-outside">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immunity-time">
      <value value="240"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-who-infected-who">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stop-condition?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="sin las restricciones" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>start</go>
    <exitCondition>(count people with [status = "infected"]) = 0</exitCondition>
    <metric>number-contagion</metric>
    <metric>number-of-deaths</metric>
    <metric>count_men</metric>
    <metric>count_women</metric>
    <metric>count_uninfected</metric>
    <metric>count_infected</metric>
    <metric>count_infected_women</metric>
    <metric>count_infected_men</metric>
    <metric>count_mild</metric>
    <metric>count_moderate</metric>
    <metric>count_serious</metric>
    <metric>count_asymptomatic</metric>
    <metric>count_recovered</metric>
    <metric>confirmed_cases</metric>
    <metric>current-contagion</metric>
    <enumeratedValueSet variable="rule-ages">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="latency-period">
      <value value="48"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="not-move?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-age-to-go-outside">
      <value value="18"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infected-quantity">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population">
      <value value="584"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-age-to-go-outside">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immunity-time">
      <value value="240"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-who-infected-who">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stop-condition?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="todas las restricciones" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>start</go>
    <exitCondition>(count people with [status = "infected"]) = 0</exitCondition>
    <metric>ticks</metric>
    <metric>number-contagion</metric>
    <metric>number-of-deaths</metric>
    <metric>count_men</metric>
    <metric>count_women</metric>
    <metric>count_uninfected</metric>
    <metric>count_infected</metric>
    <metric>count_infected_women</metric>
    <metric>count_infected_men</metric>
    <metric>count_mild</metric>
    <metric>count_moderate</metric>
    <metric>count_serious</metric>
    <metric>count_asymptomatic</metric>
    <metric>count_recovered</metric>
    <metric>confirmed_cases</metric>
    <metric>current-contagion</metric>
    <enumeratedValueSet variable="rule-ages">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="latency-period">
      <value value="48"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="not-move?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-age-to-go-outside">
      <value value="18"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infected-quantity">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population">
      <value value="584"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-age-to-go-outside">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immunity-time">
      <value value="240"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-who-infected-who">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stop-condition?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
