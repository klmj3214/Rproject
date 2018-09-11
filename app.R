
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



textInputRow<-function (inputId, label, value = "") 
{
  div(style="display:inline-block",
      tags$label(label, `for` = inputId), 
      tags$input(id = inputId, type = "text", value = value,class="input-small"))
}


ui<-dashboardPage(dashboardHeader(title = "google drive console"),
                  dashboardSidebar(
                    sidebarMenu(menuItem(actionButton("connect","connect")),
                                menuItem(actionButton("update","update")),
                                menuItem(actionButton("upload","upload")),
                                menuItem(selectInput("selectA","Country",c("US","UK","China")))
                    )),
                  dashboardBody(
                    fluidRow(textInputRow("term1","Country:",value = ""),
                             textInputRow("term2","facility_code:",value = ""),
                             textInputRow("term3","facility_name:",value = ""),
                             textInputRow("term4","facility_name_local:",value = ""),
                             textInputRow("term5","facility_entity:",value = ""),
                             textInputRow("term6","acute_bed:",value = ""),
                             textInputRow("term7","bed_category:",value = ""),
                             textInputRow("term8","facility_type:",value = ""),
                             textInputRow("term9","facility_ownership:",value = ""),
                             textInputRow("term10","facility_Network:",value = ""),
                             textInputRow("term11","facility_class:",value = ""),
                             textInputRow("term12","City:",value = ""),
                             textInputRow("term13","State:",value = ""),
                             textInputRow("term14","Region:",value = ""),
                             textInputRow("term15","main_cc:",value = ""),
                             textInputRow("term16","main_ac:",value = ""),
                             textInputRow("term17","main_no:",value = ""),
                             textInputRow("term18","main_fcc:",value = ""),
                             textInputRow("term19","main_fac:",value = ""),
                             textInputRow("term20","main_fno:",value = ""),
                             tableOutput("table5")))
)


server<-function(input,output){
  
  observeEvent(input$connect, {
    drive_auth()
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

