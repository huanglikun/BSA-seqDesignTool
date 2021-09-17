# BSA-seqDesignTool
**BSA-seq Design Tool** is a helper for designing a suitable experiment for BSA-seq.

## Content

* [Introduction](#intro)
* [Dependencies](#dep)
* [Getting started](#start)
* [Sidebar parameters explanation](#exp)
    * [BSA-seq Design in known species](#known)
    * [BSA-seq Design in other species](#other)
* [Tips](#tips)


## <a name="intro"></a>Introduction

## <a name="dep"></a>Dependencies

* R(^4.1.0)
* shiny(^1.5.0)
* shinydashboard(~0.7.1)
* shinydashboardPlus(~0.7.5)
* shinyBS
* shinyjs
* DT
* rootSolve

Note: The caret (^) means accept MINOR releases, and the tilde (~) means accept PATCH releases. For example, shiny(^1.5.0) means our tool depends shiny version 1.x.x up to 1.5.0, and shinydashboardPlus(~0.7.5) means our tool depends shinydashboardPlus version 0.7.x up to 0.7.5.

**Install packages at a time**
```R
install.packages(c("shiny","shinydashboard","shinyBS","shinyjs","DT","rootSolve"))
packageurl <- "https://cran.r-project.org/src/contrib/Archive/shinydashboardPlus/shinydashboardPlus_0.7.5.tar.gz"
install.packages(packageurl, repos=NULL, type="source")
```

## <a name="start"></a>Getting started

```
library("shiny")
runGitHub("BSA-seqDesignTool","huanglikun","main")
```

Press CTRL+C in **terminal** or ESC in **R console** to exit the APP.

## <a name="exp"></a>Sidebar parameters explanation

### <a name="known"></a>BSA-seq Design in known species

**Known species:**
* *Arabidopsis*
* Cucumber
* Maize
* Rapeseed
* Rice
* Tobacco
* Tomato
* Wheat
* Yeast

**Steps:**
1. Select the species.
2. Select the population type. The **RIL** represent the "recombinant inbred lines", **H/DH** means "haploid(H) or doubled haploid(DH)", while **F<sub>2</sub>**, **F<sub>3</sub>**, **F<sub>4</sub>** are F<sub>k</sub> derived from a cross between two pure-line parents (*P*<sub>1</sub> and *P*<sub>2</sub>).
3. Choose the given parameter (power or population size), then point or drag the sliding button to determine the value of the corresponding parameter.
4. Setting the rest of the parameters, the results will be updated immediately after change the parameters.

### <a name="other"></a>BSA-seq Design in other species

Select the "Other" option in "Species" will need further information, such as "Gametal chromosome number" in species, "Genome size information". Fill in each input box, the result table will also be updated quickly.

## <a name="tips"></a>Tips
1. **Fine tune**: press left arrow or right arrow for step by step fine tune.
2. **Normal tune**: long press left arrow or right arrow.

## <a name="qa"></a>Q&A
1. Q: What can I do if I get an error during installation or running the APP?

    A: When you find anything wrong, please make sure that the version of shinydashboardPlus is below 0.7.5. Or, maybe changing another CRAN mirror will be fine.
