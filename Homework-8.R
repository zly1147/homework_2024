## ---------------------------
## Script name: geodata_,manipul.R
## Purpose of script:
##  1、沿着Doubs河设置2公里的缓冲区，并从地图中截取，以使用qgisprocess包提取每个点的集水区和坡度的光栅值。
##  2、将提取的数据与Doubs数据集中的其他环境因素合并，形成数据框，最后将数据框转换成包含地理坐标系的sf对象。
## Author: 张凌宇
## Date Created: 2024-04-23
## Email: zly1147@mail.ustc.edu.cn
## ---------------------------

# 加载需要的库
library(sf)
library(terra)
library(elevatr)
library(ggplot2)
library(qgisprocess)

# 在R中设置环境变量
Sys.setenv(QGIS_PREFIX_PATH = "C:/Program Files/QGIS 3.36.0/bin/")

# 重配置和初始化QGIS
qgis_configure()

# 读取数据
doubs <- st_read("F:/中国科学技术大学/课程资料/数据驱动的生态学研究/数据驱动的生态学研究方法作业_张凌宇/作业8/doubs_river.shp")
doubs <- st_as_sf(doubs)

# 创建2km缓冲区
doubs_buffered <- st_buffer(doubs, dist = 2000)
plot(st_geometry(doubs_buffered),axes=TRUE)


# 使用qgisprocess沿Doubs River提取集水区和坡度光栅值
doubs_dem <- qgis_runalg(qgis, "grass7:r.watershed", "F:/中国科学技术大学/课程资料/数据驱动的生态学研究/数据驱动的生态学研究方法作业_张凌宇/作业8/doubs_dem.tif", doubs_buffered$cat)
doubs_slope <- qgis_runalg(qgis, "grass7:r.slope.aspect", "F:/中国科学技术大学/课程资料/数据驱动的生态学研究/数据驱动的生态学研究方法作业_张凌宇/作业8/doubs_dem.tif", doubs_buffered$cat)

# 使用 terra包提取DEM和坡度
dem_values <- terra::extract(doubs_dem, doubs)
slope_values <- terra::extract(doubs_slope, doubs)

# 提取的光栅值与Doubs数据集中的其他环境因素合并为数据框
data_frame <- merge(doubs, 
                    data.frame(DEMValue = dem_values, SlopeValue = slope_values), # 一个包含两列的数据框：DEMValue和SlopeValue，其中包含了dem_values和slope_values的数据
                    by = "cat", #对数据框中的cat列进行操作
                    all.y = TRUE)#第二个数据框中如果某些行在doubs中找不到匹配的cat值，仍保留这些行

# 将数据框转换为sf对象
sf_object <- st_as_sf(data_frame, coords = c("经度", "纬度"), #对应于实际数据中的经纬度字段名称
                      crs = 4326)

# 绘图
ggplot() +
  geom_sf(data = sf_object, aes(fill = DEMValue)) + 
  theme_minimal()
