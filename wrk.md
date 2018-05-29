## 目前比较流行的HTTP压测工具 wrk
* 参考：http://zjumty.iteye.com/blog/2221040
* 参考：http://www.restran.net/2016/09/27/wrk-http-benchmark/
* 源码：https://github.com/lirong098/wrk （Fork版）

### mac安装wrk （详细安装步骤请百度）在终端依次输入以下四条命令
```bash
git clone https://github.com/wg/wrk.git
cd wrk
make
sudo cp wrk /usr/local/bin
```
### 测试 在终端输入
```bash
wrk -t4 -c1000 -d30s -T30s --latency http://www.douban.com
```

30秒后返回结果 说明安装成功

返回结果主要关注的几个数据是
~~~
Socket errors socket 错误的数量
Requests/sec 每秒请求数量，也就是并发能力
Latency 延迟情况及其分布
~~~
### wrk 支持使用 lua 来写脚本，wrk 的代码中 scripts 文件夹中就给出了不少例子，例如 post.lua，可以根据需要来修改
可以这样来调用 script [lua脚本例子](https://github.com/lirong098/record/blob/master/teacherList.lua)
```bash
wrk -t4 -c100 -d30s -T30s --script=post.lua --latency http://www.douban.com
```
### 用lua 脚本测试复杂场景(以下文案 完全复制[参考](http://www.restran.net/2016/09/27/wrk-http-benchmark/))
wrk 提供了几个 hook 函数，可以用 lua 来编写一些复杂场景下的测试：

#### setup
这个函数在目标 IP 地址已经解析完，并且所有 thread 已经生成，但是还没有开始时被调用，每个线程执行一次这个函数。可以通过 thread:get(name)， thread:set(name, value) 设置线程级别的变量。

#### init
每次请求发送之前被调用。可以接受 wrk 命令行的额外参数，通过 – 指定。

#### delay
这个函数返回一个数值，在这次请求执行完以后延迟多长时间执行下一个请求，可以对应 thinking time 的场景。

#### request
通过这个函数可以每次请求之前修改本次请求的属性，返回一个字符串，这个函数要慎用， 会影响测试端性能。

#### response
每次请求返回以后被调用，可以根据响应内容做特殊处理，比如遇到特殊响应停止执行测试，或输出到控制台等等。

可以查看 scripts 文件夹下的例子，例如 delay.lua，实现的是每个请求前会有随机的延迟。
~~~
-- example script that demonstrates adding a random
-- 10-50ms delay before each request

function delay()
   return math.random(10, 50)
end
~~~
如果想测试系统的持续抗压能力, 采用 loadrunner 这样的专业测试工具会更好一点。
关于 wrk 更多使用上的技巧，可以参考[这里](http://zjumty.iteye.com/blog/2221040)
