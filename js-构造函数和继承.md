# 构造函数和继承的基本理解

## 构造函数
### js中无论什么函数，只要被创建就自带 prototype（原型）属性
#### 创建构造函数
~~~javaScript
function as () {
	this.a = 'li'
}
~~~
#### 每个函数会自带prototype属性（原型对象）
~~~javaScript
console.log(as.prototype)
打印的结果
{
  constructor: ƒ as() {},// （构造函数）属性指向 as 构造函数本身
  __proto__:Object // as.prototype 是as构造函数的原型对象，既然是对象就一定有来源（就是根据哪个构造函数实例的对象？）打印值可以看出指向Object.prototype
}
~~~
#### 思考
Object.prototype也是属于Object函数的原型对象，那么此原型对象的根据什么构造函数创建的呢？
~~~javaScript
// 打印
console.log(Object.prototype.__proto__) // 就可以看出结果：null
~~~
#### 每个实例对象都一个constructor（构造函数）属性指向此对象是由哪个构造函数创建的

~~~javaScript
// 添加构造函数的原型属性
as.prototype.b = 'rong'
根据as实例对象
let as1 = new as()

console.log( as1.constructor === as) // true // 实例对象as1的construction属性指向 as构造函数
console.log(as1.__proto__ === as.prototype) // true 实例对象有个__propo__的属性指向构造函数原型对象
为什么as1.__proto__ === as 为 false // 因为实例对象的as1.__proto__(指针)指向的是 as 构造函数的原型对象（prototype）
~~~
#### 上面的as1是由构造函数as创建的 所有 as1.construction === as， 那么请看下面的列子
~~~javaScript
// 实例对象使用字面量方式创建
let cs1 = {a:'1'}
cs1.constructor === ? // 打印一下就知道了： Object（字面量方式创建的实例对象是根据Object创建的）
~~~
#### 构造函数和普通函数的区别
~~~javaScript
// 普通函数例子
function as () {
    let o = new Object()
    o.a = 'li'
    return o
}
~~~
* 1：没有显示的创建对象
* 2：直接将属性和方法赋给this对象
* 3：没有return语句
#### 构造函数内部执行的步骤
* 1：创建一个新的对象
* 2：将构造函数的作用域赋给新的对象，因此this指向了新对象
* 3：执行构造函数的代码（给新对象赋新属性和方法）
* 4：返回新对象
#### tips
* 1：一般定义构造函数首字母大写
* 2：把构造函数当做普通函数调用（不使用new关键字）时：this指向Global（window）
### 上的说明，应该能基本的理解构造函数了，如需要详细及深入理解请阅读相关资料

## 继承
#### 原型链继承
~~~javaScript
// o 是实例对象 要被继承的对象
let o = {
    oName: 'li'
}
// 函数方式
function object (o) {
    function F () {}
    F.prototype = o
    return new F()
}
// ES5:原型链继承
Object.create(o,{
	name: {
	    value: 'test'
	}
})
// minO: 继承后的对象
minO = object(o)
console.log(minO.oName) // 'li'
--------------------------------
minO = Object.create(o,{
        name: {
            value: 'test'
        }
})
console.log(minO.oName) // 'li'
console.log(minO.name) // 'test'
~~~
#### 寄生组合式继承
最有效的方式
~~~javaScript
// subType: 子类型构造函数；
// superType: 超类型构造函数;
function inheritPropotype (subType, superType) {
   let prototype = object(superType.prototype) // 根据超类型构造函数的原型对象创建一个副本对象
   prototype.constructor = subType // 每个构造函数的prototype（原型对象）的constructor 都指向构造函数本身，所以，这里要指向子类型构造函数
   subType.prototype = prototype // 指定子类型构造函数的原型对象   来自 超类型构造函数的原型对象
}
// 具体用法
function superType (name) { // 定义超类型构造函数
    this.name = name           // 这里的name、array是普通属性（根据此构造函数创建的实例对象，每个实例对象都有自己的name、array 而不会都共同引用同一个属性，继而每个实例的属性不会相互影响）解决了引用类型浅复制的问题，所以，在定义超类型构造函数时要想清楚哪些属性写在函数体中（实例属性：不共享），哪些属性写在原型对象中（原型属性：所有实例共享）
    this.array = ['sa', 'sd'] 
}
// * 注意 原型对象定义方法时不能使用箭头函数，因为“箭头函数”的this，总是指向定义时所在的对象，而不是运行时所在的对象。
superType.prototype.getName = function () { // 定义超类型构造函数原型对象的方法，每个实例都能使用此方法，并且每个实例使用此方法时都访问的是同一个指针！！！
    return this.name
}
function subType (name, age) { // 定义子类型构造函数
    superType.call(this, name) // 改变超类型构造函数执行的作用域，将超类型构造函数的实例属性写入子类型构造函数中
    this.age = age
}
inheritPropotype(subType, superType) // 将子类型构造函数的原型指向超类型构造函数的原型
subType.prototype.getAge = function () { // 定义子类型构造函数特有的原型属性
    return this.age
}
let sub = new subType('sa', 23)
sub.getName() // 'sa'
sub.getAge() // 23
~~~
##### 注意：这时改变superType.protoType  sub实例也会改变 (不要在代码执行时有修改superType.protoType的属性的代码，除非必要，能把控)

#### 扩展构造函数
方法代理可以轻松地通过一个新构造函数来扩展一个已有的构造函数。这个例子使用了construct和apply。
~~~javaScript
function extend(sup,base) {
    // Object.getOwnPropertyDescriptor: 返回指定对象上一个自有属性对应的属性描述符。
    // {"writable":true,"enumerable":false,"configurable":true}
    var descriptor = Object.getOwnPropertyDescriptor(
        base.prototype,"constructor"
    );
    base.prototype = Object.create(sup.prototype);
    // handler.construct() 方法用于拦截new 操作符. 为了使new操作符在生成的Proxy对象上生效，用于初始化代理的目标对象自身必须具有[[Construct]]内部方法（即 new target 必须是有效的）
    var handler = {
        construct: function(target, args) {
            var obj = Object.create(base.prototype);
            this.apply(target,obj,args);
            return obj;
        },
        apply: function(target, that, args) {
            sup.apply(that,args);
            base.apply(that,args);
        }
    };
    // Proxy 对象用于定义基本操作的自定义行为（如属性查找，赋值，枚举，函数调用等）参考：https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Proxy
    var proxy = new Proxy(base,handler);
    descriptor.value = proxy;
    Object.defineProperty(base.prototype, "constructor", descriptor);
    return proxy;
}

var Person = function(name){
    this.name = name
};

var Boy = extend(Person, function(name, age) {
    this.age = age;
});

Boy.prototype.sex = "M";

var Peter = new Boy("Peter", 13);
console.log(Peter.sex);  // "M"
console.log(Peter.name); // "Peter"
console.log(Peter.age);  // 13
~~~
