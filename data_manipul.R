## ---------------------------
## Script name: data_manipul.R
## Purpose of script: data processing of data frame
## Author: 张凌宇
## Date Created: 2024-03-25
## Copyright (c) Timothy Farewell, 2024
## Email: zly1147@mail.ustc.edu.cn
## ---------------------------
## Notes:
## ---------------------------

##----------tidyverse包的调用----------
# 首先检查是否已经安装了tidyverse包
find.package("tidyverse")

# 如果未找到，测需要安装tidyverse包
install.packages("tidyverse")

# 加载tidyverse包
library(tidyverse)

##-----------导入和保存数据----------
# 从CSV文件中导入数据
data <- read.csv("target_path/data.csv")

# 将数据保存至新的CSV文件
write.csv(data, "new_data.csv")

##----------检查数据结构----------
str(data)

##----------检查行或列是否缺少数据----------
# 检查整个数据集中的缺失值
is.na(data)

##----------从列中提取值或选择或添加列----------
# 选择某一列（以”column_name“为例）
selected_column <- data$column_name

# 添加新列，并设置初始值（以”new_column“为例）
data$new_column <- 1:nrow(data)

##----------将宽表转换成长表----------
# 使用gather()函数转换，其中column1和column2是待转换的列的名字
data_long <- gather(data, key = "key", value = "value", column1, column2)
# 转换后的数据将会新增"Key"和"Value"两列。"Key"是原数据的列名（column1和column2），"Value"是对应列的值

# 在新版本的tidyverse包中，gather()函数已经被替换成了pivot_longer()函数
data_long <- pivot_longer(data, cols = c(column1, column2), names_to = "key", values_to = "value")

#----------数据可视化----------
# 查找、安装、加载ggplot2包
find.package("ggplot2")
install.packages("ggplot2")
library(ggplot2)

# 绘制散点图（以column1和column2为例）
ggplot(data, aes(x=column1, y=column2)) + geom_point()