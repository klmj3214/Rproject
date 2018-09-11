
install.packages("shiny")
install.packages("shinydashboard")
install.packages("data.table")
install.packages("DT")
install.packages("dbplyr")
install.packages("googledriver")
install.packages('readxl')
install.packages("xlsx")
library(xlsx)
library(readxl)
library(shiny);library(shinydashboard);library(data.table);library(DT);library(dbplyr)
library(googledrive)



ui<-fluidPage(titlePanel("update data"),
              fluidRow(column(4,
                              wellPanel(actionButton("connect","connect"),
                                        actionButton("update","update"),
                                        actionButton("upload","upload"),
                                        selectInput("selectA","Country",c("US","UK","China")))
                              ),
                       column(8,
                              mainPanel(textInput("term1","Country:",value = ""),
                                        textInput("term2","facility_code:",value = ""),
                                        textInput("term3","facility_name:",value = ""),
                                        textInput("term4","facility_name_local:",value = ""),
                                        textInput("term5","facility_entity:",value = ""),
                                        textInput("term6","acute_bed:",value = ""),
                                        textInput("term7","bed_category:",value = ""),
                                        textInput("term8","facility_type:",value = ""),
                                        textInput("term9","facility_ownership:",value = ""),
                                        textInput("term10","facility_Network:",value = ""),
                                        textInput("term11","facility_class:",value = ""),
                                        textInput("term12","City:",value = ""),
                                        textInput("term13","State:",value = ""),
                                        textInput("term14","Region:",value = ""),
                                        textInput("term15","main_cc:",value = ""),
                                        textInput("term16","main_ac:",value = ""),
                                        textInput("term17","main_no:",value = ""),
                                        textInput("term18","main_fcc:",value = ""),
                                        textInput("term19","main_fac:",value = ""),
                                        textInput("term20","main_fno:",value = ""),
                                        verbatimTextOutput('text'),
                                        tableOutput("table5")))
                       ))


server<-function(input,output){
  
  observeEvent(input$connect, {
    drive_find()
    drive_download("test.xlsx")
  })

  df<-eventReactive(input$update,{
    cat(file=stderr(), "#### event log ####: tab button clicked\n")
    dt<-read_excel("test.xlsx",sheet = input$selectA,na = "NA")
    a<-c(input$term1,input$term2,input$term3,input$term4,input$term5,input$term6,input$term7,input$term8,input$term9,input$term10,input$term11,input$term12,input$term13,input$term14,input$term15,input$term16,input$term17,input$term18,input$term19,input$term20)
    dt1<<-rbind(dt,a)
    write.xlsx(as.data.frame(dt1),"test.xlsx",sheetName=input$selectA,row.names = F)
    dt1
  })


  output$table5<-renderTable({if(input$update>0){df()}else{NA}})
  
  
  observeEvent(input$upload,{
    drive_rm("test.xlsx")
    drive_upload("test.xlsx", name ="test.xlsx",type='xlsx')
    file.remove("test.xlsx")
  })
  }


shinyApp(ui, server)

