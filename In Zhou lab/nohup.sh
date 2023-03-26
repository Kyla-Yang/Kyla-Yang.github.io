nohup bash work.sh &> log &
#nohup：确保脚本在你断开 SSH 连接后仍然运行。
#bash work.sh：使用 bash shell 执行 work.sh 脚本。
#&>：将标准输出和标准错误一起重定向到指定的文件。
#log：定义了输出和错误的重定向文件名。你可以根据需要自定义文件名。
#&：将脚本置于后台运行。

[1] 31477
#输入nohup后的显示，31477为进程ID

tail -f log
#实时查看输出文件内容

Ctrl+C
#结束实时查看

kill 31477
#结束进程
