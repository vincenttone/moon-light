require File.dirname(__FILE__) + '/nav.rb'

p Sign::POSITIVE * Sign::POSITIVE
p Sign::NEGATIVE * Sign::ZERO
p Sign::POSITIVE * Sign::NEGATIVE

p 6.sign
p -9.sign
p 6.sign * -9.sign

p calculate(3, -5, 0)
p calculate(Sign::POSITIVE, Sign::NEGATIVE, Sign::ZERO)

p Sign::NEGATIVE + Sign::POSITIVE

p (Sign::POSITIVE + Sign::NEGATIVE) * Sign::ZERO + Sign::POSITIVE

p Sign::POSITIVE <= Sign::POSITIVE
p Sign::POSITIVE <= Sign::NEGATIVE
p (6 * -9).sign <= (6.sign * -9.sign)
