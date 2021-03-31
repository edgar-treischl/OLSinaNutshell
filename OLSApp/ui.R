#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(GGally)
library(ggplot2)
library(rmarkdown)
library(shinyjs)

# Define UI for application that draws a histogram
shinyUI(fixedPage(
    theme = bslib::bs_theme(bootswatch = "flatly"), #for theming
    useShinyjs(),  # Include shinyjs
    # Application title
    titlePanel("OLS in a Nutshell"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("dataset", h5("Dataset:"), choices = c("Cars", "ChickenWeight", "Iris", "Catholic", "Swiss")),
            uiOutput('iv'),
            uiOutput('dv'),
            downloadButton("report", "Download Summary"),
            br(),
            br(),
            actionButton("code", "Source Code", onclick ="window.open('https://github.com/edgartreischl', '_blank')", icon = icon("github"))
        ),
        

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(type = "tabs",
                        #tabPanel("Data",icon = icon("table"),
                        #HTML(
                        #paste(
                        #h5("...and here you see how the raw data looks like:"),'<br/>')),
                        #numericInput("obs", label = h5("N"), 5),
                        #tableOutput("view")),
                        tabPanel("Start", icon = icon("play"),
                                 HTML(
                                     paste(
                                         h4("Calculate the results of a linear regression without any programming skills! Choose a sample data set, 
                                  an independent variable (X) and a dependent variable (Y). For example, use the Catholic data set to estimate 
                                  whether a family's income (faminc8) has an impact on children's reading achievement (read12)."),'<br/>'),
                                     '<center><img src="http://139.59.129.5/wp-content/uploads/2020/07/menu.png" width=75%/></center>')),
                        tabPanel("(1) Summary Statistics", icon = icon("calculator"),
                                 HTML(
                                     paste(
                                         h5("Let's start by looking at the data. You have selected the following two variables:"),'<br/>')),
                                 verbatimTextOutput("summary"),
                                 HTML(
                                     paste(
                                         h5("In terms of data analysis, it's always a good idea to explore the dataset in the beginning.
                                  Which variables were measured and on what scale? Above, you see the summary statistics for the independent and the dependent variable. 
                                  Hopefully, this gives you an impression how your variables are measured and distributed."),'<br/>',
                                         h5("Look at a histogram of the dependent variable to get a clearer picture about the distribution:"),'<br/>')),
                                 plotOutput("distPlot_dv"),
                                 HTML(
                                     paste(
                                         h5("And the independent variable:") )),
                                 plotOutput("distPlot_iv")),
                        tabPanel("(2) Linearity ", icon = icon("ruler"),
                                 HTML(
                                     paste(
                                         h5("In a linear regression, we estimate the effect of an independent variable X on a dependent variable Y. 
                                  Often, we use several independent variables to predict Y, but let's stick to the simple model with two variables. 
                                  The principals of a linear regression are the same."),'<br/>',
                                         h5("So, what happens when we regress X on Y? We calculate the linear association between X and Y and we try to 
                                  fit a line in accordance to our data. We can use a scatter plot to check the linear association. Let's have a look for the chosen variables:"),'<br/>')),
                                 plotOutput("scatter"),
                                 HTML(
                                     paste(
                                         h5("What would you say? Is there a linear association between X and Y?"),'<br/>')),
                                 actionButton("button3", "Not linear?"),
                                 hidden(
                                     div(id='text_div3',
                                         verbatimTextOutput("text5")))),
                        tabPanel("(3) Regression", icon = icon("rocket"),
                                 HTML(
                                     paste(
                                         h5("Irrespective whether we saw a linear association, we may want to run a regression 
                                  to illustrate the approach. You get the following output from your statistic software::"),'<br/>')),
                                 verbatimTextOutput("model"),
                                 HTML(
                                     paste(
                                         h5("Can you interpret the results? Can you calculate the predicted value if X increases by 1 unit?"),'<br/>')),
                                 withMathJax(helpText("Hint: $$y_i=\\beta_1+\\beta_2*x_i$$")),
                                 actionButton("button1", "Another Hint?"),
                                 hidden(
                                     div(id='text_div1',
                                         verbatimTextOutput("text1"),
                                         verbatimTextOutput("text2"),
                                         verbatimTextOutput("text3")))),
                        tabPanel("(4) Plot it", icon = icon("area-chart"),
                                 HTML(
                                     paste(
                                         h5("Now that we know whether X and Y are associated, can you tell me how strong the effect is? 
                                  Let's use the regression results and visualise the point estimates from the regression. Has X a strong effect on Y?"),'<br/>')),
                                 #actionButton("go", "Plot it", icon = icon("area-chart")),
                                 plotOutput("plot"),
                                 actionButton("button2", "Hint"),
                                 hidden(
                                     div(id='text_div2',
                                         verbatimTextOutput("text4")))),
                        tabPanel("(5) Datafit", icon = icon("hand-point-right"),
                                 HTML(
                                     paste(
                                         h5("Irrespective of statistical significance and effect size, one question remains: 
                                  How well does X explain Y?"),'<br/>')),
                                 plotOutput("error"),
                                 HTML(
                                     paste(
                                         h5("Most times the prediction of the regression is not perfect, so we make a mistake or an error. 
                                  In the output the error is displayed in red. It's the deviation between the predicted value (regression line) 
                                  and the observed value. What would you say in your case? How well explains X your outcome?"),'<br/>'))),
                        tabPanel("(6) Total Variance", icon = icon("times"),
                                 HTML(
                                     paste(
                                         h5("You may say, we make an error, no big deal! Well, to understand whether this is a big deal, 
                                  we should check several aspects. At least you should know R-squared. It is an indicator which helps 
                                  us to assess how big the mistake is or how well the model explains the outcome."),'<br/>',
                                         h5("To understand R-squared, we have to think about the total variance between X and Y. 
                                  Let's assume that X cannot explain Y at all. What would you say, how would a corresponding 
                                  regression line or the graph look like?"),'<br/>')),
                                 plotOutput("total"),
                                 HTML(
                                     paste(
                                         h5("You can see it in the output, the regression line would be flat or constant. Regardless of the X value, 
                                  we would observe the same Y value. Thus, the blue lines in the graph above show you the total variance 
                                  between X and Y, and since we assume that X cannot explain Y at all, that's the total error we could make. "),'<br/>',
                                         h5(""),'<br/>'))),
                        tabPanel("(7) Explained Variance", icon = icon("lightbulb"),
                                 HTML(
                                     paste(
                                         h5("We know better, don't we? We have already fitted a regression line and based on the observed values, 
                                  X explains Y to a certain amount. The next output shows the explained variance - the green area - 
                                  the amount of Y that can actually be explained by X:"),'<br/>')),
                                 plotOutput("regression")),
                        
                        tabPanel("(8) R-squared", icon = icon("hand-peace"), 
                                 HTML(
                                     paste(
                                         h5("So we know the total variance and the explained variance. Thus, we can assess the error by calculating 
                                  R-squared, which is the proportion (%) of the variance of Y that is predictable based on the regression. 
                                  The last bar plot shows all three variance components.."),'<br/>',
                                         plotOutput("variance"),
                                         h5("Now it's up to you! How well does your X explains your outcome?"),'<br/>')))
                        
            )
        )
    )
))
