

server <- function(input , output) {
    
    selected_category <- reactive({
        
        accidents_data %>%
            filter(category == input$selected_category)
        
    })
    
    
    selected_region <- reactive({
        
        if(input$selected_region == "all") {
            selected_category()
        } else {
            selected_category() %>%
                filter(region == input$selected_region)
        }
    })
    
    
    selected_data_1 <- reactive({
        
        data <- selected_region() %>% 
            mutate(city = fct_reorder(city, total_count,
                                      .desc = as.logical(input$position))) %>%
            arrange(city) %>%
            filter(group_indices(., city) %in% 1:(input$n_cities)) %>%
            mutate(city = fct_drop(city))
        
        if(input$position == "FALSE") {
            data <- data %>%
                mutate(city = fct_rev(city))
        }
        
        data
        
    })
    
    selected_data_2 <- reactive({
        
        selected_category() %>%
            filter(city %in% input$selected_cities) %>%
            mutate(city = fct_drop(city), 
                   city = fct_reorder(city, total_count,
                                      .desc = TRUE))
        
    })
    
    display_data <- reactive({
        
        if(input$sidebar == "region_wise") {
            selected_data_1()
        } else {
            selected_data_2()
        }
        
    })
    
  
    output$barplot <- renderPlotly({
        
        display_data() %>%
            distinct(city, total_count) %>%
            mutate(city = fct_rev(city)) %>%
            plot_ly(x = ~total_count, y = ~city,
                    type = "bar", color = ~city,
                    orientation = "h", hoverinfo = "text", 
                    text = ~paste0(city, ": ", total_count)) %>%
            layout(xaxis = list(title = ""),
                   yaxis = list(title = "", ticklen = 8, tickangle = 315, 
                                tickcolor = "transparent"),
                   legend = list(traceorder = "reversed"))
        
    })

   
    output$lineplot_1 <- renderPlotly({
        
        display_data() %>%
            plot_ly(x = ~year, y = ~count,
                    type = "scatter", mode = "lines+markers",
                    color = ~city, hoverinfo = "text", 
                    text = ~paste0(city, ", ", year, ": ", count)) %>% 
            layout(xaxis = list(title = "", dtick = 1),
                   yaxis = list(title = "", ticklen = 1,
                                tickcolor = "transparent"))
        
    })
    
    
    output$lineplot_2 <- renderPlotly({
        
        display_data() %>%
            plot_ly(x = ~year, y = ~cumulative_count,
                    type = "scatter", mode = "lines+markers",
                    color = ~city, hoverinfo = "text", 
                    text = ~paste0(city, ", ", year, ": ", cumulative_count)) %>% 
            layout(xaxis = list(title = "", dtick = 1),
                   yaxis = list(title = "", ticklen = 1,
                                tickcolor = "transparent"))
        
    })
    
    
}