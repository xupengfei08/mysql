# suanmilk/mysql-cron-backup:5.7.0
> 在镜像：mysql:5.7的基础上使用mysqldump备份数据
## 环境变量
| ENV | 描述 | 值 | 默认 | 使用 |
| :---: | :--- | :---: | :---: | :--- |
CRON_BACKUP_ENABLE | 是否开启定时备份数据 | true或者false | true | -e CRON_BACKUP_ENABLE=true
CRON_BACKUP_TIME | 定时备份执行时间 | 合法cron表达式 | 0 2 * * *（每日凌晨2点整执行） | -e CRON_BACKUP_TIME=0 3 * * *
MYSQL_BACKUP_DAYS | 备份数据保存天数 | 1-30 | 7 | -e MYSQL_BACKUP_DAYS=30


## 备份数据存储位置
> mysql备份数据压缩文件在`容器内`的存储路径：/var/lib/mysql/backup

## 备份数据文件命名
> 按照日期：data_$(date +%Y%m%d).sql.gz生成备份文件并压缩，同时复制为最新版本：data_latest.sql.gz

---

## 注意事项
#### 1. 针对现有数据库的用法
##### a. 导出数据库
```
$ docker exec some-mysql sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > /some/path/on/your/host/all-databases.sql
```
##### b. 删除数据库对应宿主机的目录
##### c. 启动参数配置
将/docker-entrypoint-initdb.d/data_latest.sql挂载到/some/path/on/your/host/all-databases.sql。启动容器时数据库初始化。此外还会初始化执行/docker-entrypoint-initdb.d目录下.sh文件以及加载.sql和.sql.gz文件

#### 2. 修改备份相关参数（环境变量）
* 进入容器直接修改并使之生效
