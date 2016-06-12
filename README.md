# streem.rb / RbStreem

Try to implement [matz/streem](https://github.com/matz/streem) as a DSL within Ruby with a little syntax sacrifice.

All of this work are based on [commit 8dba5e8](https://github.com/matz/streem/commit/8dba5e83e4a4e319e1ae4754a1aef455e12b411c).

## Usage

```
$ streem file/to/run.strm.rb
```

## Reference

I will list the original papers and books, but I will also list the corresponding Chinese version.

[Abel83] introduced a interesting system **propagation of constraints(约束传播)** in section 3.3.5, which inspire me to develop the streem.rb. In the footnote of that page, we know that"this idea first appeared in the incredibly forward-looking SKETCHPAD system by Ivan Sutherland". Since constraints are equations in that system, which means the computation can be performed in two different direction, but streem.rb has a distinguish direction: from a source to a destination. And that system is **nonpreemptive** and **signal sensitive**, in other words, once some signal changes, all the equations have to re-computing to be balanced through the 'constraint chains', that why it be called 'propagation'. Thus, we will be stuck in a chain too long.

[Hoare85].

[Abel83] also encourages programmers implementing features as a DSL in a host language, so that you can get the power of the host language as an extension naturally. I think the syntax is not the most important matter now, so I ignore the syntax matter and just implement the streem.rb in Ruby using some fantastic Ruby tricks.

[Dan02] shows that a Linux/UNIX pipe is a/two file descriptor(s) shared between two processes(one for write, one for read) in chapter #17.

Matz himself developed a consuming passion in UNIX pipe, event-drive pattern(eventmachine), asynchronous IO, non-block IO and stream in [Matz12] by analyzing serveral programming languages and useful libraries. [Matz12] gives me a general idea of what the streem.rb should act like.

### Original Version

+ [Abel83] Abelson H, Sussman G J. Structure and interpretation of computer programs[J]. 1983.
+ [Dan02] Daniel P.Bovet, Marco Cesati. Understanding the Linux Kernel, O'Reilly Media. 2002.
+ [Hoare85] C.A.R Hoare, Communicating sequential processes[M].London:Prentice/Hall International, 1985
+ [Matz12] まつもと ゆきひろ. まつもとゆきひろ コードの未来. 2012. 

### Corresponding Chinese Version

+ [Abel83.Zh_cn] [美] Abelson H, Sussman G J. 著, 裘宗燕 译, 计算机程序的构造和解释. 2004.
+ [Dan02.Zh_cn] [美] 博韦, 西斯特 著, 陈莉君, 张琼声, 张宏伟 译，深入理解LINUX内核, 中国电力出版社, 2007.
+ [Hoare85.Zh_cn] [英] C.A.R Hoare 著, 周巢尘 译, 通信顺序进程, 北京大学出版社, 1988
+ [Matz12.ZH_cn] [日] 松本行弘 著, 周自恒 译, 代码的未来, 2013.