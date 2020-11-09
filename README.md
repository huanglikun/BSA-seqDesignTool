# BSA-seqDesignTool
**BSA-seq Design Tool (BDT)** is an R program to facilitate the design of a suitable experiment for BSA-seq.

## Content

* [R packages required for BDT](#dep)
    * [To install the required R packages](#install)
* [To start BDT](#start)
* [To quit BDT](#quit)
* [Sidebar parameters required](#req)
    * [BSA-seq design in given species](#given)
        * [Setting of parameters](#par)
    * [BSA-seq design in other species](#other)
* [Tip](#tips)

## <a name="dep"></a>R packages required for BDT

* shiny
* shinydashboard
* shinydashboardPlus
* shinyBS
* shinyjs
* DT
* rootSolve

<a name="install"></a>**To install the required R packages**
```R
install.packages(c("shiny","shinydashboard","shinydashboardPlus","shinyBS","shinyjs","DT","rootSolve"))
```

## <a name="start"></a>To start BDT

```
library("shiny")
runGitHub("BSA-seqDesignTool","huanglikun","main")
```

## <a name="quit"></a>To quit BDT

Press CTRL+C in **terminal** or ESC in **R console**.

## <a name="req"></a>Sidebar parameters required

### <a name="given"></a>BSA-seq design in given species

**Given species:**
* *Arabidopsis*
* Cucumber
* Maize
* Rapeseed
* Rice
* Tobacco
* Tomato
* Wheat
* Yeast

<a name="par"></a>**Setting of parameters:**
1. The parameters need to be set include population type, power or population size, QTL heritability, degree of dominance of the QTL, and pool proportion.
2. Parameter setting can be done by clicking the radio buttons or dragging the slider widgets.
3. Among the population types, **RIL** indicates recombinant inbred lines; **H/DH** indicates haploid (H) or doubled haploid (DH). All populations are derived from a cross between two pure-line parents (P<sub>1</sub> and P<sub>2</sub>).
4. The results will be updated immediately after the values of the parameters are changed.

### <a name="other"></a>BSA-seq design in other species

Selection of the "Other" option in "Species" will need the information of gametal chromosome number and genome size (either in cM or in Mb). When the genome size is given in Mb, the information of physical distance in kb per cM is required.

## <a name="tips"></a>Tip
**Fine tune for the slider widget**: Press left arrow or right arrow while select the slider widget with mouse.
