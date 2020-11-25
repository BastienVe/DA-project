AirBnb Data analytics
========================================================
author: Bastien Vendrame, Raphael Partouche, Ramzi Agougile
date: 26/11/2020
autosize: true




Introduction
========================================================

**Information about the project :**
 
- Language : R

- Shiny application


- Ui/Server application


- Airbnb data from : http://insideairbnb.com/ 


Airbnb Data
========================================================
**Where ?**
- Different places : France (Bordeaux), USA(Cambridge, Austin), Spain (Mallorca, Sevilla, Malaga)

**When ?**

- The last 3 dates from the website

**What ?**
- Information : availabitlity, revenue, price, location, neighbourhood, URL
- Features : room type (hotel, appartment), number of bedrooms, neighbouhood etc.

So first, lets have a look and the app's structure : 



Structure
========================================================

![Structure](www/comparator.png)  ![Structure](www/map.png)


Features selection
========================================================
![Structure](www/selectCity.png)  ![Structure](www/selectFeatures.png)

Availability
========================================================


+ ggplot() 
+ geom_bar() 
+ geom_text() 
+ scale_fill_brewer(palette="Blues")

```r
plot(p)
```

![plot of chunk unnamed-chunk-3](rmd_presentation-figure/unnamed-chunk-3-1.png)

Availability with features :
========================================================


+ ggplot(fill=bedrooms) 
+ geom_bar() 
+ geom_text() 
+ scale_fill_brewer(palette="Blues")

```r
plot(p2)
```

<img src="rmd_presentation-figure/unnamed-chunk-5-1.png" title="plot of chunk unnamed-chunk-5" alt="plot of chunk unnamed-chunk-5" width="500px" />

Other graphics :
========================================================

**Boxplot :**


+ ggplot()
+ geom_boxplot() 
+ scale_y_continuous() 
+ scale_fill_brewer(palette="Blues")

```r
plot(p3)
```

<img src="rmd_presentation-figure/unnamed-chunk-7-1.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="500px" />

Other graphics :
========================================================

**Lets call it** ***Cheese graphic*** :


+ ggplot() 
+ geom_bar()
+ geom_text()
+ coord_polar("y", start=0) 
+ scale_fill_brewer(palette="Blues")

```r
plot(pie)
```

<img src="rmd_presentation-figure/unnamed-chunk-9-1.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="500px" />

Leaflet Map :
========================================================
![Structure](www/leaflet.png)

