## ---------------------------
## Script name: zly_pak_info.R
## Purpose of script:获得有关tidyverse包的信息
## Author: 张凌宇
## Date Created: 2024-03-18
## Copyright (c) Timothy Farewell, 2024
## Email: zly1147@mail.ustc.edu.cn
## ---------------------------
## Notes:
## ---------------------------

#查找R环境中tidyverse包是否存在
find.package("tidyverse")

#如果未找到，下载并安装tidyverse
install.packages("tidyverse")

#加载tidyverse
library(tidyverse)

#获取tidyverse的help文档信息
help(tidyverse)
