#!/bin/bash
#作为crontab运行的脚本,需特别注意环境变量问题,指令写成绝对路径

echo "执行备份..."
#读取环境变量
. /etc/profile
#将备份文件保存在目录
BACKUP_DIR='/var/lib/mysql/backup'
#如果目录不存在则新建
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir -p "$BACKUP_DIR"
fi

#将所有数据库导出到/data/mysql/backup并按日期命名保存成sql文件并压缩
#参数说明：
# --all-databases  , -A：导出全部数据库。
# --databases,  -B：导出几个数据库。参数后面所有名字参量都被看作数据库名。
# --routines, -R：导出存储过程以及自定义函数。
# --hex-blob：使用十六进制格式导出二进制字符串字段。如果有二进制数据就必须使用该选项。影响到的字段类型有BINARY、VARBINARY、BLOB。
# --single-transaction：该选项在导出数据之前提交一个BEGIN SQL语句，BEGIN 不会阻塞任何应用程序且能保证导出时数据库的一致性状态。它只适用于多版本存储引擎，仅InnoDB。
/usr/bin/mysqldump -uroot -p"$MYSQL_ROOT_PASSWORD" --single-transaction -R -A | gzip > $BACKUP_DIR/data_$(date +%Y%m%d).sql.gz

#复制为最新版本
cp $BACKUP_DIR/data_$(date +%Y%m%d).sql.gz $BACKUP_DIR/data_latest.sql.gz

#查找更改时间在7日以前的sql备份文件并删除
#参数说明：
# -mtime +7：表示7天以外的，即从距当前时间的7天前算起，往更早的时间推移
# -type f：类型为文件
# 备份数据保存天数，默认7天
/usr/bin/find $BACKUP_DIR -mtime +"${MYSQL_BACKUP_DAYS:-7}" -type f -name "data_[1-9]*.sql.gz" -exec rm -rf {} \;
echo "备份完成"
