## Description

- `code.r` produces maps of European country-level data.
- `code.Rnw` produces a demo of the results.

A longer description of the code is provided in its [blog entry][maps].

[maps]: http://phnk.com/notes/maps/

## Data sources

- Estimates of cancer mortality were retrieved from the [European Cancer Observatory][eco].
- Shapefiles for geographical regions were retrieved from [GISCO - Eurostat][gisco] at the European Commission.

[eco]: http://eu-cancer.iarc.fr/
[gisco]: http://epp.eurostat.ec.europa.eu/portal/page/portal/gisco/popups/references/administrative_units_statistical_units_1

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