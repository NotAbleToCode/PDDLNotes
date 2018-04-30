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
    <PDDL code for predicates>
    <PDDL code for first action>
    ...
    <PDDL code for last action>
)
```
### 1) Predicates
描述该成分的框架为：
```pddl
(:predicates (<function_name1> ?x ?y ...)
             (<function_name2> ?x ?y ...)
             ...
)
```
Predicates中描述的是用函数原语描述的属性，函数原语的名字往往代表性质。其后有若干变量，通过对这些变量的实例化，可以对
变量赋予属性。  
### 2) Actions  
描述该成分的框架为：
```pddl
(:action <action_name> 
    :parameters (?x ?y ...)
    :precondition <GD>)
    :effect <effect>)
```
该部分是关键部分。  
动作可以实例化，参数列表中的变量被赋予具体的对象后便可实例化出一个动作。  
\<GD>和\<effect>语法在附录中给出。
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
       (<function_name3> <objects_name1> <objects_name2> ...) 
)
```
该部分是对Domain文件中的Predicates部分中的函数原语进行实例化，实例化的对象由Problem文件中的Objects部分给出。
### 3) Goal Specification
描述该成分的框架为：
```pddl
(:goal <GD>)
```
该部分描述了目标状态。只要当前状态蕴含目标状态即返回。  
\<GD>的语法在附录中给出。
## 3.附录
### 1)\<GD>
以下叙述基于递归的思想给出\<GD>的基本语法：  
\<GD> ::= ()  
_Description:\<GD>可以是一个只有一个括号的空语句。_  

\<GD> ::= (<atomic formula(term)>)  
_Description:\<GD>可以是一个函数原语。_  

\<GD> ::= (and \<GD>∗)  
_Description:\<GD>可以是一系列的\<GD>的合取。_  

\<GD> ::=(or \<GD>∗)  
_Description:\<GD>可以是一系列的\<GD>的析取。_  

\<GD> ::=(not \<GD>)  
_Description:\<GD>可以是一个\<GD>的否定。_  

\<GD> ::=(imply \<GD1> \<GD2>)  
_Description:\<GD1>可以推导出\<GD2>_  

### 2)\<effect>
\<effect> ::= ()  
_Description:<effect>可以是一个空括号表示的空语句。_

\<effect> ::= \<c-effect>  
_Description:\<effect>可以是一个\<c-effect>。_ 

\<effect> ::= (and \<c-effect>∗)  
_Description:\<effect>可以是一系列\<c-effect>的合取。_  

\<c-effect> ::=(forall (\variable>∗) \<effect>)  
_Description:普适性结果，对所有的变量都有effect成立。_  

\<c-effect> ::=(when \<GD> \<cond-effect>)  
_Description:条件结果，当\<GD>成立时才发生该效果。_

\<c-effect> ::= \<p-effect>  
_Description:\<c-effect>可以是一个\<p-effect>。_

\<p-effect> ::= \<atomic formula(term)>  
_Description:\<p-effect>可以是函数原语描述的对象属性，该属性加到该对象上。_  

\<p-effect> ::= (not \<atomic formula(term)>)  
_Description:\<p-effect>可以是一个函数原语描述的对象属性的否定，表示将该属性从该对象中剔除。_

\<cond-effect> ::= \<p-effect>  
_Description:\<cond-effect>可以是一个\<p-effect>。_

\<cond-effect> ::= (and \<p-effect>∗)  
_Description:\<cond-effect>可以是一系列\<p-effect>的合取。_
 
# 三.PDDL进阶语法

待补充：  
Domain、Problem文件里面还有一些未涉及的部分。  
\<GD>和\<effect>还有一些高阶语法。
 
# 四.使用SMTPlan对PDDL进行求解
SMTPlan是Github上一个开源项目。链接如下：  
http://kcl-planning.github.io/SMTPlan/  
推荐使用UNIX或者类UNIX系统进行配置。  
