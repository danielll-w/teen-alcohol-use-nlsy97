# Effect of Teen Alcohol Use on Academics

## Introduction

This project has code and a report analyzing the effect of teen alcohol use on academics using the NLSY97 dataset and 
econometrics tools like fixed effects regressions. It is a very messy independent project left over from a college 
econometrics class. That being said the source files have Stata code that does some common things like reading in and 
merging data use a .dct file, cleaning it, shifting it from wide to long, etc. There are also Stata esttab and esttout 
calls that create beautified tables in a TeX format and TeX source files that create a manuscript. 

## Usage

This repo is really meant more to store some sample Stata code that could be useful and show off some econometrics
I did. 

### Raw Data

For some reason, I got the raw data in chunks relating to different variable categories like teen alcohol use. So,
one would have to use the [Investigator](https://www.nlsinfo.org/investigator/pages/login) tool on the website with the
NLSY data. Download a category like "Alcohol" under substance use and make sure it also comes with a .dct file.
Otherwise, the raw data is going to have a bunch of column names that are just numbers that you will not understand.
You also do not want to have to change these by hand. 

### Analysis

The analysis part needs the raw .dta files moved from the raw-data directory into the analysis subdirectories.
Apparently a few years ago, I was not interested in using relative paths. 

## Author
- Dan Weiss (Written 2020, Reorganized 2023)
