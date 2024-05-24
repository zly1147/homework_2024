## ---------------------------
## Script name: network_analysis.R
## Purpose of script:
## 对control plots进行以下操作：
##  1、构建一个network并将其保存为边列表。
##  2、分析network属性，包括顶点和边。
## Author: 张凌宇
## Date Created: 2024-05-24
## Email: zly1147@mail.ustc.edu.cn
## ---------------------------

# 安装和加载必要的包
install.packages("igraph")
library(igraph)

# 从txt文件中读取数据
data <- read.table("F:\\中国科学技术大学\\课程资料\\数据驱动的生态学研究\\数据驱动的生态学研究方法作业_张凌宇\\作业11\\Control.txt", 
                   header = TRUE, fill = TRUE)#fill=TRUE代表把缺失的值填入NA
head(data)

# 创建网络
g <- graph_from_data_frame(data, directed = FALSE)

# 保存网络为边列表
write_graph(g, file = "F:\\中国科学技术大学\\课程资料\\数据驱动的生态学研究\\数据驱动的生态学研究方法作业_张凌宇\\作业11\\network_edge_list.txt", format = "edgelist")

# 分析网络的属性
cat("Number of vertices:", vcount(g), "\n")
cat("Number of edges:", ecount(g), "\n")

# 获取并打印顶点的度
degree <- degree(g)
print(degree)

# 获取并打印边的属性
edge_attributes <- get.edge.attribute(g)
print(edge_attributes)
