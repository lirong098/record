## 用docker搭建php开发环境
### 1. 最简单的方式搭建
#### 下载所需镜像
~~~bash
docker pull nginx
docker pull php:fpm
docker pull mysql
~~~
#### 根据镜像获取 nginx php mysql 配置文件，方便定制适合自己的环境
~~~bash
docker run --name php-fpm -p 9000:9000 -d php:fpm
docker cp php-fpm:/usr/local/etc/php-fpm.d/www.conf www.conf
docker cp php-fpm:/usr/src/php/php.ini-production php.ini
docker run --name nginx -p 80:80 -d nginx
docker cp nginx:/etc/nginx/conf.d/default.conf default.conf
# 复制完文件后再删除容器后面会根据这些配置文件重新启动容器
docker stop [容器名]
docker rm [容器名]
# 将容器的文件复制到物理机
# docker cp [容器名:][文件路径] [粘贴到本地路径及文件名]
# 将物理机的文件复制到容器内
# docker cp [本地文件路径] [容器名:][文件路径]
~~~


这里要特别注意一下,php-fpm:/usr/src/php/php.ini-production,在实例出的容器中,不一定是路径src/php,拉取的php:fpm版本镜像不同,php.ini路径不同。

可以这样查看php.ini路径
~~~bash
# 先进入容器
docker exec -it php-fpm bash
cd /usr/src/ && ls

# 有以下两个文件
php.tar.xz   php.tar.xz.asc

# 这里我们需要解压php.tar.xz文件,因为php.ini-production就在其中
//先解压xz
 xz -d php.tar.xz  
//再解压tar
 tar -xvf  php.tar
~~~
解压完毕后, php.ini-production便出现了，我当时的路径是/usr/src/php-7.1.9/php.ini-production。
#### 修改php.ini文件（复制出来的文件）
~~~bash
# 查找fix_pathinfo
;cgi.fix_pathinfo=1
# 将;去掉
cgi.fix_pathinfo=1
# 当url解析错误时修改为（参考http://blog.51cto.com/xiumu/1722974）
# cgi.fix_pathinfo=0
~~~
#### 修改default.conf文件（复制出来的文件）
~~~bash
server {
    listen       80;
    server_name  _;
    root /usr/share/nginx/html;
    index index.php index.html index.htm;

    #charset koi8-r;
    #access_log  /var/log/nginx/log/host.access.log  main;

    location / {
        #root   /usr/share/nginx/html;
        #index  index.php index.html index.htm;
	try_files $uri $uri/ =404;
    }

    error_page  404  /404.html;
    location = /40x.html {
        root    /user/share/nginx/html;
    }

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    location ~ \.php$ {
        # /var/www/html/ 是指php-fpm 容器中的项目代码
        root           /var/www/html/;
        fastcgi_pass   php-fpm:9000;
        fastcgi_index  index.php;
#        fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        include        fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;

    }

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    location ~ /\.ht {
        deny  all;
    }
}
~~~
#### 启动服务容器 nginx php mysql
~~~
# 根据本地配置的文件启动相应的服务
cd www # (www 为你自己的项目文件，这个文件下有上面复制出来的文件 如：php.ini、default.conf、项目代码(html)、数据库文件等)
docker run -p 3306:3306 --name mysql -v $PWD/mysql/:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 -d --privileged=true mysql
docker run --name php-fpm -p 9000:9000 --link mysql:mysql -v $PWD/html:/var/www/html -v $PWD/www.conf:/usr/local/etc/php-fpm.d/www.conf -v $PWD/php.ini:/usr/local/etc/php/php.ini -d php:fpm
docker run --name nginx -p 80:80 --link php-fpm -v $PWD/default.conf:/etc/nginx/conf.d/default.conf -d nginx
~~~
#### 测试
在本地服务器的 www/html/下，添加 test.php
~~~
<?php
phpinfo();
~~~
在浏览器中输入http://localhost/test.php,能出来结果就说明配置成功

上面的步骤是最简单的入门及理解docker的最好的方法，适合配置自己的开发环境
## 参考[再谈docker搭建nginx+php+mysql开发环境](http://www.sail.name/2017/09/26/retalk-use-docker-to-build-development-environment-of-php-mysql-nginx/)
## [docker中文文档](https://docker_practice.gitee.io/)

# thinkPhp 部署
### 修改default.conf (nginx配置文件)
~~~bash
server {
    listen       80;
    server_name  _;
    root /usr/share/nginx/html;
    index index.php index.html index.htm;

    #charset koi8-r;
    #access_log  /var/log/nginx/log/host.access.log  main;

    location / {
        #root   /usr/share/nginx/html;
        #index  index.php index.html index.htm;
	    try_files $uri $uri/ =404;
        #访问路径的文件不存在则重写URL转交给ThinkPHP处理  
        if (!-e $request_filename) {  
           rewrite  ^/(.*)$  /index.php/$1  last;  
           break;  
        } 
    }

    error_page  404  /404.html;
    location = /40x.html {
        root    /user/share/nginx/html;
    }

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
   # location ~ \.php$ {
        #root           /var/www/html/public/index.php;
        #fastcgi_pass   php-fpm:9000;
       # fastcgi_index  index.php;
#        fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
      #  include        fastcgi_params;
     #   fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;

    #}
    location ~ \.php/?.*$ {
        root        /var/www/html/public/;
        fastcgi_pass   php-fpm:9000;  
        fastcgi_index  index.php;  
        #加载Nginx默认"服务器环境变量"配置  
        include        fastcgi_params;  
          
        #设置PATH_INFO并改写SCRIPT_FILENAME,SCRIPT_NAME服务器环境变量  
        set $fastcgi_script_name2 $fastcgi_script_name;  
        if ($fastcgi_script_name ~ "^(.+\.php)(/.+)$") {  
            set $fastcgi_script_name2 $1;  
            set $path_info $2;  
        }  
        fastcgi_param   PATH_INFO $path_info;  
        fastcgi_param   SCRIPT_FILENAME   $document_root$fastcgi_script_name2;  
        fastcgi_param   SCRIPT_NAME   $fastcgi_script_name2;  
    } 

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    location ~ /\.ht {
        deny  all;
    }
}

~~~
### 进入php-fpm容器
执行下面命令
~~~bash
apt-get update
apt-get install mlocate
updatedb
docker-php-ext-install pdo_mysql
# 如果pdo_mysql安装失败，修改php.ini文件。找到以下插件并启用
extension=php_mysqli.dll
extension=php_pdo.dll
extension=php_pdo_mysql.dll
extension=pdo.so
extension=pdo_mysql.so
~~~
### 修改php.ini
在你的php.ini文件将以下的几项配置为UNIX socket的值,没有自行添加
~~~bash
pdo_mysql.default_socket
mysql.default_socket
mysqli.default_socket

## 示范
mysqli.default_socket = /var/run/mysqld/mysqld.sock
~~~
#### 如何获取UNIX socket
~~~bash
docker exec -it mysql bash
mysql -u root -p 123456
STATUS;
~~~
就会看到UNIX socket，复制
### 修改tp项目的数据库配置文件的
DB_HOST 或者 hostname
~~~bash
# 我的列子 tp5
"hostname" => mysql
注意 mysql是我的mysql容器名称
~~~
# mysql:8.0 的登录验证变了 请百度查看 我用的mysql:5.7,随后我会解决mysql:8.0和tp登录问题
