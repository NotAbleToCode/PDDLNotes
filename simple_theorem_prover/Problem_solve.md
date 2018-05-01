# 自动定理证明器
## 一.简介
该部分尝试使用PDDL实现对一些简单的几何题的证明。  
问题全部默认在欧式几何中研究。  
## 二.实现思路
参考欧几里得的《几何原本》，其是由23个定义出发，接著是十条几何公理与一般公理。由这些定义、公理，便可以导出其余的定理和命题。  
因此，从理论上来说，只要将所有定义和基础公理转化为PDDL语言，那么对任意为真的命题，总可以在有限步数内求解出来。  
不过实际操作时，没有必要将全部的定义和公理列出，只列出涉及到的即可。同时还应该加入一些基本的定理来加快求解速度。  
## 三.实现步骤 
首先要考虑的是如何将问题的描述转化为PDDL语言。  
一道简单的平面几何问题，涉及的基本对象有点，线，角等。复杂一点的还会有圆。  
那么如何表示这些对象？  
### 1.Problem1
在Problem1中，尝试用点来表示所有的对象。也就是说，以点为研究对象，两个点可以表示一条边，三个点可以表示
一个三角形，或者一个角。  
只用点表示所有元素的好处是，点是最基本的元素，因此在表达起来相对容易。  
只用点表示的坏处是  
1）点元素太基本了，以致于表达会相对复杂。  
2）用点表达会出现对偶性，会使属性变得特别多。
比如(parallel a b c d)表示ab平行于cd，那么根据点的对偶性，同时我们也应该有(parallel a b d c)
(parallel b a c d)(parallel b a d c)；根据边的对偶型，同时也有(parallel c d a b)
(parallel d c a b)(parallel c d b a)(parallel d c b a)。这样一下子便多出七个属性。而属性越多，
程序便会运行越慢。在该例子中，为满足对偶型，特别加上几个action，而且该例子花费大约3min40s的时间，运行
的相当慢了。  
3）只用点表示的话，容易在action的precondition处发生矛盾。比如两个三角形全等判定时，
可以写作
```pddl
(:action isCongruentTriangles
    :parameters (?a1 ?b1 ?c1 ?a2 ?b2 ?c2)
    :precondition (and (angle_equal ?a1 ?b1 ?c1 ?a2 ?b2 ?c2)
                        (angle_equal ?a1 ?c1 ?b1 ?a2 ?c2 ?b2)
                        (edge_equal ?a1 ?b1 ?a2 ?b2)
    )
    :effect (and (congruent ?a1 ?b1 ?c1 ?a2 ?b2 ?c2))
)  
```
看起来并无毛病，但要注意这里6个点在pddl语言中是默认互不相同的，但是在实际证明中a1和b1（或者其他的点对）有
可能是同一个点！如果出现这种情况，那么原本可以满足的全等情况便不可能满足了。  
这时候便需要看看实际问题中哪些点是相同的，将相同的点写成同一个变量放在parameters里，然后在precondition
和effect中将这些变量写为同一个变量。然而，这样做相当于将一个普适性的结论特例化了。在pddl语言中，我们追求
的正是对任意问题的普适性。
该例中，动作
```pddl
(:action Equal_transmit
    :parameters (?a ?e ?b ?c ?f ?d)
    :precondition (and (angle_equal ?a ?e ?b ?f ?c ?e) 
                        (angle_equal ?f ?c ?e ?c ?f ?d)
                    )
    :effect (and (angle_equal ?a ?e ?b ?c ?f ?d))
)
```
原本想表达角度之间'='的传递性，即
```pddl
(:action Equal_transmit
    :parameters (?a1 ?b1 ?c1 ?a2 ?b2 ?c2 ?a3 ?b3 ?c3)
    :precondition (and (angle_equal ?a1 ?b1 ?c1 ?a2 ?b2 ?c2) 
                       (angle_equal ?a2 ?b2 ?c2 ?a3 ?b3 ?c3)
                    )
    :effect (and (angle_equal ?a1 ?b1 ?c1 ?a3 ?b3 ?c3))
)
```
但由于实际情况中出现a1=c2...等情况，只能将它特例化一下了。  
这样对一般问题，任何两个点都有可能相等，要实现普适性问题的话，要写的action数量是无法想象的。  
现阶段解决思路是，在点上再抽象出来边，点+边抽象出来角。或许可以避免这种问题。之后的问题求解会采用这一思路。  

该例子中只有点这一基本对象。domain文件中代码如下：
```pddl
(define (domain theorem_prover)
        (:predicates
            (contain ?a ?b ?c) //直线ab上有c点
            (parallelogram ?a ?b ?c ?d) //abcd为平行四边形
            (parallel ?a1 ?b1 ?a2 ?b2) //a1b1和a2b2平行
            (edge_equal ?a1 ?b1 ?a2 ?b2) //边长度相等
            (angle_equal ?a1 ?b1 ?c1 ?a2 ?b2 ?c2) //角角度相等
            (congruent ?a1 ?b1 ?c1 ?a2 ?b2 ?c2) //互为全等三角形
        )
        (:action edge_equal_symmetry //边相等的对偶性
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
        (:action edge_parallel_symmetry //边平行的对偶性
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
        (:action angle_equal_symmetry //角相等的对偶性
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
        (:action Sub_angle_is_equal 
        //两个角相等，三个点表示的那个角的一条边上任意取一点，和另外两点组成的角和原来的角仍然相等
            :parameters (?a ?b ?c ?d ?e ?f)
            :precondition (and (angle_equal ?a ?b ?c ?c ?d ?a) 
                               (contain ?b ?c ?e)
                               (contain ?d ?a ?f)
            )
            :effect (angle_equal ?a ?b ?e ?c ?d ?f)
        )
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
        (:action Equal_transmit //相等的传递性，这里有些特例化了
            :parameters (?a ?b ?c ?d ?e ?f)
            :precondition (and (angle_equal ?a ?e ?b ?f ?c ?e) 
                               (angle_equal ?f ?c ?e ?c ?f ?d)
                          )
            :effect (and (angle_equal ?a ?e ?b ?c ?f ?d))
        )
        (:action ParallelogramNature //平行四边形性质
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
        (:action Inside_angle_equal //内错角相等
            :parameters (?a1 ?b1 ?a2 ?b2)
            :precondition (and (parallel ?a1 ?b1 ?a2 ?b2))
            :effect (and (angle_equal ?b1 ?a1 ?b2 ?a2 ?b2 ?a1))
        )
        (:action Isotopic_angle_equal //同位角相等
            :parameters (?a1 ?b1 ?a2 ?b2 ?c)
            :precondition (and (parallel ?a1 ?b1 ?a2 ?b2) (contain ?c ?b2 ?b1))
            :effect (and (angle_equal ?a1 ?b1 ?c ?a2 ?b2 ?b1))
        )
        (:action isCongruentTriangles //全等三角形判定
            :parameters (?a1 ?b1 ?c1 ?a2 ?b2 ?c2)
            :precondition (and (angle_equal ?a1 ?b1 ?c1 ?a2 ?b2 ?c2)
                                (angle_equal ?a1 ?c1 ?b1 ?a2 ?c2 ?b2)
                                (edge_equal ?a1 ?b1 ?a2 ?b2)
            )
            :effect (and (congruent ?a1 ?b1 ?c1 ?a2 ?b2 ?c2))
        )
)
```  
