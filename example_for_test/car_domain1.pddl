(define (domain car)
(:requirements :typing :durative-actions :fluents :time :negative-preconditions :timed-initial-literals)

(:predicates (running) (stopped) (engineBlown) (transmission_fine) (goal_reached) )

(:functions (d) (v) (a) (up_limit) (down_limit) (running_time) )

(:process moving
:parameters ()
:precondition (and (running))
:effect (and (increase (v) (* #t (a)))
             (increase (d) (* #t (v)))
	     (increase (running_time) (* #t 1))
)
)

(:action accelerate
  :parameters()
  :precondition (and (running) (< (a) (up_limit)))
  :effect (and (increase (a) 1))
)

(:action decelerate
  :parameters()
  :precondition (and (running) (> (a) (down_limit)))
  :effect (and (decrease (a) 1))
)

(:event engineExplode
:parameters ()
:precondition (and (running) (>= (a) 1) (>= (v) 100))
:effect (and (not (running)) (engineBlown) (assign (a) 0))
)

(:action stop
:parameters()
:precondition(and (= (v) 0) (>= (d) 30) (not (engineBlown)) )
:effect(goal_reached)
)

)

该例子中predicates中和functions中的属性全部作为全局变量。当研究对象只有一个时，用全局变量更方便些。
由于有一些比较操作符，因此requirements中要有:fluents，由于有not，故还要添加:negative-preconditions.

