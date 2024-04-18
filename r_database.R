## ---------------------------
## Script name: r_database.R
## Purpose of script:熟悉reticulate和rdataretriever包，以及PostgreSQL和SQLite，将ade4包的内置数据集Doubs的数据上传到PostgreSQL或SQLite的模式中
## Author: 张凌宇
## Date Created: 2024-04-18
## Email: zly1147@mail.ustc.edu.cn
## ---------------------------
## Notes:
## 
## ---------------------------

#----------安装所需的包----------
install.packages("DBI")
install.packages("RPostgreSQL") # 用于连接到PostgreSQL数据库

#----------上传数据到PostreSQL----------
# 加载所需的包
library(DBI)
library(RPostgreSQL)
library(ade4)

# 加载Doubs数据
data(doubs)
fish <- doubs$fish
env <- doubs$env
complete_data <- na.omit(cbind(fish, env))

# 创建到PostgreSQL数据库的连接
# 请用你自己的数据库名称、用户名和密码替换下面的值
  #可通过SQL查询SHOW DATABASES; 来查看所有的数据库名称
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "postgres",
                 host = "localhost", port = 5432,
                 user = "postgres", password = "postgresqlzly")



#也可以尝试RPostgres包，它是RPostgreSQL的现代化版本
install.packages("RPostgres")
library(RPostgres)
con <- dbConnect(RPostgres::Postgres(), dbname = "postgres",
                 host = "localhost", port = 5432,
                 user = "postgres", password = "postgresqlzly")

# 将数据上传到数据库
dbWriteTable(con, "Doubs", complete_data, row.names = FALSE)

# 断开与数据库的连接
dbDisconnect(con)

#----------上传数据到SQLite----------
# 加载所需的包
library(DBI)
library(RSQLite)
library(ade4)

# 加载Doubs数据
data(doubs)
fish <- doubs$fish
env <- doubs$env
complete_data <- na.omit(cbind(fish, env))

# 创建到SQLite数据库的连接
# 需提供数据库的路径
con <- dbConnect(RSQLite::SQLite(), dbname="database_path")

# 将数据上传到数据库
dbWriteTable(con, "Doubs", complete_data, row.names = FALSE)

# 断开与数据库的连接
dbDisconnect(con)