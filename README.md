# Description

The `kmaps.Rnw` file produces a demo of the results. To extract the R code:

    require(knitr)
    purl("kmaps.Rnw")

The code was upgraded to reflect changes to the `ggplot2`, `knitr` and `rgeos` packages.

# Data sources

Estimates of cancer mortality were retrieved from the [European Cancer Observatory][eco] (WHO-IARC) and from Eurostat (European Commission). Both use age-standardized rates for the WHO European population and ICD codes for [causes of death][cod].

Shapefiles for geographical regions were retrieved from [GISCO - Eurostat][gisco] (European Commission). The maps provide worldwide coverage but I focus on Europe to include [NUTS-2 level][reg] regional data.

[eco]: http://eu-cancer.iarc.fr/
[gisco]: http://epp.eurostat.ec.europa.eu/portal/page/portal/gisco_Geographical_information_maps/popups/references/administrative_units_statistical_units_1
[cod]: http://epp.eurostat.ec.europa.eu/statistics_explained/index.php/Causes_of_death_statistics
[reg]: http://epp.eurostat.ec.europa.eu/statistics_explained/index.php/Causes_of_death_statistics_at_regional_level

# Codebook

Country dummies:

	is_eu15		EU-15 membership (1995)
	is_eu27		EU-27 membership (2007)

Raw figures (“N”):

	in_*		Incidence
	mn_*		Mortality

Age-standardized rates:

	ir_*		Incidence rate, per 100,000 European population
	mr_*		Mortality rate, per 100,000 European population
	
Suffixes for gender group:

	*_m			Males
	*_f			Females
	(empty)		Both sexes

Tumor sites:

	all			All cancers but non-skin melanoma
	breast		Breast cancer, ICD-10 classification
	colorectal	Colorectal cancer, ICD-10 classification
	lung		Lung cancer, ICD-10 classification
	prostate	Prostate cancer, ICD-10 classification

__Note:__ please refer to the data source for a precise list of tumor sites.

> First release: March 2012.  
> Last revision: January 2013.
