### vue3、vite2微服务（qiankun）调研

假设公司有个项目要技术升级，vue2升到vue3，升级项目要话费很长时间，又想快速使用新项目，有什么办法？小弟有个办法咱们用微服务架构去开发，百度一通......，哦用`qiankun`就可以了，那qiankun好用不，有没有坑？qiankun兼容vue2，vue3不？那......，好的，我去调研一下，给您汇报。

前提，`qiankun`官网上是有vue2使用的项目实践，没有vue3的，主要调研qiankun在vue3的兼容性。

#### 一、主应用为vue3、vite是否支持qiankun？

支持，按照vue2的主应用写法即可。[qiankun主应用](https://qiankun.umijs.org/zh/guide/tutorial#%E4%B8%BB%E5%BA%94%E7%94%A8)

#### 二、主应用是vite、vue3，是否支持子应用为vue3、vite / vue2、webpack？

支持

- vue2&webpack子应用无需处理，直接引用。

- vue3&vite子应用需要安装[vite-plugin-qiankun](https://github.com/tengmaoqing/vite-plugin-qiankun)插件，暴露子应用生命周期（此生命周期指微服务的生命周期）。

```js
// vite.config.js
import qiankun from 'vite-plugin-qiankun';
export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd())
  let config = {
    plugins: [
      vue(),
      qiankun('vue3Vite', {useDevMode: true })
   ],
    ...
  }
  return config
})
```

#### 三、css样式是否隔离？

不隔离。

##### 如何设置css样式隔离？

1. 主应用启动qiankun时，将experimentalStyleIsolation设为true，当 experimentalStyleIsolation 被设置为 true 时，qiankun 会改写子应用所添加的样式为所有样式规则增加一个特殊的选择器规则来限定其影响范围，类似vue的 css scoped。

PS：目前该特性还处于实验阶段，如果碰到一些问题欢迎提 [issue](https://github.com/umijs/qiankun/issues/new?assignees=&labels=&template=bug_report_cn.md&title=[Bug]请遵循下文模板提交问题，否则您的问题会被关闭) 来帮助我们一起改善。(官网说的)

```js
import { start } from 'qiankun';
start({
	sandbox: {
		experimentalStyleIsolation: true
	}
})
```

2. 如果，主、子应用都用了[ant-design](https://ant.design/index-cn)库，将主应用的ant类名设置别名。方法如下：

[详细请参考官方说明](https://ant.design/docs/react/customize-theme)

```js
// 第一步：在vite.config.ts，设置@ant-prefix：qy-ant(自定义类名)
export default () => {
  return {
 	css: {
      preprocessorOptions: {
        less: {
          modifyVars: {
		    '@ant-prefix': 'qy-ant'
		  },
          javascriptEnabled: true,
        },
      },
    }
  }
}
// 第二步：在App.vue中设置ConfigProvider组件的prefixCls="qy-ant"
<template>
  <ConfigProvider :locale="getAntdLocale" prefixCls="qy-ant">
    <AppProvider>
      <RouterView />
    </AppProvider>
	</ConfigProvider>
</template>
```

以上1、2两步能隔离各个应用的自定义或者Ui库的样式，但是，如果主应用有初始化css文件，还是会影响到各个子应用。因为，子应用最终还是挂载在主应用下你置顶的容器中。那么就是第三点建议。请看。

```css
// 初始化css文件
a {
  color: #409EFF;
  text-decoration: none;
}

code {
  background-color: #f9fafc;
  padding: 0 4px;
  border: 1px solid #eaeefb;
  border-radius: 4px;
}

button, input, select, textarea {
  font-family: inherit;
  font-size: inherit;
  line-height: inherit;
  color: inherit;
}
```



3. 主、子应用css初始化文件保持一致，或者主应用不使用css初始化文件；主应用避免全局用标签名来写样式，尽量也使用style scope。

##### 做了一上三步，尽大可能避免样式污染。有考虑不周的请留言指出。

####  四、子应用内是否能跳转其他子应用或主应用？

不可以。可以用技术手段来解决，官方暂未提供方法。

子应用跳转其他应用可以通知主应用，让主应用去跳转。

#### 五、主应用的路由是vue-router4.x，子应用的路由是vue-router3.x以及以下时，在子应用内跳转页面后，再按跳转主应用时，不生效。

产生此问题的[原因](https://github.com/umijs/qiankun/issues/1750)是：

  vue-router3.x以及以下和vue-router4.x的[history.state](https://developer.mozilla.org/zh-CN/docs/Web/API/History/state)格式不一样，需要在vue-router3.x以及以下版本的应用修改state值，保持与vue-router4.x的state值一致，修改方法：

```js
/**
  * 修复主应用router4.x.x与子应用router3.x.x路由切换保存的问题
  * 问题原因：https://github.com/umijs/qiankun/issues/1750
  * current的值：如果to.fullPath的值含base路由,则直接复制，不含base路由，则 base + to.fullPath
  */
 
 // 不含base路由的例子
 let base = '/vue'
 new Router({
   base,
   routes: [
     {
       path: "/about"
       component: ()=>(),
     }
   ]
 })
 
 // 含base路由的例子
 let base = '/'
 new Router({
   base,
   routes: [
     {
       path: "/vue/about"
       component: ()=>(),
    }
  ]
 })
 // 修复state方法，上面的是current值的说明。
 router.afterEach((to) => {
   const state = {
     ...history.state,
     current: to.fullPath // （不含：base + to.fullPath）
   }
   history.replaceState(state, '', window.location.href)
 })
```

#### 六、子应用渲染在keep-alive中，切换子应用可以正常显示，但是控制台一堆报错。

​    报错原因，暂未找到原因，处理方法，子应用显示不使用keep-alive。

#### 七、子应用挂载的容器在每个路由的component中，则，子应用切换子应用时，会闪一下让后空白。提示找不到挂载的容器。

PS: 这个现象也许是我使用的问题，因为，我有一个vue2使用qiankun的项目，子应用的容器就是在路由的component设置的，没有问题。

​    根本原因，暂未找到。

​    处理方法：将挂载子应用的容器放在app.vue中，与路由的生命周期解绑。切换路由，容器一直存在。

```vue
<!-- app.vue -->
<div>
  <div v-show="!route.meta.permission">
    <keep-alive v-if="openCache" :include="getCaches">
      <component :is="Component" :key="route.fullPath" />
    </keep-alive>
    <component v-else :is="Component" :key="route.fullPath" />
  </div>
  <!-- 子应用容器 -->
  <div v-show="route.meta.permission" id="appContainer">
    <component :is="Component" :key="route.fullPath" />
  </div>
</div>
```

#### 八、子应用与主应用的路由模式必须一样，我使用的history模式

主、子应用路由模式不一样的话，主应用跳子应用时，不能正确加载。

我都使用的history模式，hash模式暂未尝试，你可以试一试。



**参考**

[qiankun官方指南](https://qiankun.umijs.org/zh/guide)

[qiankun 练习 demo，父应用 vue3(vite)，子应用用 vue(webpack) 和 vue3(webpack)和vue3(vite)](https://github.com/kakajun/qiankun-vite-test)

