## webpack如何设置多入口打包及webpack热更新的原理

## vue项目如何监测错误

## es6有哪些新特性

## 对象继承的多种方法（es5的继承方法）

## css动画的俩种方式
## transform用法

## undefied和'undefied'的区别、undefied 和 null 的区别
## css哪些属性会继承

## 异步操作的解决方案promise、Generator、async

## slice slipt join

## git rebase 和 git merge的作用和区别

## 微服务及微服务解决方案

## js是否能写出AR效果

## docker 如何提交镜像？build时的参数有哪些？run时的参数有哪些？备份镜像？先停掉docker再run服务是否会有问题？
# 前端优化有哪些方法
灵感来源：[提高 10 倍性能：优化静态网站](https://juejin.im/post/5ac9e430f265da2392369ec0)
####  webpack合并打包项目
~~~
可减少http请求
~~~
#### 使用webpack预压缩，代理服务开启gzip压缩。
~~~
为什么要这样做？（个人理解欢迎指错）
代理服务（是指nginx、node、apache等）gzip为开启时它会事先查找客户端请求所有文件的预压缩版本，
如果和webpack的ZopfliPlugin预压缩所有文件结合在一起。这节省了计算资源，并允许我们在不牺牲速度的情况下最大限度地实现压缩。
~~~
#### 启用HTTP2，并配置符合自己项目的缓存机制
#### 延迟加载

~~~
下文是作者写的列子大致逻辑是：
文档完成加载，它将修改 <img> 标签，使他们从 <img data-src=”…”> 转到 <img src=”…”> 然后将其加载到后台

$(document).ready(function() {
    $("#about").click(function() {
        $('#about > .lazyload').each(function() {
            // set the img src from data-src
            $(this).attr('src', $(this).attr('data-src'));
        });
    });

    $("#articles").click(function() {
        $('#articles > .lazyload').each(function() {
            // set the img src from data-src
            $(this).attr('src', $(this).attr('data-src'));
        });
    });
});
作者：Starrier
链接：https://juejin.im/post/5ac9e430f265da2392369ec0
来源：掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
~~~
通过这个例子我想到是 预加载
比如项目首页加载完成或者渲染完成时，修改（src）或者添加script、link标签引入即将需要用到的文件,就可以完成预加载。

* 还有很多优化的建议请自行查找，我只记录以上这些我认为能显著提高网站速度的点，像书写规范，css、js如何书写不会影响html解析速度这些优化，请多查阅资料

## 事件循环

同步和异步任务分别进入不同的执行环境，同步的进入主线程，即主执行栈，异步的进入任务队列（先进先出）。主线程内的任务执行完毕为空，会去任务队列读取对应的任务，推入主线程执行。 上述过程的不断重复就是我们说的 Event Loop (事件循环)。

## JS代理 proxy

## vue渲染过程

## promise原理

## promise同步如何处理

## Promise加轮训 直到成功才resolve如何处理

## exceljs

## es6 有哪些属性

## 数组去重

## vue-router俩种模式的区别

## Vue3.0 和 vue2.0的区别

## 获取全部标签如何获取

写一断js代码，循环dom.node

## flex缩写代表啥意思

flex-grow: 当父控件还有剩余空间的时候，是否进行放大(grow)其中数值代表的是放大比例，值为0的时候表示不放大；默认不放大

flex-shrink：当父控件空间不够的时候，是否进行缩小(shrink)其中数值代表的是与控件大小有关的缩小比例；默认缩小

flex-basis：在分配剩余空间前，自己占位多少

## canvas原理是什么

`canvas`本身并不具备绘画能力，它本身只是一个画布，是一个容器。绘图能力是基于`html5`的`getContext("2d")`返回的`CanvasRenderingContext2D`对象来完成的。

## node多进程管理

* pm2进程管理、性能监控
*  [Keymetrics monitoring](https://link.jianshu.com/?t=http://pm2.keymetrics.io/docs/usage/monitoring/#keymetrics-monitoring)可视化性能监控

## flex主轴是什么有哪些属性？

* 主轴就是此元素的宽、高

## 判断数组

* Object.protoType.call(array)

* Array.isArray(array)

## bind、call、apply

* bind返回一个改变了this指向的函数，可以多次调用。

* apply参数有俩个，第二个参数是数组（参数集合）。

* call参数有俩个，第二个参数是参数列表。

## css 垂直居中

* transiform位移

* 绝对定位
* flex布局
* display：table
* line-height
* float

