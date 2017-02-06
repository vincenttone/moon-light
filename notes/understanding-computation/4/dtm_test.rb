# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/dtm.rb'

p tape = Tape.new(['1', '0', '1'], '1', [], '_')
p tape.middle
p tape.move_head_left
p tape.write('0')
p tape.move_head_right
p tape.move_head_right.write('0')

p '-------------'
p rule = TMRule.new(1, '0', 2, '1', :right)
p rule.applies_to?(TMConfiguration.new(1, Tape.new([], '0', [], '_')))
p rule.applies_to?(TMConfiguration.new(1, Tape.new([], '1', [], '_')))
p rule.applies_to?(TMConfiguration.new(2, Tape.new([], '0', [], '_')))

p '------'
p rule.follow(TMConfiguration.new(1, Tape.new([], '0', [], '_')))

p '----------'
p rulebook = DTMRulebook.new([
                            TMRule.new(1, '0', 2, '1', :right),
                            TMRule.new(1, '1', 1, '0', :left),
                            TMRule.new(1, '_', 2, '1', :right),
                            TMRule.new(2, '0', 2, '0', :right),
                            TMRule.new(2, '1', 2, '1', :right),
                            TMRule.new(2, '_', 3, '_', :left)
                           ])
p configuration = TMConfiguration.new(1, tape)
p configuration = rulebook.next_configuration(configuration)
p configuration = rulebook.next_configuration(configuration)
p configuration = rulebook.next_configuration(configuration)

p '--------'
p dtm = DTM.new(TMConfiguration.new(1, tape), [3], rulebook)
p dtm.current_configuration
p dtm.accepting?
p dtm.step
p dtm.current_configuration
p dtm.accepting?
dtm.run
p dtm.current_configuration
p dtm.accepting?

p '-------'
tape = Tape.new(['1', '2', '1'], '1', [], '_')
dtm = DTM.new(TMConfiguration.new(1, tape), [3], rulebook)
dtm.run
p dtm.current_configuration
p dtm.accepting?
p dtm.stuck?

p '-----------'
p rulebook = DTMRulebook.new([
                            TMRule.new(1, 'X', 1, 'X', :right),
                              TMRule.new(1, 'a', 2, 'X', :right),
                            TMRule.new(1, '_', 6, '_', :left),
                            TMRule.new(4, 'c', 4, 'c', :right),
                            TMRule.new(4, '_', 5, '_', :left),
                            TMRule.new(5, 'a', 5, 'a', :left),
                            TMRule.new(5, 'b', 5, 'b', :left),
                            TMRule.new(5, 'c', 5, 'c', :left),
                            TMRule.new(5, 'X', 5, 'X', :left),
                            TMRule.new(5, '_', 1, '_', :right)
                           ])
p tape = Tape.new([], 'a', ['a', 'a', 'b', 'b', 'b', 'c', 'c', 'c'], '_')
dtm = DTM.new(TMConfiguration.new(1, tape), [6], rulebook)
10.times { dtm.step }
p dtm.current_configuration
25.times { dtm.step }
p dtm.current_configuration
