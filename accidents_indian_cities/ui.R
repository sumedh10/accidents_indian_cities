
header <- dashboardHeader(
    title = "Road accidents in selected Indian cities (2011-2015)",
    titleWidth = 520
)

sidebar <- dashboardSidebar(
    sidebarMenu(
        id = "sidebar", 
        menuItem("Region-wise", tabName = "region_wise"), 
        
        menuItem("Compare cities", tabName = "compare_cities"), 
        
        selectInput("selected_category", label = "Select category", 
                    choices = c("Total accidents" = "total_accidents", 
                                "Killed" = "killed", "Injured" = "injured"), 
                    selected = "Total accidents")
    ), 
    conditionalPanel(
        condition = "input.sidebar == 'region_wise'", 
        
        selectInput("selected_region", label = "Select geographic region", 
                    choices = c("All India" = "all", 
                                "Metro" = "metro", "Non-metro" = "non_metro"), 
                    selected = "All India"),
        
        selectInput("position", label = NULL, 
                    choices = c("Top" = "TRUE", "Bottom" = "FALSE"), 
                    selected = "Top"),
        
        sliderInput("n_cities", label = "Number of cities", 
                    min = 2, max = 7, value = 5,
                    step = 1)
    ), 
    conditionalPanel(
        condition = "input.sidebar == 'compare_cities'", 
        
        selectizeInput("selected_cities", "Choose upto 5 cities to compare", 
                       choices = all_cities, 
                       selected = c("Delhi", "Mumbai", "Kolkata", "Bengaluru", 
                                    "Hyderabad"), 
                       multiple = TRUE, options = list(maxItems = 5))
        
    )
)


body <- dashboardBody(
    fluidRow(
        box(
            title = "Total", plotlyOutput("barplot"), 
            status = "success", solidHeader = TRUE, collapsible = TRUE, width = 12
        )
    ), 
    fluidRow(
        box(
            title = "Over time", plotlyOutput("lineplot_1"), 
            status = "success", solidHeader = TRUE, collapsible = TRUE, width = 12
        )
    ), 
    fluidRow(
        box(
            title = "Cumulative", plotlyOutput("lineplot_2"), 
            status = "success", solidHeader = TRUE, collapsible = TRUE, width = 12
        )
    )
)


ui <- dashboardPage(header, sidebar, body, skin = "purple")