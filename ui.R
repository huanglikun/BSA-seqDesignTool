library(shinydashboard)
library(shinydashboardPlus)
library(shinyBS)
library(shinyjs)
library(DT)

ui <- dashboardPagePlus(
    skin = "green",
    title = "BSA-seq Design Tool",
    header = dashboardHeaderPlus(
        title = span("BSA-seq Design Tool"),
        titleWidth = 350,
    dropdownMenu(
    type = "notifications",
        headerText = strong("version:V1.0"),
        icon = icon("question"),
        badgeStatus = NULL),
        enable_rightsidebar = TRUE,
        rightSidebarIcon = "gears"),
    sidebar = dashboardSidebar(
        width = 350,
        sidebarMenu(
            menuItem("PARAMETERS",
                tabName = "parameters",
                icon = icon("calculator"),
                startExpanded = TRUE,
                selectInput(
                    inputId = "uaa",
                    label = "Species",
                    choices = list(
                        "Arabidopsis" = "Arabidopsis",
                        "Cucumber" = "Cucumber",
                        "Maize" = "Maize",
                        "Rapeseed" = "Rapeseed",
                        "Rice" = "Rice",
                        "Tobacco" = "Tobacco",
                        "Tomato" = "Tomato",
                        "Wheat" = "Wheat",
                        "Yeast" = "Yeast"
                        , "Other" = "Other"
                    )
                ),
                div(id = "others",
                    textInput(
                        inputId = "nChr",
                        label = "Gametal chromosome number",
                        value = "5",
                        placeholder = "Number of chromosomes in haploid"
                    ),
                    radioButtons(
                        inputId = "knownG",
                        label = "Genome size information provided",
                        choiceNames = c("in cM", "in Mb"),
                        choiceValues = c("cM", "Mb"),
                        selected = c("cM"),
                        inline = T
                    ),
                    div(id = "selcm",
                        textInput(
                            inputId = "GsizecM",
                            label = "Genome size (cM):",
                            value = "600",
                            placeholder = "Genetic map length (cM) of species"
                        )
                    ),
                    div(id = "selmb",
                        textInput(
                            inputId = "GsizeMb",
                            label = "Genome size (Mb):",
                            value = "119",
                            placeholder = "Genome size (Mb) of species"
                        ),
                        textInput(
                            inputId = "ratio",
                            label = "Physical distance (kb) per cM",
                            value = "199",
                            placeholder = ""
                        )
                    )
                ),
                radioButtons(
                    inputId = "popType",
                    label = "Population Type",
                    choiceNames = list("RIL", "H/DH", tags$span("F", tags$sub("2", .noWS = c("outside")), .noWS = c("inside")), tags$span("F", tags$sub("3", .noWS = c("outside")), .noWS = c("inside")), tags$span("F", tags$sub("4", .noWS = c("outside")), .noWS = c("inside"))),
                    choiceValues = c("RIL", "H", "F2", "F3", "F4"),
                    selected = c("F2"),
                    inline = T
                ),
                radioButtons(
                    inputId = "known",
                    label = "Which is given?",
                    choiceNames = c("Power", "Population Size"),
                    choiceValues = c("pow", "popsize"),
                    selected = c("pow"),
                    inline = T
                ),
                sliderInput(
                    inputId = "knownValue",
                    label = "Power",
                    width = "100%",
                    value = c(0.9),
                    min = 0.6,
                    max = 1,
                    step = 0.01
                ),
                sliderInput(
                    inputId = "h2a",
                    label = "Heritability",
                    width = "100%",
                    value = c(0.05, 0.1),
                    min = 0.01,
                    max = 0.2,
                    step = 0.01,
                    sep = ""
                ),
                sliderInput(
                    inputId = "rda",
                    label = "Degree of dominance",
                    width = "100%",
                    value = 1,
                    min = 0,
                    max = 1.5,
                    step = 0.1,
                    sep = ""
                ),
                sliderInput(
                    inputId = "pa",
                    label = "Pool proportion",
                    width = "100%",
                    value = c(0.25),
                    min = 0.01,
                    max = 0.5,
                    step = 0.01,
                    sep = ""
                )
            )
        ),
        br(),
        br()
    ),
    body = dashboardBody(
        useShinyjs(),

        fluidRow(
            column(
                width = 12,
                htmlOutput("info")
            ),
            column(
                width = 12,
                h2(),
                DTOutput("datatable")
            )
        )
    ),
    rightsidebar = rightSidebar(),
    footer = dashboardFooter(
     left_text = "Copyright © 2020 Fujian Key Laboratory of Crop Breeding by Design. All Rights Reserved."
    ),
)