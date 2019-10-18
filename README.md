### suanmilk/mysql-cron-backup:5.7.0
> 在镜像：mysql:5.7的基础上使用mysqldump冷备份数据
##### mysql备份数据压缩文件在`容器内`的存储路径
> 备份数据存储路径：/data/mysql/backup，可通过使用 -v ${宿主机指定路径}:/data/mysql/backup来将备份数据挂载到宿主机
##### 通过环境变量配置备份数据相关参数
ENV | 描述 | 值 | 使用
-|-|-|-
CRON_BACKUP_ENABLE | 是否开启定时备份数据，默认开启 | true/false | -e CRON_BACKUP_ENABLE=true
CRON_BACKUP_TIME | 定时备份执行时间，默认每日凌晨2点 | [0-23] | -e CRON_BACKUP_TIME=1
MYSQL_BACKUP_DAYS | 备份数据保存天数，默认7天 | [1-30] | -e MYSQL_BACKUP_DAYS=30

---
