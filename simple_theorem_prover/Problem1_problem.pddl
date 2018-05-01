(define (problem problem2)
        (:domain theorem_prover)
        (:objects 
            pointA pointB pointC pointD pointE pointF
        )
        (:init 
            (parallelogram pointA pointB pointC pointD)
            (contain pointA pointD pointF) (contain pointB pointC pointE)
            (contain pointD pointA pointF) (contain pointC pointB pointE)
            (parallel pointA pointE pointC pointF)
        )
        (:goal
            (and (congruent pointA pointB pointE pointC pointD pointF)
            )
        )
)

