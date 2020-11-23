#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(maps)
library(mapproj)
library(leaflet)
library(shinydashboard)


suppressPackageStartupMessages(library(googleVis))



shinyUI( dashboardPage(skin = "yellow",
    
    dashboardHeader(title = "Airbnb Analysis"),
    
    dashboardSidebar(
        
        sidebarMenu(
            menuItem("Home", tabName = "home", icon = icon("home")),
            menuItem("Comparator", tabName = "comparing_cities", icon = icon("dashboard")),
            menuItem("top", tabName = "top", icon = icon("kiss-wink-heart")),
            menuItem("My city", tabName = "city", icon = icon("thumbtack")),
            menuItem("Map", tabName = "map", icon = icon("map"))
            
        )
        
    ),
    
    dashboardBody(
        tabItems(
            tabItem(tabName = "home",
                    h1("Welcome on our Dash Board ! ", style="font-family: 'Gill Sans', sans-serif; font-weight:bold;"),
                    h2("Presentation", style="font-family: 'Gill Sans', sans-serif;text-decoration: underline;"),
                    p(
                        "We are 3 students working on an Analytic project. We designed for you a dashboard which allows to visualize some Airbnb data !"
                    ),
                    p(
                        "This is a simple shiny application. Choose cities you want to compare, select the place you want to visit. Enjoy ! "
                    ),
                    p(
                        "Fist, let's have a look on some instructions ! "
                    ),
                    h3("Comparing different cities", style="font-family: 'Gill Sans', sans-serif;text-decoration: underline;"),
                    p(
                        "On the first item ('Comparator'), you will be to compare different cities."
                    ),
                    p(
                        "First, select all the cities you want to analyze. You'll see some Graphs concerning availabilty and revenue about all the appartments in the cities choosen.  "
                    ),
                    fluidRow(
                        box(
                            img(src = "comparator.png", height = 270),
                        ),
                        box(
                            img(src = "comparator2.png", height = 270)
                        )
                    ),
                    h3("Some rankings", style="font-family: 'Gill Sans', sans-serif;text-decoration: underline;"),
                    
                    p("Nothing difficult here, select a city and have a look and the five first cities depending of some features."),
                    fluidRow(
                            column( 12,align="center" ,img(src = "top.png", height = 270))
                    ),
                    
                    h3("Deep dive into one city", style="font-family: 'Gill Sans', sans-serif;text-decoration: underline;"),
                    p(
                        "Your choice for the next hollydays may be already done. No problem, you will be able to get more information about this city."
                    ),
                    p(
                        "Select the city you're interested in and have a look on the information. House size ? Room type ? The city will no longer have secret for you !"
                    ),
                    p(
                        img(src = "city.png", height = 300),
                        align = "center"
                    ),
                    
                    h3("Map", style="font-family: 'Gill Sans', sans-serif;text-decoration: underline;"),
                    p(
                        "If you want to have a global look on available places in a city, use our Leaflet map ! "
                    ),
                    p(
                        "Select the city and features and visualize every places ! Don't forget to to click on the cursors to get more information !"
                    ),
                    fluidRow(
                        column( 12,align="center" ,img(src = "map.png", height = 270))
                    ),
                    
                    
                    
        ),
            tabItem(tabName = "comparing_cities",
                fluidRow(
                    box(
                        title = "Input", status = "warning", solidHeader = TRUE,
                        helpText("In this little dashboard, you will be able to compare some cities. Choose them carefully and add some dimensions to your analyze if you want. Enjoy !"),
                        checkboxGroupInput("selectCity", 
                                           label="Select cities you want to analyze : ", 
                                           choices = c(unique(listings$city)), inline = TRUE)
                    ),
                    box(
                        title = "Criteria", status = "warning", solidHeader = TRUE,
                        selectInput("selectCriteria", label ="Choose one of these criteria : ", 
                                    choices = list("No specific criteria"=0,"Number of bedrooms" = 1, "Type of the room" = 2), selected = 0),
                        
                        selectInput("selectDiagram", h4("Wich information do you want to see : "), 
                                    choices = list("Average information (histogram)" = 1, "Distribution information (Box)" = 2), selected = 1)
                    )
                ),
                fluidRow(
                    box(
                        title = "Availability information", status = "primary", solidHeader = TRUE,
                        plotOutput("plot1",height = 250)
                    ),
                    box(
                        title = "Revenue Information", status = "primary", solidHeader = TRUE,
                        plotOutput("plot2",height = 250)
                    )
                )
            ),
            tabItem(tabName = "top",
                    fluidRow(
                        box(
                            title = "Input", status = "warning", solidHeader = TRUE,
                            selectInput("selectCityTop", label = "Choose your city :", 
                                        choices = c(unique(listings$city)))
                        )
                    ),
                    fluidRow(
                        box(
                            title = "Top 5 cheaper places", status = "primary", solidHeader = TRUE,
                            column( 12,align="center" ,tableOutput("top_price"))
                            
                            
                        ),
                        box(
                            title = "Top 5 revenues", status = "primary", solidHeader = TRUE,
                            column( 12,align="center" ,tableOutput("top_revenue"))
                        )
     
                    ),
                    fluidRow(
                        box(
                            title = "Top 5 available places", status = "primary", solidHeader = TRUE,
                            column( 12,align="center" ,tableOutput("top_available"))
                        ),
                        box(
                            title = "Top 5 maximum nights", status = "primary", solidHeader = TRUE,
                            column( 12,align="center" ,tableOutput("top_nights"))
                        )
                    )
                    
                    ),
            tabItem(tabName = "city",
                fluidRow(
                    box(
                        title = "Inputs", status = "warning", solidHeader = TRUE,
                        helpText("If you want information about only one city, you're in the right place ! "),
                        selectInput("selectCountryOne",label = "Choose the country : ", 
                                    choices = c(unique(listings$country)), selected = "france"),
                        htmlOutput("city_selection"),
                        textOutput("date_range"),
                        htmlOutput("date_selection")
                    )
                ),
                fluidRow(
                    box(
                        title = "Room type", status = "primary", solidHeader = TRUE,
                        plotOutput("pie_room_type"),
                    ),
                    box(
                        title = "House size", status = "primary", solidHeader = TRUE,
                        plotOutput("pie_bedrooms")
                    )
                ),
                fluidRow(
                    box(
                        title = "Availability information", status = "primary", solidHeader = TRUE,
                        selectInput("selectOneCriteriaAvailability", label = "Choose one of these criteria : ", 
                                    choices = list("No specific criteria"=0,"Number of bedrooms" = 1, "Type of the room" = 2), selected = 0),
                        plotOutput("plot3",height = 250)
                    ),
                    box(
                        title = "Revenue information", status = "primary", solidHeader = TRUE,
                        selectInput("selectOneCriteriaRevenue", label="Choose one of these criteria : ", 
                                    choices = list("No specific criteria"=0,"Number of bedrooms" = 1, "Type of the room" = 2), selected = 0),
                        plotOutput("plot4",height = 250)
                    )
                ),
            ),
            tabItem(tabName = "map",
                fluidRow(
                       box(
                           title = "Leaflet Map", status = "primary",width = 8, height = 850, solidHeader = TRUE,
                           leafletOutput("mymap",width="100%", height = "750px")
                       ),
                       box(
                           title = "Inputs", status = "warning",width = 4, solidHeader = TRUE,
                           helpText("You want to learn more about a city ? Let's visualize a map to get more information !"),
                           selectInput("selectCityMap", h4("Choose one of these city : "), 
                                       choices = c(unique(listings$city)), selected = "mallorca"),
                           helpText("Add granularity to your research :"),
                           sliderInput("selectPrice", label = h3("Price range"), min = 0, 
                                       max = 500, value = c(0, 470)),
                           box(
                               checkboxGroupInput("selectTypeMap", h4("Which type of rooms ?"), choices = c(unique(listings$room_type)), selected = "Hotel room")
                           ),
                           box(
                               checkboxGroupInput("selectBedroomMap", h4("How many bedrooms ?"), choices = c(unique(listings$bedrooms)),selected ="2")
                           )
                           
                       )
                )
            )
        )
    )
))


