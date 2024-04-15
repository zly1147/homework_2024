## ---------------------------
## Script name: data_exploration.R
##
## Purpose of script:
## 1、删除Doubs数据集中缺失数据的site，并检测环境因子是否共线性
## 2、分析鱼类和环境因子之间的关系，并可视化这种关系
## 
## Author: 张凌宇
## Date Created: 2024-04-15
## Email: zly1147@mail.ustc.edu.cn
## ---------------------------

#----------安装并加载所需的库----------
install.packages('ade4')
install.packages('vegan')
install.packages('GGally')
install.packages('car')
library(ade4)
library(vegan)
library(GGally)
library(car)

#----------加载Doubs数据集----------
data(doubs)
fish <- doubs$fish#将数据框doubs中的fish列赋值给变量fish
env <- doubs$env#将数据框doubs中的env列赋值给变量fish

#----------删除缺失数据----------
  #使用cbind()函数将fish和env按列合并成一个数据框
  #并用na.omit()函数删除数据框中的缺失值（NA）
  #将处理后的数据框赋值给变量complete_data
complete_data <- na.omit(cbind(fish, env))
  #利用GGally包中的ggpairs函数创建散点图矩阵，初步可视化数据关系
ggpairs(complete_data)

#----------计算环境因子的方差膨胀因子VIF，以检测共线性----------
  #使用vegan的rda函数进行主成分分析，防止多重共线性
    #保存pH列，然后从数据集中移除
pH_values <- complete_data$pH
data_without_ph <- complete_data[, !(names(complete_data) %in% "pH")]
    #使用rda函数在没有pH的数据上进行主成分分析
pca_model <- rda(data_without_ph)
    #获取主成分变量（个数取决于保留的主成分数量）
pca_variables <- scores(pca_model)$sites
    #将pca_variables转变为一个dataframe对象
pca_variables_df <- as.data.frame(pca_variables)
    #把pH列再添加到pca_variables_df
pca_variables_df$pH <- pH_values
  #在新的主成分变量上做线性回归
    #使用lm()函数构建一个线性回归模型，其中因变量为pH，自变量为pca_variables_df数据框中的所有列
    #并用vif()函数计算线性回归模型中各个变量的方差膨胀因子
    #再赋值给变量vif_values
vif_values <- vif(lm(pH ~ ., data = pca_variables_df))
  #转换为数据框架，便于绘图
vif_df <- data.frame(Variables = names(vif_values), VIF = vif_values)
  #使用plot函数可视化
barplot(vif_df$VIF, names.arg = vif_df$Variables, main = "VIF values for PCA Components", xlab = "PCA Components", ylab = "VIF Values", col = "lightblue")
  #显示VIF值
print(vif_values)

# 分析并可视化鱼类和环境因子之间的关系
cor_mtrx <- cor(complete_data)
ggcorr(cor_mtrx, label = TRUE)