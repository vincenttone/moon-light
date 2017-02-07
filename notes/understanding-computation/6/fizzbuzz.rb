ZERO = -> p { -> x { x }}
ONE = -> p { -> x { p[x] }}
TWO = -> p { -> x { p[p[x]] }}
THREE = -> p { -> x { p[p[p[x]]] }}

def to_integer(proc)
  proc[-> n {n + 1}][0]
end

FIVE = -> p { -> x { p[p[p[p[p[x]]]]] } }
FIFTEEN = -> p { -> x { p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[x]]]]]]]]]]]]]]] } }
HUNDRED = -> p { -> x { p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[x]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]] } }

p to_integer(ZERO)
p to_integer(ONE)
p to_integer(TWO)
p to_integer(THREE)
p to_integer(FIVE)
p to_integer(FIFTEEN)
p to_integer(HUNDRED)

TRUE = -> x { -> y { x }}
FALSE = -> x { -> y { y }}

def to_boolean(proc)
  proc[true][false]
end

p to_boolean(TRUE)

IF = -> b {
  -> x {
    -> y {
      b[x][y]
    }
  }
}

p IF[TRUE]['happy']['sad']
p IF[FALSE]['happy']['sad']

def to_boolean(proc)
  IF[proc][true][false]
end

IF = -> b { b }

p IF[TRUE]['happy']['sad']
p IF[FALSE]['happy']['sad']

IS_ZERO = -> n { n[-> x { FALSE }][TRUE] }

p to_boolean(IS_ZERO[ZERO])
p to_boolean(IS_ZERO[THREE])

PAIR = -> x { -> y { -> f { f[x][y]}}}
LEFT = -> p { p[-> x { -> y { x } } ] }
RIGHT = -> p { p[-> x { -> y { y } } ] }

my_pair = PAIR[THREE][FIVE]
p to_integer(LEFT[my_pair])
p to_integer(RIGHT[my_pair])

INCREMENT = -> n {
  -> p {
    -> x {
      p[n[p][x]]
    }
  }
}
SLIDE = -> p {
  PAIR[RIGHT[p]][INCREMENT[RIGHT[p]]]
}
DECREMENT = -> n {
  LEFT[n[SLIDE][PAIR[ZERO][ZERO]]]
}
p to_integer(DECREMENT[FIVE])
p to_integer(DECREMENT[FIFTEEN])
p to_integer(DECREMENT[HUNDRED])
p to_integer(DECREMENT[ZERO])

ADD = -> m { -> n { n [INCREMENT] [m] } }
SUBTRACT = -> m { -> n { n [DECREMENT] [m] } }
MULTIPLY = -> m { -> n { n [ADD[m]][ZERO] } }
#MULTIPLY = -> m { -> n { n [ADD [m]][ZERO] } }
POWER = -> m { -> n { n [MULTIPLY[m] ] [ONE] } }

p to_integer(ADD[FIVE][HUNDRED])
p to_integer(SUBTRACT[HUNDRED][FIVE])
p to_integer(MULTIPLY[HUNDRED][FIVE])
p to_integer(POWER[FIVE][TWO])

IS_LESS_OR_EQUAL = -> m { -> n {
    IS_ZERO[SUBTRACT[m][n]]
  }
}

p to_boolean(IS_LESS_OR_EQUAL[ONE][TWO])
p to_boolean(IS_LESS_OR_EQUAL[TWO][TWO])
p to_boolean(IS_LESS_OR_EQUAL[THREE][TWO])

=begin
MOD = -> m { -> n {
          IF[IS_LESS_OR_EQUAL[n][m]][
            -> x {
              MOD[SUBTRACT[m][n]][n][x]
            }
][ m
] }}

p to_integer(MOD[THREE][TWO])      
p to_integer(MOD[POWER[THREE][THREE]][ADD[THREE][TWO]])
=end

Y = -> f { -> x { f[x[x]] }[-> x { f[x[x]] }] }
Z = -> f { -> x { f[-> y { x[x][y] }] }[-> x { f[-> y { x[x][y] }] }] }

MOD =
       Z[-> f { -> m { -> n {
         IF[IS_LESS_OR_EQUAL[n][m]][
           -> x {
             f[SUBTRACT[m][n]][n][x]
} ][
m ]
} } }]

p to_integer(MOD[THREE][TWO])
p to_integer(MOD[POWER[THREE][THREE]][ADD[THREE][TWO]])

EMPTY = PAIR[TRUE][TRUE]
UNSHIFT = -> l { -> x {
    PAIR[FALSE][PAIR[x][l]] }}
IS_EMPTY = LEFT
FIRST = -> l { LEFT[RIGHT[l]]}
REST = -> l { RIGHT[RIGHT[l]]}

my_list = UNSHIFT[UNSHIFT[UNSHIFT[EMPTY][THREE]][TWO] ][ONE]
p to_integer(FIRST[my_list])
p to_integer(FIRST[REST[my_list]])
p to_integer(FIRST[REST[REST[my_list]]])
p to_boolean(IS_EMPTY[my_list])
p to_boolean(IS_EMPTY[EMPTY])

def to_array(proc)
  array = []
  until to_boolean(IS_EMPTY[proc])
    array.push(FIRST[proc])
    proc = REST[proc]
  end
  array
end

p to_array(my_list)
p to_array(my_list).map { |p| to_integer(p) }

RANGE =
       Z[-> f {
         -> m { -> n {
           IF[IS_LESS_OR_EQUAL[m][n]][
             -> x {
               UNSHIFT[f[INCREMENT[m]][n]][m][x]
             }
       ][
         EMPTY ]
    }  }
}]

my_range = RANGE[ONE][FIVE]
p to_array(my_range).map { |p| to_integer(p) }

FOLD = Z[-> f {
         -> l { -> x { -> g {
            IF[IS_EMPTY[l]][
             x
            ][
             -> y {
               g[f[REST[l]][x][g]][FIRST[l]][y]
              }
            ]
         }}}
         }
       ]
p to_integer(FOLD[RANGE[ONE][FIVE]][ZERO][ADD])
p to_integer(FOLD[RANGE[ONE][FIVE]][ONE][MULTIPLY])
MAP =
  -> k { -> f {
    FOLD[k][EMPTY][
      -> l { -> x { UNSHIFT[l][f[x]] } }
    ] }
}
my_list = MAP[RANGE[ONE][FIVE]][INCREMENT]
p to_array(my_list).map { |p| to_integer(p) }

TEN = MULTIPLY[TWO][FIVE]
B   = TEN
F   = INCREMENT[B]
I   = INCREMENT[F]
U   = INCREMENT[I]
ZED = INCREMENT[U]
FIZZ     = UNSHIFT[UNSHIFT[UNSHIFT[UNSHIFT[EMPTY][ZED]][ZED]][I]][F]
BUZZ     = UNSHIFT[UNSHIFT[UNSHIFT[UNSHIFT[EMPTY][ZED]][ZED]][U]][B]
FIZZBUZZ = UNSHIFT[UNSHIFT[UNSHIFT[UNSHIFT[BUZZ][ZED]][ZED]][I]][F]


def to_char(c)
  '0123456789BFiuz'.slice(to_integer(c))
end

def to_string(s)
  to_array(s).map { |c| to_char(c) }.join
end

p to_char(ZED)
p to_string(FIZZBUZZ)

DIV =
       Z[-> f { -> m { -> n {
         IF[IS_LESS_OR_EQUAL[n][m]][ -> x {
           INCREMENT[f[SUBTRACT[m][n]][n]][x] }
         ][ ZERO
          ]
       } } }]
PUSH = -> l {
         -> x {
           FOLD[l][UNSHIFT[EMPTY][x]][UNSHIFT]
  }
}


TO_DIGITS =
  Z[-> f { -> n { PUSH[
    IF[IS_LESS_OR_EQUAL[n][DECREMENT[TEN]]][
      EMPTY
    ][
      -> x {
        f[DIV[n][TEN]][x]
      }
    ]
  ][MOD[n][TEN]] } }]

p to_array(TO_DIGITS[FIVE]).map { |p| to_integer(p) }
p to_array(TO_DIGITS[POWER[FIVE][THREE]]).map { |p| to_integer(p) }

solution = 
  MAP[RANGE[ONE][HUNDRED]][-> n {
    IF[IS_ZERO[MOD[n][FIFTEEN]]][
      FIZZBUZZ
    ][
      IF[IS_ZERO[MOD[n][THREE]]][
        FIZZ
      ][
        IF[IS_ZERO[MOD[n][FIVE]]][
          BUZZ
        ][
          TO_DIGITS[n]
        ]
       ]
     ]
}]

to_array(solution).each do |p|
  puts to_string(p)
end
