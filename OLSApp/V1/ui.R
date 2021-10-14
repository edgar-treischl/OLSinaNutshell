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
library(waiter)

#library(shinyjs)

# Define UI for application that draws a histogram
shinyUI(fixedPage(
  theme = bslib::bs_theme(bootswatch = "flatly"), #for theming
  use_waiter(),
  waiter_show_on_load(html = spin_flower()),
  #useShinyjs(),  # Include shinyjs
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
      actionButton("code", "Source Code", onclick ="window.open('https://github.com/edgartreischl/OLSinaNutshell.git', '_blank')", icon = icon("github"))
    ),
    

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Start", icon = icon("play"),
                           includeMarkdown("txt/start.md")
                  ),
                  tabPanel("(1) Summary Statistics", icon = icon("calculator"),
                           includeMarkdown("txt/summary1.md"),
                           verbatimTextOutput("summary"),
                           includeMarkdown("txt/summary2.md"),
                           plotOutput("distPlot_dv"),
                           h5("And the independent variable:"),
                           plotOutput("distPlot_iv")
                           ),
                  tabPanel("(2) Linearity ", icon = icon("ruler"),
                           includeMarkdown("txt/linear1.md"),
                           plotOutput("scatter"),
                           h5("What would you say? Is there a linear association between X and Y?"),
                           actionButton("button3", "Not linear?"),
                           hidden(
                             div(id='text_div3',
                                 verbatimTextOutput("text5")))
                           ),
                  tabPanel("(3) Regression", icon = icon("rocket"),
                           includeMarkdown("txt/regression.md"),
                           verbatimTextOutput("model"),
                           h5("Can you interpret the results? Can you calculate 
                              the predicted value if X increases by 1 unit?"),
                           withMathJax(helpText("Hint: $$y_i=\\beta_1+\\beta_2*x_i$$")),
                           actionButton("button1", "Another Hint?"),
                           hidden(
                             div(id='text_div1',
                                 verbatimTextOutput("text1"),
                                 verbatimTextOutput("text2"),
                                 verbatimTextOutput("text3")))
                           ),
                  tabPanel("(4) Plot it", icon = icon("area-chart"),
                           includeMarkdown("txt/plot.md"),
                           plotOutput("plot"),
                           actionButton("button2", "Hint"),
                           hidden(
                             div(id='text_div2',
                                 verbatimTextOutput("text4")))
                           ),
                  tabPanel("(5) Datafit", icon = icon("hand-point-right"),
                           includeMarkdown("txt/datafit.md"),
                           plotOutput("error"),
                           includeMarkdown("txt/datafit2.md"),
                           ),
                  tabPanel("(6) Total Variance", icon = icon("times"),
                           includeMarkdown("txt/variance.md"),
                           plotOutput("total"),
                           includeMarkdown("txt/variance2.md")
                           ),
                  tabPanel("(7) Explained Variance", icon = icon("lightbulb"),
                           includeMarkdown("txt/variance3.md"),
                           plotOutput("regression")
                           ),
                  tabPanel("(8) R-squared", icon = icon("hand-peace"),
                           includeMarkdown("txt/variance4.md"),
                           plotOutput("variance"),
                           includeMarkdown("txt/variance5.md")
                           )
                
      )
    )
  )
))
