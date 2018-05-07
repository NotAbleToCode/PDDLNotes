(define (domain theorem_prover)
        (:predicates
            (contain ?a ?b ?c) ;b点是否在线段ac上
            (parallelogram ?a ?b ?c ?d) ;abcd是否为平行四边形
            (parallel ?a1 ?b1 ?a2 ?b2) ;a1b1是否和a2b2平行
            (edge_equal ?a1 ?b1 ?a2 ?b2) ;a1ba是否和a2b2相等
            (angle_equal ?a1 ?b1 ?c1 ?a2 ?b2 ?c2) ;角a1b1c1是否和角a2b2c2相等
            (congruent ?a1 ?b1 ?c1 ?a2 ?b2 ?c2) ;三角形a1b1bc1是否和三角形a2b2c2全等
        )
        ;边相等的对称性
        (:action edge_equal_symmetry
            :parameters (?a ?b ?c ?d)
            :precondition (and (edge_equal ?a ?b ?c ?d))
            :effect (and    (edge_equal ?a ?b ?d ?c) 
                            (edge_equal ?b ?a ?c ?d)
                            (edge_equal ?b ?a ?d ?c) 
                            (edge_equal ?c ?d ?a ?b)
                            (edge_equal ?d ?c ?a ?b)
                            (edge_equal ?c ?d ?b ?a)
                            (edge_equal ?d ?c ?b ?a)
            )
        ) 
        ;边平行的对称性
        (:action edge_parallel_symmetry
            :parameters (?a ?b ?c ?d)
            :precondition (and (parallel ?a ?b ?c ?d))
            :effect (and    (parallel ?a ?b ?d ?c) 
                            (parallel ?b ?a ?c ?d)
                            (parallel ?b ?a ?d ?c)
                            (parallel ?c ?d ?a ?b)
                            (parallel ?d ?c ?a ?b)
                            (parallel ?c ?d ?b ?a)
                            (parallel ?d ?c ?b ?a) 
            )
        ) 
        ;角相等的对称性
        (:action angle_equal_symmetry
            :parameters (?a1 ?b1 ?c1 ?a2 ?b2 ?c2)
            :precondition (and (angle_equal ?a1 ?b1 ?c1 ?a2 ?b2 ?c2))
            :effect (and    (angle_equal ?a1 ?b1 ?c1 ?c2 ?b2 ?a2)
                            (angle_equal ?c1 ?b1 ?a1 ?a2 ?b2 ?c2)
                            (angle_equal ?c1 ?b1 ?a1 ?c2 ?b2 ?a2)
                            (angle_equal ?a2 ?b2 ?c2 ?a1 ?b1 ?c1)
                            (angle_equal ?c2 ?b2 ?a2 ?a1 ?b1 ?c1)
                            (angle_equal ?a2 ?b2 ?c2 ?c1 ?b1 ?a1)
                            (angle_equal ?c2 ?b2 ?a2 ?c1 ?b1 ?a1)
            )
        ) 
        ;两个角相等，则子角也相等
        (:action Sub_angle_is_equal
            :parameters (?a ?b ?c ?d ?e ?f)
            :precondition (and (angle_equal ?a ?b ?c ?c ?d ?a) 
                               (contain ?b ?c ?e)
                               (contain ?d ?a ?f)
            )
            :effect (angle_equal ?a ?b ?e ?c ?d ?f)
        )
        ;平行的两条边的子边也平行
        (:action Sub_edge_is_parallel
            :parameters (?a1 ?b1 ?x1 ?a2 ?b2 ?x2)    
            :precondition (and (contain ?a1 ?b1 ?x1) (contain ?a2 ?b2 ?x2)
                               (parallel ?a1 ?b1 ?a2 ?b2) 
            )
            :effect (and (parallel ?a1 ?x1 ?a2 ?x2)
                         (parallel ?a1 ?x1 ?x2 ?b2)
                         (parallel ?x1 ?b1 ?a2 ?x2)
                         (parallel ?x1 ?b1 ?x2 ?b2)
            )
        )
        ;相等的传递性
        (:action Equal_transmit
            :parameters (?a ?b ?c ?d ?e ?f)
            :precondition (and (angle_equal ?a ?e ?b ?f ?c ?e) 
                               (angle_equal ?f ?c ?e ?c ?f ?d)
                          )
            :effect (and (angle_equal ?a ?e ?b ?c ?f ?d))
        )
        ;平行四边形性质
        (:action ParallelogramNature
            :parameters (?a ?b ?c ?d )
            :precondition (and (parallelogram ?a ?b ?c ?d) )
            :effect (and (parallel ?a ?b ?d ?c)
                         (parallel ?a ?d ?b ?c)
                         (edge_equal ?a ?b ?d ?c)
                         (edge_equal ?a ?d ?b ?c)
                         (angle_equal ?a ?b ?c ?c ?d ?a)
                         (angle_equal ?b ?a ?d ?d ?c ?b)
            )
        )
        ;内错角相等
        (:action Inside_angle_equal
            :parameters (?a1 ?b1 ?a2 ?b2)
            :precondition (and (parallel ?a1 ?b1 ?a2 ?b2))
            :effect (and (angle_equal ?b1 ?a1 ?b2 ?a2 ?b2 ?a1))
        )
        ;同位角相等
        (:action Isotopic_angle_equal
            :parameters (?a1 ?b1 ?a2 ?b2 ?c)
            :precondition (and (parallel ?a1 ?b1 ?a2 ?b2) (contain ?c ?b2 ?b1))
            :effect (and (angle_equal ?a1 ?b1 ?c ?a2 ?b2 ?b1))
        )
        ;三角形全等判定
        (:action isCongruentTriangles
            :parameters (?a1 ?b1 ?c1 ?a2 ?b2 ?c2)
            :precondition (and (angle_equal ?a1 ?b1 ?c1 ?a2 ?b2 ?c2)
                                (angle_equal ?a1 ?c1 ?b1 ?a2 ?c2 ?b2)
                                (edge_equal ?a1 ?b1 ?a2 ?b2)
            )
            :effect (and (congruent ?a1 ?b1 ?c1 ?a2 ?b2 ?c2))
        )
)