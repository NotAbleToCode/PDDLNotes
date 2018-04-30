# 一.PDDL简介  
PDDL = Planning Domain Definition Language，用来规范规划问题中问题表示形式的语言。  
## 1.PDDL中的语法成分
一个PDDL的语法基本由以下成分组成：  
Objects：模型中的对象。  
Predicates：对象的一些基本性质，可以为真或假。  
Initial state：模型的初始状态。  
Goal specification：模型的最终状态。  
Actions/Operators：状态转移的动作模型。
## 2.PDDL的文件组成
一个用PDDL表示的规划问题一般应该划分为两个文件：  
Domain file：里面有predicates和actions，即对模型的总体性质进行了一个定义。这个模型里一共有哪些属性(函数原语描述的属性)，
对这些属性又有什么操作。  
Problem file：里面有objects,initial state和goal specification，是对Domain file中的一个特例化，
定义了一系列对象，这些对象默认有Domain file中的所有属性。initial state和goal state是对objects中一些
属性规定真假后的表示。并不一定规定所有属性，只规定那些我们关注的属性即可。  
# 二.PDDL基本语法
## 1.Domain File
Domain file中的代码框架如下：
```pddl
(define (domain <domain name>)
    <PDDL code for requirements>
    <PDDL code for predicates>
    <PDDL code for first action>
    ...
    <PDDL code for last action>
)
```
### 1) requirements部分
一些\<GD>和\<effect>需要扩展的操作，这些操作的类型需要在该部分声明。
代码框架为：
```pddl
(:requirements :<name1> :<name2> ...)
```
在之后介绍\<GD>和\<effect>时，需要声明的操作会在Description最后说明。
### 2) Predicates
描述该成分的框架为：
```pddl
(:predicates (<function_name1> ?x ?y ...)
             (<function_name2> ?x ?y ...)
             ...
)
```
Predicates中描述的是用函数原语描述的属性，函数原语的名字往往代表性质。其后有若干变量，通过对这些变量的实例化，可以对
变量赋予属性。  
### 3) Actions  
描述该成分的框架为：
```pddl
(:action <action_name> 
    :parameters (?x ?y ...)
    :precondition <GD>)
    :effect <effect>)
```
该部分是关键部分。  
动作可以实例化，参数列表中的变量被赋予具体的对象后便可实例化出一个动作。  
`<GD>`和`<effect>`语法在附录以及扩展语法中给出详细介绍。
## 2.Problem File
Problem file中的代码框架如下：
```pddl
(define (problem <problem name>)
(:domain <domain name>)
<PDDL code for objects>
<PDDL code for initial state>
<PDDL code for goal specification>
)
```
### 1) Objects
描述该成分的框架为:
```pddl
(:objects <object_name1> <object_name2> ...)
```
Objects部分定义了模型中的对象，这些对象会被Predicates部分赋予属性，然后由Actions部分来根据这些属性对它们进行操作。
### 2) Initial State
描述该部分的代码框架如下：
```pddl
(:init (<function_name1> <objects_name1> <objects_name2> ...)
       (<function_name2> <objects_name1> <objects_name2> ...)
       ...
       (= (f-head1) <number>)
       (= (f-head2) <number>)
       ...
)
```
该部分是对Objects中的对象赋予属性。有两种情况，一种是predicates部分中声明的二元属性，一种是functions部分中声明的
数字属性。functions部分的语法可在进阶部分了解。
### 3) Goal Specification
描述该成分的框架为：
```pddl
(:goal <GD>)
```
该部分描述了目标状态。只要当前状态蕴含目标状态即返回。  
\<GD>的语法在附录中给出。
## 3.附录
### 1)`<GD>`
以下叙述基于递归的思想给出`<GD>`的基本语法：  
```pddl
<GD> ::= ()  
Description:<GD>可以是一个只有一个括号的空语句。

<GD> ::= (<atomic formula(term)>)  
Description:<GD>可以是一个predicates中的函数原语。

<GD> ::= (and <GD>∗)  
Description:<GD>可以是一系列的<GD>的合取。  

<GD> ::=(or <GD>∗)  
Description:<GD>可以是一系列的<GD>的析取。：disjunctive−preconditions  

<GD> ::=(not <GD>)  
Description:<GD>可以是一个<GD>的否定。：disjunctive−preconditions  

<GD> ::=(imply <GD1> <GD2>)  
Description:<GD1>可以推导出<GD2>。：isjunctive−preconditions

<term> ::= <name>
Description:<term>可以是一个objects中的名字，用于problem文件中的goal部分。

<term> ::= <variable>
Description:<term>可以是一个未实例化的变量，用于domain文件中的action部分中的precondition部分。
```
### 2)`<effect>`
```
<effect> ::= ()  
Description:<effect>可以是一个空括号表示的空语句。

<effect> ::= <c-effect>  
Description:<effect>可以是一个<c-effect>。 

<effect> ::= (and <c-effect>∗)  
Description:<effect>可以是一系列<c-effect>的合取。  

<c-effect> ::=(forall (variable>∗) <effect>)  
Description:普适性结果，对所有的变量都有effect成立。:conditional−effects  

<c-effect> ::=(when <GD> <cond-effect>)  
Description:条件结果，当<GD>成立时才发生该效果。:conditional−effects

<c-effect> ::= <p-effect>  
Description:<c-effect>可以是一个<p-effect>。

<p-effect> ::= <atomic formula(term)>  
Description:<p-effect>可以是函数原语描述的对象属性，该属性加到该对象上。  

<p-effect> ::= (not <atomic formula(term)>)  
Description:<p-effect>可以是一个函数原语描述的对象属性的否定，表示将该属性从该对象中剔除。

<cond-effect> ::= <p-effect>  
Description:<cond-effect>可以是一个<p-effect>。

<cond-effect> ::= (and <p-effect>∗)  
Description:<cond-effect>可以是一系列<p-effect>的合取。
```
# 三.PDDL进阶语法 
待补充：  
Domain、Problem文件里面还有一些未涉及的部分。  
\<GD>和\<effect>还有一些高阶语法。  
以后会慢慢补充。
## 2.functions部分以及对应的操作
在domain文件中可以增加function部分，框架如下：
```pddl
(:functions (number1 ?x ?y ...) 
            (number2 ?x ?y ...) 
)
```
function部分和predicates部分类似，也是赋予对象属性，只是predicates部分赋予的是二元属性，即一个
对象要么有predicates声明的属性，要么没有，是一个True或者False的属性。但是functions部分中赋予的是
数字属性，可以对数字属性做加、减、乘、除以及判断大小操作。  
对functions部分可以相应增加`<GD>`和`<effect>`中的操作来实现加减乘除等操作，接附录中内容并扩展如下：
### 1）`<GD>`
```pddl
<GD> ::= <f-comp>
Description:<GD>可以是一个<f-comp>，即一个比较(compare)语句。

<f-comp> ::= (<binary-comp> <f-exp> <f-exp>)
Description:<f-comp>可以是一个由<binary-comp> <f-exp1> <f-exp2>组成的语句。
分别为二元比较操作符，左、右操作数。:fluents 

<f-exp> ::= <number>
Description:<f-exp>可以是一个数字。

<f-exp> ::= (<binary-op> <f-exp1> <f-exp2>)
Description:<f-exp>可以是一个由<binary-op> <f-exp1> <f-exp2>组成的语句。分别为二元运算操作符，左、右操作数

<f-exp> ::= (- <f-exp>)
Description:<f-exp>可以是一个<f-exp>取负。

<f-exp> ::= <f-head>
Description:<f-exp>可以是一个<f-head>。

<f-head> ::= (<function-symbol> <term>*)
Description:<f-exp>可以是一个functions中赋予一个对象的属性。<term>*表示多个<term>。
比如在functions中声明一个(speed ?x)，在init中可以用(= (speed car) 0）)来给car对象赋予speed这一个数字属性，并初始化为0。
那么在precondition中可以用( = (speed ?x) 100)来判断传入的对象的speed是否大于100。
或在goal中用(= (speed car) 100)来判断目标对象car的速度是否等于100。
注意init中的’=‘是赋值，其余是比较。

<f-head> ::= <function-symbol>
Description:<f-head>可以单纯的为一个functions中一个标志。
比如在functions中声明一个(speed)，在init中可以用(= (speed) 0)来给speed直接赋值为0。此时的speed可以理解为一个全局变量
那么这一个speed也支持(= (speed) 100)这样的操作。

<binary-op> ::= +
<binary-op> ::= −
<binary-op> ::= ∗
<binary-op> ::= /
<binary-comp> ::= >
<binary-comp> ::= <
<binary-comp> ::= =
<binary-comp> ::= >=
<binary-comp> ::= <=
Description:一些二元运算操作符和二元比较运算符。
```
### 2)`<effect>`
```pddl
<p-effect> ::= (<assign-op> <f-head> <f-exp>)
Description:一个<p-effect>可以是一个由<assign-op> <f-head> <f-exp>组成的语句。:fluents

<assign-op> ::= assign
Description:将<f-exp>的值赋给<f-head>。

<assign-op> ::= scale-up
Description:按照<f-exp>对<f-head>成比例增加。

<assign-op> ::= scale-down
Description:按照<f-exp>对<f-head>成比例缩减。

<assign-op> ::= increase
Description:将<f-head>增加<f-exp>。

<assign-op> ::= decrease
Description:将<f-head>减小<f-exp>。
```

# 四.使用SMTPlan对PDDL进行求解
SMTPlan是Github上一个开源项目。链接如下：  
http://kcl-planning.github.io/SMTPlan/  
推荐使用UNIX或者类UNIX系统进行配置。  
