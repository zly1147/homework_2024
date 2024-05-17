## ---------------------------
## Script name: 
## Purpose of script: A regression model of mpg as target and others as features using random forest algorithm with caret package
## Author: 张凌宇
## Date Created: 2024-04-01
## Copyright (c) Timothy Farewell, 2024
## Email: zly1147@mail.ustc.edu.cn
## ---------------------------
## Notes:
## 
## ---------------------------

# 安装需要的包
install.packages("caret")
install.packages("skimr")
install.packages("randomForest")

# 加载需要的包
library(caret)
library(skimr)
library(randomForest)

##----------数据准备和预处理----------
# 加载mtcars数据集
data(mtcars)

# 将mtcars数据集赋值给df
df <- mtcars

# 使用createDataPartition()函数划分训练集和测试集
set.seed(123)
trainIndex <- createDataPartition(df$mpg, p = .8, list = FALSE, times = 1)

train_set <- df[trainIndex, ]
test_set  <- df[-trainIndex, ]

# 使用skim在训练集上查找缺失值
train_set_skim <- skim(train_set)
print(train_set_skim)

# 使用skim在测试集上查找缺失值
test_set_skim <- skim(test_set)
print(test_set_skim)

##----------模型训练（特征选择和可视化）----------
# 使用randomForest()函数进行特征选择
set.seed(123)
rf_model <- randomForest(mpg ~., data = train_set, importance = TRUE)

# 打印特征重要性
importance_df <- importance(rf_model)
print(importance_df)

# 可视化特征重要性
varImpPlot(rf_model)

# 使用训练控制进行交叉验证
trControl <- trainControl(method = "cv", number = 10)

# 使用train()函数进行特征选择和训练模型
set.seed(123)
model <- train(mpg ~., data = train_set, method = "rf", trControl = trControl, importance = TRUE)

# 特征重要性
importance_final <- varImp(model, scale = FALSE)
print(importance_final)

# 可视化最终的特征重要性
plot(importance_final)

##----------测试/翻转模型（模型评估）----------
# 使用训练好的模型进行预测
predictions <- predict(rf_model, newdata = test_set)

# 使用RMSE和R-Squared评估模型性能
RMSE <- sqrt(mean((predictions - test_set$mpg)^2))
RSquared <- cor(predictions, test_set$mpg)^2

print(paste("RMSE:", RMSE))
print(paste("R-Squared:", RSquared))

# 绘制实际值和预测值
plot(test_set$mpg, predictions, main = "Actual vs Predicted", xlab = "Actual", ylab = "Predicted", col = "blue")
abline(0, 1, col = "red")
