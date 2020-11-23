AirBnb Data analytics
========================================================
author: Bastien Vendrame, Raphael Partouche, Ramzi Agougile
date: 26/11/2020
autosize: true




Introduction
========================================================

Information about the project :

- Shiny application
- Airbnb data from : http://insideairbnb.com/ 
- Different places : France (Bordeaux), USA(Cambridge, Austin), Spain (Mallorca, Sevilla, Malaga)
- 3 dates for each city
- Information : availabitlity, revenue, price, location, neighbourhood, URL
- Features : room type (hotel, appartment), number of bedrooms, neighbouhood etc.

So first, lets have a look and the app's structure : 


Structure
========================================================

![Structure](www/comparator.png)  ![Structure](www/map.png)


Features selection
========================================================
![Structure](www/selectCity.png)  ![Structure](www/selectFeatures.png)

Information available
========================================================
- Availability :




```r
plot(p)
```

![plot of chunk unnamed-chunk-3](rmd_presentation-figure/unnamed-chunk-3-1.png)

Information available
========================================================
- Availability with features :




```r
plot(p2)
```

<img src="rmd_presentation-figure/unnamed-chunk-5-1.png" title="plot of chunk unnamed-chunk-5" alt="plot of chunk unnamed-chunk-5" width="500px" />

