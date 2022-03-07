# 1. JS基础
### 1.1 操作Array的方法有哪些
* **Symbol.iterator**
>返回数组的 iterator 方法，默认情况与values()返回值一样
~~~js
var arr = ['a', 'b', 'c', 'd', 'e'];
var eArr = arr[Symbol.iterator]();
console.log(eArr.next().value); // a
console.log(eArr.next().value); // b
console.log(eArr.next().value); // c
console.log(eArr.next().value); // d
console.log(eArr.next().value); // e
~~~
[深入理解iterrator](https://juejin.cn/post/6844903591539376136)
* **Symbol.species**
>返回Array 的构造函数，如果是自定义的array构造函数实例的array，Symbol.species返回此自定义的构造函数。
~~~js
let arr = [1, 2]
arr[Symbol.species] // function Array()

class MyArray extends Array {
  // 重写 MyArray 的 species 属性到父类 Array 的构造函数
  static get [Symbol.species]() { return Array; }
}
~~~
* **concat**
>方法用于合并两个或多个数组。此方法不会更改现有数组，而是返回一个新数组。
* **copyWithin**
>方法浅复制数组的一部分到同一数组中的另一个位置，并返回它，不会改变原数组的长度。
```js
const array1 = ['a', 'b', 'c', 'd', 'e'];

// 把索引3到4的数据，copy到索引0的位置并替换原来的数据 "d" 替换 "a"
console.log(array1.copyWithin(0, 3, 4));
// expected output: Array ["d", "b", "c", "d", "e"]

// 把索引3到结束为止的数据，copy到索引1的位置并替换原来的数据 "d", "e" 替换 "d"
console.log(array1.copyWithin(1, 3));
// expected output: Array ["d", "d", "e", "d", "e"]
```
* **entries**
>entries() 方法返回一个新的Array Iterator对象，该对象包含数组中每个索引的键/值对。
```js
// entries 与 symbol.iterator的value的区别
const array1 = ['a', 'b', 'c'];
const iterator1 = array1.entries();
const eArr = array1[Symbol.iterator]();
console.log(iterator1.next().value);
// expected output: Array [0, "a"]
console.log(eArr.next().value); // a

// entries 二维数组排序
function sortArr(arr) {
    var goNext = true;
    var entries = arr.entries();
    while (goNext) {
        var result = entries.next();
        if (result.done !== true) {
            result.value[1].sort((a, b) => a - b);
            goNext = true;
        } else {
            goNext = false;
        }
    }
    return arr;
}

var arr = [[1,34],[456,2,3,44,234],[4567,1,4,5,6],[34,78,23,1]];
sortArr(arr);

/*(4) [Array(2), Array(5), Array(5), Array(4)]
    0:(2) [1, 34]
    1:(5) [2, 3, 44, 234, 456]
    2:(5) [1, 4, 5, 6, 4567]
    3:(4) [1, 23, 34, 78]
    length:4
    __proto__:Array(0)
*/
```
* **every**
>every() 方法测试一个数组内的所有元素是否都能通过某个指定函数的测试。它返回一个布尔值。
>>* **注意**：若收到一个空数组，此方法在一切情况下都会返回 true
```js
// 下例检测数组中的所有元素是否都大于 10
function isBigEnough(element, index, array) {
  return element >= 10;
}
[12, 5, 8, 130, 44].every(isBigEnough);   // false
[12, 54, 18, 130, 44].every(isBigEnough); // true
```
* **fill**
>fill() 方法用一个固定值填充一个数组中从起始索引到终止索引内的全部元素。不包括终止索引。
>>* **注意1**:fill的返回值是修改后的原数组，即原数组的值也会变。
>>* **注意2**:当对象作为fill的参数是，填充的是对象的引用，即浅拷贝。
```js
[1, 2, 3].fill(4);               // [4, 4, 4]
[1, 2, 3].fill(4, 1);            // [1, 4, 4]
Array(3).fill(4);                // [4, 4, 4]
// fill 方法接受三个参数 value, start 以及 end. start 和 end 参数是可选的, 其默认值分别为 0 和 this 对象的 length 属性值。
[].fill.call({ length: 3 }, 4);  // {0: 4, 1: 4, 2: 4, length: 3}
```
* **findIndex**
>findIndex()方法返回数组中满足提供的测试函数的第一个元素的索引。若没有找到对应元素则返回-1。
>>在第一次调用callback函数时会确定元素的索引范围，因此在findIndex方法开始执行之后添加到数组的新元素将不会被callback函数访问到。如果数组中一个尚未被callback函数访问到的元素的值被callback函数所改变，那么当callback函数访问到它时，它的值是将是根据它在数组中的索引所访问到的当前值。被删除的元素仍然会被访问到。
```js
const array1 = [5, 12, 8, 130, 44];

const isLargeNumber = (element) => element > 13;

console.log(array1.findIndex(isLargeNumber));
// expected output: 3
```
* **flat**
>flat() 方法会按照一个可指定的深度递归遍历数组，并将所有元素与遍历到的子数组中的元素合并为一个新数组返回。
>* **tips** 面试题：如何将多维数组展平为一维数组
```js
// flat
const arr1 = [0, 1, 2, [3, 4]];

console.log(arr1.flat());
// expected output: [0, 1, 2, 3, 4]

const arr2 = [0, 1, 2, [[[3, 4]]]];

console.log(arr2.flat(3));
// expected output: [0, 1, 2, 3, 4]
```
* **flatmap**
>flatmap相当与一个数组调用map()后，在调用flat(1)。***返回值是一个新数组***。
>>下面的例子，a调用map()，返回，[[4, 1], [4],  [], [20], [16, 1],  [], [], [18]],再调flat(1)，如果，深度遍历是空值，则删除改项。
```js
let a = [5, 4, -3, 20, 17, -33, -4, 18]
a.flatMap( (n) =>
  (n < 0) ?      [] :
  (n % 2 == 0) ? [n] :
                 [n-1, 1]
)
// expected output: [4, 1, 4, 20, 16, 1, 18]
```
* **from**
>Array.from() 方法对一个类似数组或可迭代对象创建一个新的，浅拷贝的数组实例。
```js
// 从 String 生成数组
Array.from('foo');
// expected output: [ "f", "o", "o" ]

// 从 Set 生成数组
const set = new Set(['foo', 'bar', 'baz', 'foo']);
Array.from(set);
// expected output:  [ "foo", "bar", "baz" ]

// 从 Map 生成数组
const map = new Map([[1, 2], [2, 4], [4, 8]]);
Array.from(map);
// [[1, 2], [2, 4], [4, 8]]

const mapper = new Map([['1', 'a'], ['2', 'b']]);
Array.from(mapper.values());
// ['a', 'b'];

Array.from(mapper.keys());
// ['1', '2'];

// 从类数组对象（arguments）生成数组
function f() {
  return Array.from(arguments);
}
f(1, 2, 3);
// [ 1, 2, 3 ]

// 序列生成器(指定范围)
const range = (start, stop, step) => Array.from({ length: (stop - start) / step + 1}, (_, i) => start + (i * step));
range(0, 4, 1);
// [0, 1, 2, 3, 4]
range('A'.charCodeAt(0), 'Z'.charCodeAt(0), 1).map(x => String.fromCharCode(x));
// ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
```
* **includes**
>includes() 方法用来判断一个数组是否包含一个指定的值，根据情况，如果包含则返回 true，否则返回 false。
> arr.includes(valueToFind[, fromIndex]) 从fromIndex 索引处开始查找 valueToFind。
>> Tips: 使用 includes()比较字符串和字符时是区分大小写的。
>> Tips: 0 的值将全部视为相等，与符号无关（即 -0 与 0 和 +0 相等），但 false 不被认为与 0 相等。
```js
[1, 2, 3].includes(2);     // true
[1, 2, 3].includes(4);     // false
[1, 2, 3].includes(3, 3);  // false
[1, 2, 3].includes(3, -1); // true
[1, 2, NaN].includes(NaN); // true

// 作为通用方法的 includes()
// includes() 方法有意设计为通用方法。它不要求this值是数组对象，所以它可以被用于其他类型的对象 (比如类数组对象)。下面的例子展示了 在函数的 arguments 对象上调用的 includes() 方法。
(function() {
  console.log([].includes.call(arguments, 'a')); // true
  console.log([].includes.call(arguments, 'd')); // false
})('a','b','c');
```
* **indexOf**
> indexOf()方法返回在数组中可以找到一个给定元素的第一个索引，如果不存在，则返回-1。
* **lastIndexOf**
>lastIndexOf() 方法返回指定元素（也即有效的 JavaScript 值或变量）在数组中的最后一个的索引，如果不存在则返回 -1。从数组的后面向前查找，从 fromIndex 处开始。
```js
// 查找所有元素
var indices = [];
var array = ['a', 'b', 'a', 'c', 'a', 'd'];
var element = 'a';
var idx = array.lastIndexOf(element);
while (idx != -1) {
  indices.push(idx);
  idx = (idx > 0 ? array.lastIndexOf(element, idx - 1) : -1);
}
console.log(indices);
// [4, 2, 0];
// 注意，我们要单独处理idx==0时的情况，因为如果是第一个元素，忽略了fromIndex参数则第一个元素总会被查找。这不同于indexOf方法 
// 注：原英文是针对使用三元操作符语句的作用进行说明的：
// idx = (idx > 0 ? array.lastIndexOf(element, idx - 1) : -1);
// idx > 0时，才进入lastIndexOf由后往前移一位进行倒查找；如果idx == 0则直接设置idx = -1，循环while (idx != -1)就结束了。
```
* **isArray**
> Array.isArray() 用于确定传递的值是否是一个 Array。
* **join**
> join() 方法将一个数组（或一个类数组对象）的所有元素连接成一个字符串并返回这个字符串。如果数组只有一个项目，那么将返回该项目而不使用分隔符。
```js
// join的参数默认值是","

// 通过在Array.prototype.join上调用Function.prototype.call。
function f(a, b, c) {
  var s = Array.prototype.join.call(arguments);
  console.log(s); // '1,a,true'
}
f(1, 'a', true);
```
* **keys**
>keys() 方法返回一个包含数组中每个索引键的Array Iterator对象。
* **map**
>map() 方法创建一个新数组，其结果是该数组中的每个元素是调用一次提供的函数后的返回值。
```js
// 下面的例子演示如何在一个 String  上使用 map 方法获取字符串中每个字符所对应的 ASCII 码组成的数组：
var map = Array.prototype.map
var a = map.call("Hello World", function(x) {
  return x.charCodeAt(0);
})
// a的值为[72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100]
```

* **
slice slipt join

### 1.2 原型链与继承深入理解(包括es6)

### 1.3 冒泡排序理解与实现

### 1.4 网站性能优化有哪些（包括 vue相关优化）
>灵感来源：[提高 10 倍性能：优化静态网站](https://juejin.im/post/5ac9e430f265da2392369ec0)
>* webpack合并打包项目
>~~~
>可减少http请求
>~~~
>* 使用webpack预压缩，代理服务开启gzip压缩。
>~~~
>为什么要这样做？（个人理解欢迎指错）
>代理服务（是指nginx、node、apache等）gzip为开启时它会事先查找客户端请求所有文件的预压缩版本，
>如果和webpack的ZopfliPlugin预压缩所有文件结合在一起。这节省了计算资源，并允许我们在不牺牲速度的情况下最大限度地实现压缩。
>~~~
>* 启用HTTP2，并配置符合自己项目的缓存机制

> 待补充

>* 懒加载、预加载、按需加载（需补充具体的方案）

### 1.5 promise

#### 1.5.1 promise的原理实现

#### 1.5.2 promise的状态与执行过程

#### 1.5.3 new promise(没有 参数) 会怎么样

### 1.6 var变量提升与函数提升（经常考的面试题）

### 1.7 说说对任务队列与事件循环的理解
>同步和异步任务分别进入不同的执行环境，同步的进入主线程，即主执行栈，异步的进入任务队列（先进先出）。主线程内的任务执行完毕为空，会去任务队列读取对应的任务，推入主线程执行。 上述过程的不断重复就是我们说的 Event Loop (事件循环)。

### 1.8 说说对冒泡、捕获的理解

### 1.9 阻止冒泡的方法

### 1.10 如何用原生注册一个自定义事件

### 1.11 如何用原生获取元素的padding值

### 1.12 描述一下闭包

### 1.13 为什么0.1 + 0.2 不等于 0.3

### 1.14 es6有哪些新特性

### 1.15 undefied和'undefied'的区别、undefied 和 null 的区别

### 1.16 描述异步操作的解决方案
>promise、Generator、async

### 1.17 js是否能写出AR效果

### 1.18 JS代理proxy的用法以及与defineproperty的区别

### 1.19 数组去重的方法

### 1.20 bind、call、apply

* bind返回一个改变了this指向的函数，可以多次调用。

* apply参数有俩个，第二个参数是数组（参数集合）。

* call参数有俩个，第二个参数是参数列表。

### 1.21 判断数组的方法
* Object.protoType.call(array)
* Array.isArray(array)


# 2. CSS
### 2.1 px、em、rem、vh、vw分别是什么

### 2.2 css盒模型是什么

### 2.3 实现垂直水平居中的方法
* transiform位移
* 绝对定位
* flex布局
* display：table
* line-height
* float

### 2.4 css动画的俩种方式是什么

### 2.5 transform的属性有哪些

### 2.6 css哪些属性会继承

### 2.7 flex缩写代表啥意思

>flex-grow: 当父控件还有剩余空间的时候，是否进行放大(grow)其中数值代表的是放大比例，值为0的时候表示不放大；默认不放大

>flex-shrink：当父控件空间不够的时候，是否进行缩小(shrink)其中数值代表的是与控件大小有关的缩小比例；默认缩小

>flex-basis：给上面两个属性分配多余空间之前, 计算项目是否有多余空间, 默认值为 auto, 即项目本身的大小

>flex: 1 === flex-grow: 1; flex-shrink: 1; flex-basis: 0%

### 2.8 flex主轴是什么有哪些属性？
* 主轴就是此元素的宽、高

# 3. 网络协议与通信
### 3.1 描述一下HTTP的缓存机制

### 3.2 如果客户端缓存了一个资源，如何让刷新此资源

### 3.3 http返回值的状态以及含义


# 4. 工程化(了解webpack基本)
### 4.1 webpack如何设置多入口打包及webpack热更新的原理

### 4.2 mvvm、mvc是什么

### 4.3 描述微服务（优点）及微服务解决方案

### 4.4 docker 如何提交镜像？build时的参数有哪些？run时的参数有哪些？备份镜像？先停掉docker再run服务是否会有问题？

### 4.5 了解exceljs(生成xlsx文件)

# 5. vue相关
### 5.1 vue-router有哪些跳转方式

### 5.2 vue-router路由的两种模式

### 5.3 vuex的实现原理

### 5.4 vue2 diff的原理

### 5.5 vue3 diff与vue2 diff优化了什么

### 5.6 vue $nextTick的实现原理

### 5.7 vue项目如何监测错误

### 5.8 vue的模版渲染过程

# 6. 微信小程序
### 6.1 描述setData原理以及优缺点

### 6.2 微信小程序有哪些跳转方式

### 6.3 微信小程序如何收集埋点

### 6.4 微信小程序本地缓存多大
10MB

# 7. 微信公众号
### 7.1 微信H5授权流程

# 8. git
### 8.1 常用的git命令有哪些

### 8.2 git fech 与 git pull的区别

### 8.3 git rebase 和 git merge的作用和区别

------
##### 延迟加载的理解
~~~
下文大致逻辑是：
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
~~~
通过这个例子我想到是 预加载
比如项目首页加载完成或者渲染完成时，修改（src）或者添加script、link标签引入即将需要用到的文件,就可以完成预加载。

##### 获取全部标签如何获取

写一断js代码，循环dom.node

##### canvas原理是什么
`canvas`本身并不具备绘画能力，它本身只是一个画布，是一个容器。绘图能力是基于`html5`的`getContext("2d")`返回的`CanvasRenderingContext2D`对象来完成的。
##### node多进程管理
* pm2进程管理、性能监控
*  [Keymetrics monitoring](https://link.jianshu.com/?t=http://pm2.keymetrics.io/docs/usage/monitoring/#keymetrics-monitoring)可视化性能监控

-------
