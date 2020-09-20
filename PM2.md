[pm2中文文档](https://wohugb.gitbooks.io/pm2/content/features/quick-start.html)
~~~bash
# 添加中文注释以便理解

# Fork mode -- 分流模式
$ pm2 start app.js --name my-api # Name process

# Cluster mode -- 群集模式
$ pm2 start app.js -i 0        # Will start maximum processes with LB  depending on available CPUs -- 将根据可用的CPU使用LB启动最大进程
$ pm2 start app.js -i max      # Same as above, but deprecated yet. -- 同上，但已弃用

# 列表

$ pm2 list               # Display all processes status -- 显示所有进程状态
$ pm2 jlist              # Print process list in raw JSON -- 用原始JSON打印进程列表
$ pm2 prettylist         # Print process list in beautified JSON -- 用美化的JSON打印进程列表

$ pm2 describe 0         # Display all informations about a specific process -- 显示有关特定进程的所有信息

$ pm2 monit              # Monitor all processes -- 监视所有进程

# 日志

$ pm2 logs [--raw]       # Display all processes logs in streaming -- 在流中显示所有进程日志
$ pm2 flush              # Empty all log file -- 清空所有日志文件
$ pm2 reloadLogs         # Reload all logs -- 重新加载所有日志

# Actions -- 行动

$ pm2 stop all           # Stop all processes -- 停止所有进程
$ pm2 restart all        # Restart all processes -- 重新启动所有进程

$ pm2 reload all         # Will 0s downtime reload (for NETWORKED apps) -- 将0s宕机重新加载（对于网络应用程序）
$ pm2 gracefulReload all # Send exit message then reload (for networked apps) -- 发送退出消息，然后重新加载（对于网络应用程序）

$ pm2 stop 0             # Stop specific process id -- 停止特定进程
$ pm2 restart 0          # Restart specific process id -- 重新启动特定进程

$ pm2 delete 0           # Will remove process from pm2 list -- 将从pm2列表中删除进程
$ pm2 delete all         # Will remove all processes from pm2 list -- 将从pm2列表中删除所有进程

# 杂项

$ pm2 reset <process>    # Reset meta data (restarted time...) -- 重置元数据（重新启动时间…）
$ pm2 updatePM2          # Update in memory pm2 -- 更新内存pm2
$ pm2 ping               # Ensure pm2 daemon has been launched -- 确保已启动pm2后台程序
$ pm2 sendSignal SIGUSR2 my-app # Send system signal to script -- 将系统信号发送到脚本
$ pm2 start app.js --no-daemon # run pm2 daemon in the foreground if it doesn't exist already -- 如果pm2后台程序不存在，则在前台运行它
$ pm2 start app.js --no-vizion # skip vizion features (versioning control) -- 跳过vizion功能（版本控制）
$ pm2 start app.js --no-autorestart # do not automatically restart apps -- 不用自动重启应用
$ pm2 start app.js -- -a 23  # Pass arguments '-a 23' argument to app.js script -- 将参数‘-a 23’传递给app.js
$ pm2 start app.js --node-args="--debug=7001" # --node-args to pass options to node V8
$ pm2 start app.js --log-date-format "YYYY-MM-DD HH:mm Z"    # Log will be prefixed with custom time format -- 日志将以自定义时间格式作为前缀
$ pm2 start app.js -e err.log -o out.log  # Start and specify error and out log -- 启动并指定错误和输出日志
$ pm2 start app.js --max-memory-restart 20M # 重启临界内存设置
~~~