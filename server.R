#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(stringr)
library(ggplot2)
library(data.table)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {


    #AVAILABILITY INFORMATION OVER THE LAST 30 DAYS
    average_availability <-reactive({ 
        listings %>% filter(city %in% input$selectCity) %>% group_by(city) %>%
            summarise(average_availability_30=round(mean(availability_30),2))
    })
    
    average_availability_bedrooms <-reactive({ 
        listings %>% filter(city %in% input$selectCity) %>% group_by(city,bedrooms) %>%
            summarise(average_availability_30=round(mean(availability_30),2))
    })
    average_availability_type <-reactive({ 
        listings %>% filter(city %in% input$selectCity) %>% group_by(city,room_type) %>%
            summarise(average_availability_30=round(mean(availability_30),2))
    })
    
    
    distribution_availability <-reactive({ listings %>% filter(city %in% input$selectCity) })
    
    output$plot1<-renderPlot({
        if(input$selectCriteria==0){
            if(input$selectDiagram==1){
                p<-ggplot(data=average_availability(), aes(x=city, y=average_availability_30,fill=city)) + geom_bar(stat="identity", position=position_dodge())+
                    geom_text(aes(label=average_availability_30), vjust=1.6, color="white",position = position_dodge(0.9), size=3.5) + scale_fill_brewer(palette="Blues")
                print(p)
            
            }else {
                p <- ggplot(distribution_availability(), aes(city, availability_30))+ geom_boxplot(aes(fill = city),outlier.shape = NA) +
                    scale_y_continuous(limits = quantile(listings$availability_30, c(0.1, 0.9), na.rm = T)) + scale_fill_brewer(palette="Blues")
                print(p)
            }
        }else if (input$selectCriteria==1){
            if(input$selectDiagram==1){
                p<-ggplot(data=average_availability_bedrooms(), aes(x=city, y=average_availability_30, fill=bedrooms)) + geom_bar(stat="identity", position=position_dodge())+
                    geom_text(aes(label=average_availability_30), vjust=1.6, color="white",position = position_dodge(0.9), size=3) + scale_fill_brewer(palette="Blues")
                print(p)  
            }else{
                p <- ggplot(distribution_availability(), aes(city, availability_30))+ geom_boxplot(aes(fill = bedrooms),outlier.shape = NA) +
                    scale_y_continuous(limits = quantile(listings$availability_30, c(0.1, 0.9), na.rm = T)) + scale_fill_brewer(palette="Blues")
                print(p)
            }
        }else if (input$selectCriteria==2){
            
            if(input$selectDiagram==1){
                p<-ggplot(data=average_availability_type(), aes(x=city, y=average_availability_30, fill=room_type)) + geom_bar(stat="identity", position=position_dodge())+
                    geom_text(aes(label=average_availability_30), vjust=1.6, color="white",position = position_dodge(0.9), size=3) + scale_fill_brewer(palette="Blues")
                print(p) 
            }else{
                p <- ggplot(distribution_availability(), aes(city, availability_30))+ geom_boxplot(aes(fill = room_type),outlier.shape = NA) +
                    scale_y_continuous(limits = quantile(listings$availability_30, c(0.1, 0.9), na.rm = T)) + scale_fill_brewer(palette="Blues")
                print(p)
            }
        }
            
    })
    
    #REVENUE INFORMATION DURING THE LAST 30 DAYS
    average_revenue <-reactive ({
        listings %>% filter(city %in% input$selectCity) %>%  group_by(city) %>%
        summarise(average_revenue_30=round(mean(revenue_30),2))
    })
    average_revenue_bedrooms <-reactive ({
        listings %>% filter(city %in% input$selectCity) %>%  group_by(city,bedrooms) %>%
            summarise(average_revenue_30=round(mean(revenue_30),2))
    })
    average_revenue_type <-reactive ({
        listings %>% filter(city %in% input$selectCity) %>%  group_by(city,room_type) %>%
            summarise(average_revenue_30=round(mean(revenue_30),2))
    })
    distribution_revenue <-reactive({ listings %>% filter(city %in% input$selectCity) })

    output$plot2<-renderPlot({
        if(input$selectCriteria==0){
            if(input$selectDiagram==1){
            p<-ggplot(data=average_revenue(), aes(x=city, y=average_revenue_30, fill=city)) + geom_bar(stat="identity", position=position_dodge())+
                geom_text(aes(label=average_revenue_30), vjust=1.6, color="white",position = position_dodge(0.9), size=3.5) + scale_fill_brewer(palette="Blues")
            print(p)
            }else {
                p <- ggplot(distribution_revenue(), aes(city, revenue_30)) + geom_boxplot(aes(fill = city), outlier.shape = NA) +
                    scale_y_continuous(limits = quantile(listings$revenue_30, c(0.1, 0.9), na.rm = T)) + scale_fill_brewer(palette="Blues")
                print(p)
            }
            
        }else if (input$selectCriteria==1){
            if(input$selectDiagram==1){
                p<-ggplot(data=average_revenue_bedrooms(), aes(x=city, y=average_revenue_30, fill=bedrooms)) + geom_bar(stat="identity", position=position_dodge())+
                    geom_text(aes(label=average_revenue_30), vjust=1.6, color="white",position = position_dodge(0.9), size=3) + scale_fill_brewer(palette="Blues")
                print(p)
            }else{
                p <- ggplot(distribution_revenue(), aes(city, revenue_30))
                p + geom_boxplot(aes(fill = bedrooms), outlier.shape = NA) +
                    scale_y_continuous(limits = quantile(listings$revenue_30, c(0.1, 0.9), na.rm = T)) + scale_fill_brewer(palette="Blues")
            }
            
        }else if (input$selectCriteria==2){
            if(input$selectDiagram==1){
                p<-ggplot(data=average_revenue_type(), aes(x=city, y=average_revenue_30, fill=room_type)) + geom_bar(stat="identity", position=position_dodge())+
                    geom_text(aes(label=average_revenue_30), vjust=1.6, color="white",position = position_dodge(0.9), size=2.6) + scale_fill_brewer(palette="Blues")
                print(p)
                
            }else{
                p <- ggplot(distribution_revenue(), aes(city, revenue_30))
                p + geom_boxplot(aes(fill = room_type), outlier.shape = NA) +
                    scale_y_continuous(limits = quantile(listings$revenue_30, c(0.1, 0.9), na.rm = T))+ scale_fill_brewer(palette="Blues")
            }
            
        }
    })
    
    #TOP INFORMATION
    
    top_price <- reactive ({
        head(listings %>% select("country","city","listing_url","room_type","bedrooms","price_30") %>% filter(city==input$selectCityTop & price_30>5) %>% group_by(country,city,listing_url,room_type,bedrooms,price_30) %>% summarize() %>% arrange(price_30), 5)
    })
    top_revenue <- reactive ({
        head(listings %>% select("country","city","listing_url","room_type","bedrooms","revenue_30") %>% filter(city==input$selectCityTop& revenue_30>0)%>% group_by(country,city,listing_url,room_type,bedrooms,revenue_30) %>% summarize() %>% arrange(revenue_30) , 5) 
    })
    top_available <- reactive ({
        head(listings %>% select("country","city","listing_url","room_type","bedrooms","availability_30") %>% filter(city==input$selectCityTop & availability_30<30)%>% group_by(country,city,listing_url,room_type,bedrooms,availability_30) %>% summarize() %>% arrange(desc(availability_30)) , 5) 
    })
    top_nights <- reactive ({
        head(listings %>% select("country","city","listing_url","room_type","bedrooms","maximum_nights") %>% filter(city==input$selectCityTop & maximum_nights<99)%>% group_by(country,city,room_type,bedrooms,maximum_nights) %>% summarize() %>% arrange(desc(maximum_nights)) , 5) 
    })
    
    output$top_price <- renderTable(
        top_price()
    )
    output$top_revenue <- renderTable(
        top_revenue()
    )
    output$top_available <- renderTable(
        top_available()
    )
    output$top_nights <- renderTable(
        top_nights()
    )
    
    
    #PIE INFORMATION
    
    #Dynamic Widgets selection
    filter_country <- reactive ({
        listings %>% filter(country %in% input$selectCountryOne)  %>% group_by(city) %>% summarise()
    })
    
    output$city_selection <- renderUI ({
        selectInput("selectCityOne", h4("Choose the city you want to analyze : "), 
                    choices = c(unique(filter_country()[[1]])))
    })
    
    
    min_date <- reactive({
        listings %>% filter(city %in% input$selectCityOne) %>% group_by(data_date)%>% summarise() %>% arrange(data_date)
    })
    max_date <- reactive({
        listings %>% filter(city %in% input$selectCityOne) %>% group_by(data_date)%>% summarise() %>% arrange(desc(data_date))
    })
    
    output$date_range <- renderText({
        
        paste("Dates for", input$selectCityOne, ":", min_date()[1,1], " / ", min_date()[2,1], " / ", max_date()[1,1])
    })
    
    average_availability_One <-reactive({ 
        listings %>% filter(city == input$selectCityOne) %>% group_by(city) %>%
            summarise(average_availability_30=round(mean(availability_30),2))
    })
    average_availability_bedrooms_One <-reactive({ 
        listings %>% filter(city == input$selectCityOne) %>% group_by(city,bedrooms) %>%
            summarise(average_availability_30=round(mean(availability_30),2))
    })
    average_availability_type_One <-reactive({ 
        listings %>% filter(city == input$selectCityOne) %>% group_by(city,room_type) %>%
            summarise(average_availability_30=round(mean(availability_30),2))
    })
    
    output$plot3 <- renderPlot({
        if(input$selectOneCriteriaAvailability == 0){
            p<-ggplot(data=average_availability_One(), aes(x=city, y=average_availability_30, fill=city)) + geom_bar(stat="identity", position=position_dodge())+
                geom_text(aes(label=average_availability_30), vjust=1.6, color="white",position = position_dodge(0.9), size=3) +scale_fill_brewer(palette="Blues")
            print(p)
        }else if (input$selectOneCriteriaAvailability == 1){
            p<-ggplot(data=average_availability_bedrooms_One(), aes(x=bedrooms, y=average_availability_30, fill=bedrooms)) + geom_bar(stat="identity", position=position_dodge())+
                geom_text(aes(label=average_availability_30), vjust=1.6, color="white",position = position_dodge(0.9), size=3) +scale_fill_brewer(palette="Blues")
            print(p)  
            
        }else {
            p<-ggplot(data=average_availability_type_One(), aes(x=room_type, y=average_availability_30, fill=room_type)) + geom_bar(stat="identity", position=position_dodge())+
                geom_text(aes(label=average_availability_30), vjust=1.6, color="white",position = position_dodge(0.9), size=3) +scale_fill_brewer(palette="Blues")
            print(p) 
        }
        
    })
    
    average_revenue_One <-reactive({ 
        listings %>% filter(city == input$selectCityOne) %>% group_by(city) %>%
            summarise(average_revenue_30=round(mean(revenue_30),2))
    })
    average_revenue_bedrooms_One <-reactive({ 
        listings %>% filter(city == input$selectCityOne) %>% group_by(city,bedrooms) %>%
            summarise(average_revenue_30=round(mean(revenue_30),2))
    })
    average_revenue_type_One <-reactive({ 
        listings %>% filter(city == input$selectCityOne) %>% group_by(city,room_type) %>%
            summarise(average_revenue_30=round(mean(revenue_30),2))
    })
    
    output$plot4 <- renderPlot({
        if(input$selectOneCriteriaRevenue == 0){
            p<-ggplot(data=average_revenue_One(), aes(x=city, y=average_revenue_30, fill=city)) + geom_bar(stat="identity", position=position_dodge())+
                geom_text(aes(label=average_revenue_30), vjust=1.6, color="white",position = position_dodge(0.9), size=3) +scale_fill_brewer(palette="Blues")
            print(p)
        }else if (input$selectOneCriteriaRevenue == 1){
            p<-ggplot(data=average_revenue_bedrooms_One(), aes(x=bedrooms, y=average_revenue_30, fill=bedrooms)) + geom_bar(stat="identity", position=position_dodge())+
                geom_text(aes(label=average_revenue_30), vjust=1.6, color="white",position = position_dodge(0.9), size=3)+scale_fill_brewer(palette="Blues")
            print(p) 
            
        }else {
            p<-ggplot(data=average_revenue_type_One(), aes(x=room_type, y=average_revenue_30, fill=room_type)) + geom_bar(stat="identity", position=position_dodge())+
                geom_text(aes(label=average_revenue_30), vjust=1.6, color="white",position = position_dodge(0.9), size=3)+scale_fill_brewer(palette="Blues")
            print(p)
            
        }
    })
    
    room_type_pie <- reactive ({
        listings %>% filter(city %in% input$selectCityOne) %>% group_by(room_type) %>% summarise(count=n()) %>% transmute(room_type, percent = round(count/sum(count),3)*100)
        })
    output$pie_room_type <- renderPlot({
        p<-ggplot(data=room_type_pie(), aes(x=input$selectCityOne, y=percent,fill=room_type)) + geom_bar(stat="identity")+
            geom_text(aes(label=percent), vjust=1.6, color="black",position = position_dodge(0.9), size=3.5)
        pie <- p + coord_polar("y", start=0) +scale_fill_brewer(palette="Blues")
        print(pie)
    })
    
    bedrooms_pie <- reactive ({
        listings %>% filter(city %in% input$selectCityOne) %>% group_by(bedrooms) %>% summarise(count=n())%>% transmute(bedrooms, percent = round(count/sum(count),3)*100)
    })
    output$pie_bedrooms <- renderPlot({
        p<-ggplot(data=bedrooms_pie(), aes(x=input$selectCityOne, y=percent,fill=bedrooms)) + geom_bar(stat="identity")+
            geom_text(aes(label=percent), vjust=1.6, color="black",position = position_dodge(0.9), size=2.9)
        pie <- p + coord_polar("y", start=0) +scale_fill_brewer(palette="Blues")
        print(pie)
    })
    
    #LEAFLET MAP
    leaflet_map <-reactive ({
        if(is.null(input$selectTypeMap) & is.null(input$selectBedroomMap)){
            listings %>% filter(city %in% input$selectCityMap & price_30 >= input$selectPrice[1] & price_30 <= input$selectPrice[2])
            
        }else if(is.null(input$selectTypeMap) & !is.null(input$selectBedroomMap)){
            listings %>% filter(city %in% input$selectCityMap & price_30 >= input$selectPrice[1] & price_30 <= input$selectPrice[2] & bedrooms %in% input$selectBedroomMap)
        }else if(!is.null(input$selectTypeMap) & is.null(input$selectBedroomMap)){
            listings %>% filter(city %in% input$selectCityMap & price_30 >= input$selectPrice[1] & price_30 <= input$selectPrice[2] & room_type %in% input$selectTypeMap)
        }else{
            listings %>% filter(city %in% input$selectCityMap & price_30 >= input$selectPrice[1] & price_30 <= input$selectPrice[2] & room_type %in% input$selectTypeMap & bedrooms %in% input$selectBedroomMap)
        }
        
    })
    
    popup <- reactive({
        paste(sep = " ",
              "<span style = 'font-weight: bold;'>Room type :</span>", leaflet_map()$room_type, "<br/>",
              "<span style = 'font-weight: bold;'>Number of bedrooms :</span>", leaflet_map()$bedrooms, "<br/>",
              "<span style = 'font-weight: bold;'>Neighborhood :</span>", leaflet_map()$neighbourhood_cleansed, "<br/>",
              "<span style = 'font-weight: bold;'>URL :</span>", leaflet_map()$listing_url, "<br/><br/>",
              "<span style = 'font-weight: bold;'>Price :</span>", leaflet_map()$price, "<br/>"
        )
    })
    output$mymap <- renderLeaflet({
        m <- leaflet(leaflet_map()) %>% addTiles() %>% addMarkers(lng=leaflet_map()$longitude, lat=leaflet_map()$latitude, clusterOptions = markerClusterOptions(),popup = popup())
        print(m)
    })

})
