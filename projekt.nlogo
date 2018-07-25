extensions [string csv]
breed [users user]
breed [database db]
breed [machine mc]

users-own [playlist preference preporuke]
database-own [podaci]
machine-own [tablica broj-transakcija zbroj-vrijednosti lista-z supp]
globals [odabrani-user]


to setup
  ca
  create-users 2 [
    set shape "person"
    set playlist []
    set preference []
    set preporuke []
  ]

  create-database 1 [
    set shape "computer server"
    set podaci []
    set color white
  ]

  create-machine 1 [
    setxy min-pxcor min-pycor
    set tablica []
    set zbroj-vrijednosti []
    set color gray
  ]

  ask user 0 [
    setxy min-pxcor - 0.1 max-pycor - 0.1
    ]

  ask user 1 [
    setxy max-pxcor - 0.1 min-pycor + 0.2
    ]

end


to go
  ca
  setup
  ask database [ucitaj-sve]

  postavi-pref-user-1
  postavi-pref-user-2
end



to transakcija-user-1

  ask user 0 [
    let lista-csv []
    set lista-csv preference
    set lista-csv fput " " lista-csv
    let linija ""
    let listaCsv []
    let br-transakcije []

    let zanrovi []

    file-open "lista-podataka-agent-1.csv"
    while [not file-at-end?]
    [
      set linija file-read-line
      set listaCsv string:rex-split linija ","
      let zadnji length listaCsv - 1
      set zanrovi lput sublist listaCsv 3 zadnji zanrovi
      set br-transakcije lput item 0 listaCsv br-transakcije
    ]

    file-close

    if file-exists? "transakcija1.csv" [file-delete "transakcija1.csv"]
    file-open "transakcija1.csv"

    file-print csv:to-row lista-csv

    let lista-transakcije []
    let lista-zanrovi []

    let c-p 0
    foreach zanrovi [
      set lista-zanrovi item c-p zanrovi
      set c-p c-p + 1


      let temp1 ""
      let temp2 ""
      let t-s 0
      let t-l length lista-zanrovi
      let c-ref 0
      let c-val 0
      let val []


      let lista-temp []
      repeat length preference [set lista-temp fput 0 lista-temp]
      while [t-s < t-l] [

        while [c-ref < length preference]
          [
            set temp1 item t-s lista-zanrovi
            set temp2 item c-ref preference
            if temp2 = temp1 [set val lput c-ref val]
            set c-ref c-ref + 1

          ]


         set c-ref 0
         set t-s t-s + 1

       ]

      let r 0
      while [c-val < length val]
         [
           set r item c-val val
           set lista-temp replace-item r lista-temp 1
           set c-val c-val + 1
         ]

      set lista-transakcije lput lista-temp lista-transakcije


    ]

    let counter 0
    let stavka []


    while [counter < length lista-transakcije]
    [
      let br counter + 1
      set stavka item counter lista-transakcije
      set stavka fput br stavka
      file-print csv:to-row stavka
      set counter counter + 1

  ]

  file-close
]

end


to transakcija-user-2

  ask user 1 [
    let lista-csv []
    set lista-csv preference
    set lista-csv fput " " lista-csv
    let linija ""
    let listaCsv []
    let br-transakcije []

    let zanrovi []

    file-open "lista-podataka-agent-2.csv"
    while [not file-at-end?]
    [
      set linija file-read-line
      set listaCsv string:rex-split linija ","
      let zadnji length listaCsv - 1
      set zanrovi lput sublist listaCsv 3 zadnji zanrovi
      set br-transakcije lput item 0 listaCsv br-transakcije
    ]

    file-close

    if file-exists? "transakcija2.csv" [file-delete "transakcija2.csv"]
    file-open "transakcija2.csv"

    file-print csv:to-row lista-csv

    let lista-transakcije []
    let lista-zanrovi []

    let c-p 0 ; counter za playlistu
    foreach zanrovi [
      set lista-zanrovi item c-p zanrovi
      set c-p c-p + 1


      let temp1 ""
      let temp2 ""
      let t-s 0
      let t-l length lista-zanrovi
      let c-ref 0
      let c-val 0
      let val []


      let lista-temp []
      repeat length preference [set lista-temp fput 0 lista-temp]
      while [t-s < t-l] [

        while [c-ref < length preference]
          [
            set temp1 item t-s lista-zanrovi
            set temp2 item c-ref preference
            if temp2 = temp1 [set val lput c-ref val]
            set c-ref c-ref + 1

          ]


         set c-ref 0
         set t-s t-s + 1

       ]

      let r 0
      while [c-val < length val]
         [
           set r item c-val val
           set lista-temp replace-item r lista-temp 1
           set c-val c-val + 1
         ]

      set lista-transakcije lput lista-temp lista-transakcije


    ]

    let counter 0
    let stavka []


    while [counter < length lista-transakcije]
    [
      let br counter + 1
      set stavka item counter lista-transakcije
      set stavka fput br stavka
      file-print csv:to-row stavka
      set counter counter + 1

  ]

  file-close
]

end

to ucitaj-transakciju
  ifelse filepath = "transakcija1.csv" [set odabrani-user 0][set odabrani-user 1]
  if file-exists? filepath [show filepath]
  file-open filepath
  let stavka []
  while [not file-at-end?]
  [
    let counter 0
    let ucitaj file-read-line
    let linija string:rex-split ucitaj ","
    set stavka lput but-first linija stavka
  ]
  ask mc 3 [set tablica but-first stavka]
  ask mc 3 [set lista-z first stavka]


  ask machine [
    let c-t 0
    let c-br 0

    let lista-temp []
    let tablica-br []
    let brojevna []

    foreach tablica [
      set lista-temp item c-t tablica

      while [c-br < length lista-temp] [
        let conv-br read-from-string item c-br lista-temp
        set brojevna lput conv-br brojevna
        set c-br c-br + 1
        ]

      set tablica-br lput brojevna tablica-br
      set brojevna []
      set c-t c-t + 1
      set c-br 0
    ]

    set tablica tablica-br

  ]
  file-close


end


to izracunaj-popularnost

  set zbroj-vrijednosti []
  set broj-transakcija length tablica

  clear-output
  output-show word "Broj transakcija: " broj-transakcija

  let c-t 0
  let zbroj []
  let lista-temp []

  repeat length item 0 tablica [set zbroj-vrijednosti lput 0 zbroj-vrijednosti]
  foreach tablica [
      set lista-temp item c-t tablica
      set zbroj-vrijednosti (map [?1 + ?2] lista-temp zbroj-vrijednosti)
      set c-t c-t + 1
  ]

  set c-t 0
end


to izbaci-nepopularne-stavke
  set supp support / 100

  ask mc 3 [
    let c-br 0
    let c-ind 0
    let indices []

    while [c-br < length zbroj-vrijednosti]
    [
      let trenutni item c-br zbroj-vrijednosti
      if trenutni / broj-transakcija <= supp [
        set indices lput c-br indices
       ]
      set c-br c-br + 1
    ]

    set c-br 0



    let lista-temp2 []
    let tablica-temp2 []

    foreach tablica [
      while [c-ind < length tablica]
      [
        set lista-temp2 item c-ind tablica
        let c-ind2 0
        while [c-ind2 < length indices]
        [
          let temp item c-ind2 indices
          set lista-temp2 replace-item temp lista-temp2 -1
          set c-ind2 c-ind2 + 1
        ]

        set lista-temp2 remove -1 lista-temp2
        set tablica-temp2 lput lista-temp2 tablica-temp2
        set c-ind c-ind + 1
      ]

    ]

    set c-ind 0

    while [c-ind < length indices]
    [
      let temp item c-ind indices
      set lista-z replace-item temp lista-z "#"
      set zbroj-vrijednosti replace-item temp zbroj-vrijednosti -1
      set c-ind c-ind + 1
    ]

    set lista-z remove "#" lista-z
    set zbroj-vrijednosti remove -1 zbroj-vrijednosti

    set tablica tablica-temp2

  ]
end


to posalji-rezultate

  let izvodjaci []
  let zanrovi-izv []
  let podaci-temp []
  let playlist-temp []
  let preporuke-temp []
  let indices []
  let pref []
  set pref lista-z
  let c-pd 0

  ask db 2 [
    set podaci-temp podaci
    ]

  ifelse odabrani-user = 0
  [ask user 0 [set playlist-temp playlist]]
  [ask user 1 [set playlist-temp playlist]]

  while [c-pd < length podaci-temp] [
    let temp []
    set temp item c-pd podaci-temp
    set izvodjaci lput item 1 temp izvodjaci
    set zanrovi-izv lput item 2 temp zanrovi-izv
    set c-pd c-pd + 1
  ]

  set c-pd 0


  while [c-pd < length zanrovi-izv]
  [
    let temp1 item c-pd zanrovi-izv
    let c-tp 0
    while [c-tp < length pref]
    [
      let tmp item c-tp pref
      let c-ttp 0

      while [c-ttp < length temp1]
      [
        let comp1 item c-ttp temp1
        if comp1 = tmp [set indices lput c-pd indices]
        set c-ttp c-ttp + 1
      ]

      set c-tp c-tp + 1
    ]

    set c-pd c-pd + 1
  ]

  set c-pd 0

  set indices remove-duplicates indices

  while [c-pd < length indices]
  [
    let tmpind item c-pd indices
    let provjera item tmpind izvodjaci
    if not member? provjera playlist-temp [
      let izvodjac item tmpind izvodjaci

      set preporuke-temp lput izvodjac preporuke-temp
      ]

    set c-pd c-pd + 1
  ]

  ask users [
    set preporuke preporuke-temp
    ]


end


to apriori-algoritam-pass-1
  ask mc 3[
    izracunaj-popularnost
    izbaci-nepopularne-stavke
    posalji-rezultate
    output-show "Najcesci zanrovi: "
    output-show lista-z
    output-show word "Popularnost (%): "support

    ifelse odabrani-user = 0
    [ask user 0 [
        output-show "-------------------------"
        output-show "Preporuke za korisnika 1 "
        foreach preporuke output-show

    ]
    ]
    [ask user 1 [
        output-show "-------------------------"
        output-show "Preporuke za korisnika 2 "
        foreach preporuke output-show

       ]
    ]

  ]



end

to prikazi-sve-izvodjace
  ask db 2 [
    clear-output
    foreach podaci output-show
    ]
end

to ucitaj-sve
  file-open "lista-podataka-sve.csv"
  while [not file-at-end?]
  [
    let linija file-read-line
    let listaCsv string:rex-split linija ","
    let zadnji length listaCsv - 1
    let zanrovi sublist listaCsv 3 zadnji
    let br-podatka item 0 listaCsv
    let autor item 1 listaCsv
    let stavka []
    set stavka lput br-podatka stavka
    set stavka lput autor stavka

    set stavka lput zanrovi stavka
    ask database [set podaci lput stavka podaci]
  ]

  file-close
end



to postavi-pref-user-1
  file-open "lista-podataka-agent-1.csv"
  let zanrovi []

  while [not file-at-end?]
  [
    let counter 0
    let linija file-read-line
    let listaCsv string:rex-split linija ","
    let zadnji length listaCsv - 1
    set zanrovi sublist listaCsv 3 zadnji

    ask user 0[
      set playlist lput item 1 listaCsv playlist
      foreach zanrovi [
        let stavka item counter zanrovi
        if not member? stavka preference [set preference lput stavka preference]
        set counter counter + 1
      ]

    ]
  ]
  file-close

end


to postavi-pref-user-2
  file-open "lista-podataka-agent-2.csv"
  let zanrovi []

  while [not file-at-end?]
  [
    let counter 0
    let linija file-read-line
    let listaCsv string:rex-split linija ","
    let zadnji length listaCsv - 1
    set zanrovi sublist listaCsv 3 zadnji

    ask user 1[
      set playlist lput item 1 listaCsv playlist
      foreach zanrovi [
        let stavka item counter zanrovi
        if not member? stavka preference [set preference lput stavka preference]
        set counter counter + 1
      ]
    ]
  ]
  file-close

end
@#$#@#$#@
GRAPHICS-WINDOW
497
31
782
337
5
5
25.0
1
10
1
1
1
0
1
1
1
-5
5
-5
5
0
0
1
ticks
30.0

BUTTON
417
31
489
64
Postavi
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

OUTPUT
81
105
489
338
11

CHOOSER
790
31
929
76
filepath
filepath
"transakcija1.csv" "transakcija2.csv"
1

BUTTON
790
80
901
113
Ucitaj podatke
ask machine [ucitaj-transakciju]
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
789
119
960
152
Apriori Algoritam (Pass 1)
apriori-algoritam-pass-1
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
82
66
254
99
support
support
0
100
74
1
1
%
HORIZONTAL

BUTTON
794
305
950
338
Prikazi podatke iz baze
prikazi-sve-izvodjace
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

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

computer server
false
0
Rectangle -7500403 true true 75 30 225 270
Line -16777216 false 210 30 210 195
Line -16777216 false 90 30 90 195
Line -16777216 false 90 195 210 195
Rectangle -10899396 true false 184 34 200 40
Rectangle -10899396 true false 184 47 200 53
Rectangle -10899396 true false 184 63 200 69
Line -16777216 false 90 210 90 255
Line -16777216 false 105 210 105 255
Line -16777216 false 120 210 120 255
Line -16777216 false 135 210 135 255
Line -16777216 false 165 210 165 255
Line -16777216 false 180 210 180 255
Line -16777216 false 195 210 195 255
Line -16777216 false 210 210 210 255
Rectangle -7500403 true true 84 232 219 236
Rectangle -16777216 false false 101 172 112 184

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
NetLogo 5.3.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
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
