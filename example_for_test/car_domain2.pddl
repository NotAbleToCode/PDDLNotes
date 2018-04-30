(define (domain car)
(:requirements  :fluents :negative-preconditions :time)


(:predicates (running ?x) (stopped ?x) (engineBlown ?x) (transmission_fine ?x) (goal_reached ?x) )

(:functions (d ?x) (v ?x) (a ?x) (up_limit ?x) (down_limit ?x) (running_time ?x) )

(:process moving
:parameters (?x)
:precondition (and (running ?x))
:effect (and (increase (v ?x) (* #t (a ?x)))
             (increase (d ?x) (* #t (v ?x)))
	     (increase (running_time ?x) (* #t 1))
)
)



(:action accelerate
  :parameters(?x)
  :precondition (and (running ?x) (< (a ?x) (up_limit ?x)))
  :effect (and (increase (a ?x) 1))
)

(:action decelerate
  :parameters(?x)
  :precondition (and (running ?x) (> (a ?x) (down_limit ?x)))
  :effect (and (decrease (a ?x) 1))
)



(:event engineExplode
:parameters (?x)
:precondition (and (running ?x) (>= (a ?x) 1) (>= (v ?x) 100))
:effect (and (not (running ?x)) (engineBlown ?x) (assign (a ?x) 0))
)

(:action stop
:parameters(?x)
:precondition(and (= (v ?x) 0) (>= (d ?x) 30) (not (engineBlown ?x)) )
:effect(goal_reached ?x)
)

)
该例子可以类比car_domain1.pddl，该例子中没有全局变量，将全部的全局变量都变为一个物体的属性。
建议按照这种形式来写，因为这些都是物体的属性，要有面向对象编写的思想，当objects多起来并互相作用时，也必须这样来写。