library(shiny)
library(rootSolve)
library(DT)
library(shinyjs)

utable <- read.table("data/utable.txt", header = T, sep = "\t")
rownames(utable) <- utable[, 1]

convert_h2B_to_effect <- function(b, rd, h2B) {
  a <- sqrt(h2B / ((1 - h2B) * (2 * b + 2 * b * rd ^ 2 - 4 * b ^ 2 * rd ^ 2)))
  return(a)
}

cal_power <- function(name, t, h2, rd, p, value, k, b, ua, known) {

  a <- convert_h2B_to_effect(b, rd, h2)

  full_mode <- function(x) {
    F <- numeric(length(x))
    F[1] <- b * pnorm(x[1] - a) + (1 - 2 * b) * pnorm(x[1] - rd * a) + b * pnorm(x[1] + a) - p
    F[2] <- 1 - b * pnorm(x[2] - a) - (1 - 2 * b) * pnorm(x[2] - rd * a) - b * pnorm(x[2] + a) - p
    F
  }
  startx <- c(-1, 1)
  result <- multiroot(f = full_mode, start = startx)
  theta <- result$root
  precis <- result$estim.precis
  # estimate heritability
  xL <- theta[1]
  xH <- theta[2]

  ufH <- (2 * b * (1 - pnorm(xH - a)) + t * (1 - 2 * b) * (1 - pnorm(xH - rd * a))) / (2 * p)
  ufL <- (2 * b * pnorm(xL - a) + t * (1 - 2 * b) * pnorm(xL - rd * a)) / (2 * p)
  udeltaf <- ufH - ufL

  if (known == "pow") {
    power <- value
    #
    find_n <- function(x) {
      # x: n
      F <- numeric(length(x))
      F[1] <- 1 - pnorm(((ua / sqrt(2 ^ (t + 1) * p * x[1])) - udeltaf) / (sqrt((ufH * (1 - ufH) + ufL * (1 - ufL)) / (p * x[1] * 2 ^ t)))) - power
      F
    }
    #
    startx <- c(700)
    if (abs(find_n(50)) < 0.1) {
      startx <- c(50)
    } else if (abs(find_n(100)) < 0.2) {
      startx <- c(100)
    } else if (abs(find_n(150)) < 0.2) {
      startx <- c(150)
    } else if (abs(find_n(200)) < 0.2) {
      startx <- c(200)
    } else if (abs(find_n(300)) < 0.2) {
      startx <- c(300)
    } else if (abs(find_n(500)) < 0.2) {
      startx <- c(500)
    } else if (abs(find_n(750)) < 0.2) {
      startx <- c(750)
    } else if (abs(find_n(1000)) < 0.2) {
      startx <- c(1000)
    } else if (abs(find_n(1500)) < 0.2) {
      startx <- c(1500)
    } else if (abs(find_n(2000)) < 0.2) {
      startx <- c(2000)
    } else if (abs(find_n(2500)) < 0.2) {
      startx <- c(2500)
    } else if (abs(find_n(3000)) < 0.2) {
      startx <- c(3000)
    } else if (abs(find_n(4000)) < 0.2) {
      startx <- c(4000)
    } else if (abs(find_n(5000)) < 0.2) {
      startx <- c(5000)
    } else if (abs(find_n(6000)) < 0.2) {
      startx <- c(6000)
    } else if (abs(find_n(7000)) < 0.2) {
      startx <- c(7000)
    } else if (abs(find_n(8000)) < 0.2) {
      startx <- c(8000)
    } else if (abs(find_n(9000)) < 0.2) {
      startx <- c(9000)
    } else if (abs(find_n(10000)) < 0.2) {
      startx <- c(10000)
    } else if (abs(find_n(15000)) < 0.2) {
      startx <- c(15000)
    } else if (abs(find_n(20000)) < 0.2) {
      startx <- c(20000)
    } else if (abs(find_n(30000)) < 0.2) {
      startx <- c(30000)
    } else if (abs(find_n(40000)) < 0.2) {
      startx <- c(40000)
    } else if (abs(find_n(50000)) < 0.2) {
      startx <- c(50000)
    }
    result <- multiroot(f = find_n, start = startx, positive = TRUE, maxiter = 1000)
    theta <- result$root
    precis <- result$estim.precis
    #
    n <- theta[1]
    if (is.na(n) || n <= 0) {
      return(c(name, h2, "NA", p, power))
    } else {
      sigmadeltaf <- sqrt((ufH * (1 - ufH) + ufL * (1 - ufL)) / (p * n * 2 ^ t))
      Tthreshold <- ua / sqrt(2 ^ (t + 1) * p * n)
      statisticPower <- 1 - pnorm((Tthreshold - udeltaf) / sigmadeltaf)
      thelta <- 0.825 * sigmadeltaf / abs(udeltaf)
      ci95 <- ifelse(udeltaf - 1.65 * sigmadeltaf > 0, 50 * log((1 + 2 * thelta) / (1 - 2 * thelta)), Inf)
      #
      return(c(h2, p, as.integer(n), round(statisticPower, 3)))
    }

  } else {
    n <- value

    sigmadeltaf <- sqrt((ufH * (1 - ufH) + ufL * (1 - ufL)) / (p * n * 2 ^ t))
    Tthreshold <- ua / sqrt(2 ^ (t + 1) * p * n)
    statisticPower <- 1 - pnorm((Tthreshold - udeltaf) / sigmadeltaf)
    thelta <- 0.825 * sigmadeltaf / abs(udeltaf)
    ci95 <- ifelse(udeltaf - 1.65 * sigmadeltaf > 0, 50 * log((1 + 2 * thelta) / (1 - 2 * thelta)), Inf)

    return(c(h2, p, as.integer(n), round(statisticPower, 3)))
  }

}

server <- shinyServer(function(input, output, session) {

  t <- c()
  t1 <- reactive({
    t <- c()
    name <- input$popType
    ta <- ifelse((name == "F2" || name == "F3" || name == "F4"), 1, 0)
    h2a_min <- input$h2a[1]
    h2a_max <- input$h2a[2]
    h2a <- seq(h2a_min, h2a_max, 0.01)
    #
    rda <- input$rda[1]
    #
    pa <- input$pa[1]
    #
    known <- input$known
    value <- input$knownValue
    #
    ka <- switch(
            name,
            "F2" = 2,
            "F3" = 3,
            "F4" = 4,
            9999
        )
    ka <- as.integer(ka)
    ba <- (1 - 0.5 ^ (ka - 1)) / 2
    species <- input$uaa
    if (species == "Other") {
      k <- ka
      chrNum <- as.integer(input$nChr)
      if (input$knownG == "cM") {
        geneticLength <- as.numeric(input$GsizecM)
      } else {
        genomeSize <- as.numeric(input$GsizeMb)
        ratio <- as.numeric(input$ratio)
        geneticLength <- genomeSize / ratio
      }
      r_root <- 0.084
      cm_root <- 8.4
      if (name == "RIL") {
        r_root <- 0.0459
        cm_root <- 4.5
      } else if (k == 1 | k == 2 | k == 0 | k > 4) {
        r_root <- 0.084
        cm_root <- 8.4
      } else if (k == 3) {
        r_root <- 0.0582
        cm_root <- 5.8
      } else if (k == 4) {
        r_root <- 0.0508
        cm_root <- 5.0
      }
      a5 <- 0.05 / (chrNum + geneticLength / cm_root)
      uaa <- round(abs(qnorm(a5 / 2)), digits = 6)
    } else {
      uaa <- utable[species, name]

    }

    for (ni in 1:length(value)) {
      for (h2i in 1:length(h2a)) {
        for (rdi in 1:length(rda)) {
          for (pidx in 1:length(pa)) {
            for (ki in 1:length(ka)) {
              tmp <- cal_power(name[ki], ta[ki], h2a[h2i], rda[rdi], pa[pidx], value[ni], ka[ki], ba[ki], uaa[ki], known)
              t <- rbind(t, tmp)
            }
          }
        }
      }
    }
    colnames(t) <- c("Heritability", "Pool proportion", "Population Size", "Power")
    rownames(t) <- c(1:nrow(t))
    t
  })
  #
  output$datatable <- renderDT({
    datatable({ t1() }, filter = "top", rownames = FALSE,
                options = list(
                    columnDefs = list(list(className = 'dt-center', targets = 0:3)),
                    lengthMenu = c(10, 15, 20)
                ))
  })
  #
  output$info <- renderUI({
    t <- input$popType
    if (t == "F2") {
      p <- tags$span("F", tags$sub("2", .noWS = c("outside")), .noWS = c("inside"))
    } else if (t == "F3") {
      p <- tags$span("F", tags$sub("3", .noWS = c("outside")), .noWS = c("inside"))
    } else if (t == "F4") {
      p <- tags$span("F", tags$sub("4", .noWS = c("outside")), .noWS = c("inside"))
    } else if (t == "H") {
      p <- "H/DH"
    } else {
      p <- t
    }
    tags$h2("Population: ", p, .noWS = c("inside"))
  })

  observeEvent(input$known, {
    k <- input$known
    if (k == "popsize") {
      updateNumericInput(session, "knownValue",
                                label = "Population Size",
                                value = c(1000),
                                min = 100,
                                max = 5000,
                                step = 1
            )
      # drag to jump ,press arrow left or right to change value by 1, long press to fine tune
    } else {
      updateNumericInput(session, "knownValue",
                                label = "Power",
                                value = c(0.9),
                                min = 0.6,
                                max = 1,
                                step = 0.01
            )
    }
  })

  observeEvent(input$knownG, {
    if (input$knownG == "cM") {
      show("selcm")
      hide("selmb")
    } else {
      show("selmb")
      hide("selcm")
    }
  })
  observeEvent(input$uaa, {
    if (input$uaa == "Other") {
      show("others")
    } else {
      hide("others")
    }
    if (input$uaa == "Yeast") {
      updateRadioButtons(session, "popType",
                choiceNames = c("H/DH"),
                choiceValues = c("H"),
                selected = c("H"),
                inline = T
            )
    } else {
      updateRadioButtons(session, "popType",
                choiceNames = list("RIL", "H/DH", tags$span("F", tags$sub("2", .noWS = c("outside")), .noWS = c("inside")), tags$span("F", tags$sub("3", .noWS = c("outside")), .noWS = c("inside")), tags$span("F", tags$sub("4", .noWS = c("outside")), .noWS = c("inside"))),
                choiceValues = c("RIL", "H", "F2", "F3", "F4"),
                selected = c("F2"),
                inline = T
            )
    }
  })
})