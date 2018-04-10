## webpack如何设置多入口打包及webpack热更新的原理
## vue项目如何监测错误
## es6有哪些新特性
## 对象继承的多种方法（es5的继承方法）
## vue有哪些常用的API
## vue组件之间传值有哪些方法$on $emit
## vue生命钩子有哪些，每个钩子做哪些处理
## vuex原理及vuex有哪些属性，属性之间的关系，区别、vue-router原理
## 数据双向绑定的原理及具体实现细节（如何做到一个对象的属性改变，通知并改变另一个对象的值）
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