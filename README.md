## Description

Maps for European country-level data.

- `code.r` is what you probably want to have a look at.
- `code.Rnw` is a companion document for the code.

## Data

- `data/iarc.eco.2008.csv` contains estimates of cancer incidence and mortality for 30 European countries in 2008; source: [European Cancer Observatory][3].
- `maps/` contains shapefiles produced by EuroGeographics in 2006; source: [European Commission][4].

[3]: http://eu-cancer.iarc.fr/
[4]: http://epp.eurostat.ec.europa.eu/portal/page/portal/gisco/popups/references/administrative_units_statistical_units_1

## Codebook

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
	lung		Lung cancer, classification
	prostate	Prostate cancer, classification

**Note:** refer to the data source for a precise list of tumor sites.

> Last revision: 2012-03-17