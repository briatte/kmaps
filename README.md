## Description

Maps for European country-level data.

- The `code.r` file is what you probably want to have a look at.
- The `note` folder holds a Sweave file with code and comments.

## Data

- The `eco` dataset contains estimated cancer incidence and mortality for 30 European countries in 2008; source: [European Cancer Observatory][1].
- The `maps` folder contains shapefiles produced by EuroGeographics; source: [European Commission][2].

[1]: http://eu-cancer.iarc.fr/
[2]: http://epp.eurostat.ec.europa.eu/portal/page/portal/gisco/popups/references/administrative_units_statistical_units_1

## Codebook

Country dummies:

	is_eu15		EU-15 membership
	is_eu27		EU-27 membership

Raw figures:

	in_*		Incidence
	mn_*		Mortality

Age-standardized rates:

	ir_*		Incidence rate, per 100,000
	mr_*		Mortality rate, per 100,000

Suffixes for gender group:

	*_m			Males
	*_f			Females
	(empty)		Both sexes
	
Tumor sites:

	all			All cancers but non-skin melanoma
	breast		ICD-10 classification
	colorectal	ICD-10 classification
	lung		ICD-10 classification
	prostate	ICD-10 classification

> Last revision: 2012-03-13