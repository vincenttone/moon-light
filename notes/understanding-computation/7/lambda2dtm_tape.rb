require File.dirname(__FILE__) + '/../6/fizzbuzz.rb'

TAPE = -> l {
  -> m {
    -> r {
      -> b {
        PAIR[PAIR[l][m]][PAIR[r][b]]
      }
    }
  }
}
TAPE_LEFT = -> t {
  LEFT[LEFT[t]]
}
TAPE_MIDDLE = -> t {
  RIGHT[LEFT[t]]
}
TAPE_RIGHT = -> t {
  LEFT[RIGHT[t]]
}
TAPE_BLANK = -> t {
  RIGHT[RIGHT[t]]
}
TAPE_WRITE = -> t {
  -> c {
    TAPE[TAPE_LEFT[t]][c][TAPE_RIGHT[t]][TAPE_BLANK[t]]
  }
}
TAPE_MOVE_HEAD_RIGHT = -> t {
  TAPE[ # left
    PUSH[TAPE_LEFT[t]][TAPE_MIDDLE[t]]
  ][ # middle
    IF[IS_EMPTY[TAPE_RIGHT[t]]][
      TAPE_BLANK[t]
    ][
      FIRST[TAPE_RIGHT[t]]
    ]
  ][ # right
    IF[IS_EMPTY[TAPE_RIGHT[t]]][
      EMPTY
    ][
      REST[TAPE_RIGHT[t]]
    ]
  ][
    TAPE_BLANK[t]
  ]
}

current_tape = TAPE[EMPTY][ZERO][EMPTY][ZERO]
current_tape = TAPE_WRITE[current_tape][ONE]
current_tape = TAPE_MOVE_HEAD_RIGHT[current_tape]
current_tape = TAPE_WRITE[current_tape][TWO]
current_tape = TAPE_MOVE_HEAD_RIGHT[current_tape]
current_tape = TAPE_WRITE[current_tape][THREE]
current_tape = TAPE_MOVE_HEAD_RIGHT[current_tape]
p to_array(TAPE_LEFT[current_tape]).map { |p| to_integer(p) }
p to_integer(TAPE_MIDDLE[current_tape])
p to_array(TAPE_RIGHT[current_tape]).map { |p| to_integer(p) }
