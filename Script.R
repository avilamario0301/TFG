#####################################
'Autor:Mario Avila'
#####################################

setwd("~/TFG")
##### Librerias
library(readxl)
library(stargazer)
library(tidyverse)
library(lmtest)
library(sandwich)
library(car)
library(psych)
library(PerformanceAnalytics)
library(effects)
library(corrplot)
##### Cargar base
BASE <- read_excel("C:/Users/avila/Downloads/Trabajo de grado/BASE.xlsx")
##### Analisis descriptivo
DescPrecio<-data.frame(describe(BASE$Precio))
DescAirbnb<-data.frame(describe(BASE$Airbnb))

##### Exportacion de analisis descriptivo
#write.csv(DescPIB, "descPIB.csv")
#write.csv(DescIDM, "descIDM.csv")

##### Regresion
BASE$lPrecio<- log(BASE$Precio)
lHabitaciones<- log(BASE$Habitaciones)
lParqueos<- log(BASE$Parqueos)
lConstruccion<- log(BASE$Construccion)
BASEAir<-subset(BASE, BASE$Airbnb>0)
lAirbnb<- log(BASEAir$Airbnb)
Modelo1<-lm(I(log(Precio))~Airbnb+Amueblado+Construccion+I(Construccion^2), data = BASE)
Modeloln<-lm(I(log(Precio))~lAirbnb+Amueblado+Construccion+I(Construccion^2), data = BASEAir)
Modelo2<-lm(I(log(Precio))~Airbnb+Amueblado+Construccion+I(Construccion^2)+Habitaciones+I(Habitaciones^2)+Parqueos+I(Parqueos^2)+Penthouse, data = BASE)
stargazer(Modelo1,Modeloln,Modelo2, type = "text")
stargazer(Modelo1, type = "html", out = "Modelo1.html", dep.var.labels = "Ln(PreciodeAlquiler)", digits = 4, covariate.labels = c("Airbnb", "Amueblado", "Construcción", "Construcción2", "Constante"))
##### Correlacion de variables y residuales
Db.parcial <- BASE[c("Airbnb", "Amueblado", "Construccion")]
cor(Db.parcial, use="pairwise.complete.obs")
chart.Correlation(Db.parcial, histogram = TRUE)
vif(Modelo1)
dwtest(Modelo1)
##### Heterocedasticidad y Errores robustos
bptest(Modelo1)
residualPlots(Modelo1, fitted=TRUE, pch=20., col.quad="firebrick")
Modelo1Rob<-coeftest(Modelo1,vcov. = vcovHC(Modelo1,type="HC1"))
stargazer(Modelo1, Modelo1Rob, type = "html", out = "Star2.html", dep.var.labels = "Ln(PreciodeAlquiler)", digits = 4, covariate.labels = c("Airbnb","ln(Habitaciones)", "Amueblado", "Construcción", "Penthouse", "Parqueos", "Constante"))

##### Graficos varios, Confirmar distribucion normal de los residuales, Graficos de analisis descriptivo etc.
qqPlot(Modelo1$residuals, pch = 20, col.lines = "firebrick", xlab = "Cuantiles Normales", ylab="Residuales")
shapiro.test(Modelo1$residuals)

plot(BASE$Airbnb, log(BASE$Precio), main = "Relación entre cantidad de AirBnbs y el precio de alquiler", xlab = "Airbnbs", ylab = "Ln(PreciodeAlquiler)", pch=20,
     abline(lm(I(log(BASE$Precio))~BASE$Airbnb), col="firebrick", lwd=2))

hist(BASE$PxM, main = "Precio por M2", xlab = "Precio M2", ylab = "Frecuencia", col = "firebrick")
hist(BASE$lPrecio, main = "Precio", xlab = "Precio", ylab = "Frecuencia", col = "firebrick")

mean(Modelo1$residuals)
hist(Modelo1$residuals, main = "Normalidad de Residuales", xlab = "Residuales", ylab = "Frecuencia", col = "firebrick")

efectos=allEffects(Modelo1)
plot(efectos)

corrplot(cor(Db.parcial, use="pairwise.complete.obs"), method = "circle")
