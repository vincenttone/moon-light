require File.dirname(__FILE__) + '/fizzbuzz.rb'

p to_integer(ZERO)
p to_integer(ONE)
p to_integer(TWO)
p to_integer(THREE)
p to_integer(FIVE)
p to_integer(FIFTEEN)
p to_integer(HUNDRED)

p to_boolean(TRUE)

p IF[TRUE]['happy']['sad']
p IF[FALSE]['happy']['sad']

p to_boolean(IS_ZERO[ZERO])
p to_boolean(IS_ZERO[THREE])

my_pair = PAIR[THREE][FIVE]
p to_integer(LEFT[my_pair])
p to_integer(RIGHT[my_pair])

p to_integer(DECREMENT[FIVE])
p to_integer(DECREMENT[FIFTEEN])
p to_integer(DECREMENT[HUNDRED])
p to_integer(DECREMENT[ZERO])

p to_integer(ADD[FIVE][HUNDRED])
p to_integer(SUBTRACT[HUNDRED][FIVE])
p to_integer(MULTIPLY[HUNDRED][FIVE])
p to_integer(POWER[FIVE][TWO])

p to_boolean(IS_LESS_OR_EQUAL[ONE][TWO])
p to_boolean(IS_LESS_OR_EQUAL[TWO][TWO])
p to_boolean(IS_LESS_OR_EQUAL[THREE][TWO])

p to_integer(MOD[THREE][TWO])
p to_integer(MOD[POWER[THREE][THREE]][ADD[THREE][TWO]])

my_list = UNSHIFT[UNSHIFT[UNSHIFT[EMPTY][THREE]][TWO] ][ONE]
p to_integer(FIRST[my_list])
p to_integer(FIRST[REST[my_list]])
p to_integer(FIRST[REST[REST[my_list]]])
p to_boolean(IS_EMPTY[my_list])
p to_boolean(IS_EMPTY[EMPTY])

p to_array(my_list)
p to_array(my_list).map { |p| to_integer(p) }

my_range = RANGE[ONE][FIVE]
p to_array(my_range).map { |p| to_integer(p) }

p to_integer(FOLD[RANGE[ONE][FIVE]][ZERO][ADD])
p to_integer(FOLD[RANGE[ONE][FIVE]][ONE][MULTIPLY])

my_list = MAP[RANGE[ONE][FIVE]][INCREMENT]
p to_array(my_list).map { |p| to_integer(p) }

p to_char(ZED)
p to_string(FIZZBUZZ)

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
