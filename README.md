# streem.rb / RbStreem

Try to implement [matz/streem](https://github.com/matz/streem) as a DSL of Ruby with a little syntax sacrifice.

All this work based on [commit 8dba5e8](https://github.com/matz/streem/commit/8dba5e83e4a4e319e1ae4754a1aef455e12b411c).


## Reference

I will list the original paper or book, but I will also list the corresponding Chinese version.

[Abl83] introduces a interesing system: **propagation of constraints(约束传播)** in **section 3.3.5**, which inspire me to develop the streem.rb. In the footnote of that page, we know "this idea first appeared in the incredibly forw-ard-looking SKETCHPAD system by Ivan Sutherland". But in that system constraints are equations, which means the computation can be act in two different direction. And that system is **nonpreemptive** and **signal senstive**, in other words, once some signal changes, all the equations have to re-computing to be banlanced through the 'constraint chains', that why it be called 'propagation'. Thus, we will stucked in a chain too long.

[Abl83] also encourages programmer implemnting features as a DSL in a host language, so that you can get the power of the host language as a extsion naturally. I think the syntax is not the most important matter now, so I ignore the syntax matter just implement the streem.rb in Ruby using some fantastic Ruby tricks.

[Dan02] indicates that a Linux/UNIX pipe is a/two file descriptor(s) shared between two process(one for write, one for read) in chapter. 17.

Matz himself show a lot of interests in UNIX pipe, event-drive pattern(eventmachine), asynchronous IO, non-block IO and stream in [Matz12], and also inspire me a lot.

### Original Version

+ [Abl83] Abelson H, Sussman G J. Structure and interpretation of computer programs[J]. 1983.
+ [Dan02] Daniel P.Bovet, Marco Cesati. Understanding the Linux Kernel, O'Reilly Media. 2002.  
+ [Matz12] まつもと ゆきひろ. まつもとゆきひろ コードの未来. 2012. 

## Corresponding Chinese Version

+ [Abl83.Zh_cn] [美] Abelson H, Sussman G J. 著, 裘宗燕 译, 计算机程序的构造和解释. 2004.
+ [Dan02.Zh_cn] [美] 博韦, 西斯特 著, 陈莉君, 张琼声, 张宏伟 译，深入理解LINUX内核, 中国电力出版社, 2007.
+ [Matz12.ZH_cn] [日] 松本行弘 著, 周自恒 译, 代码的未来, 2013.