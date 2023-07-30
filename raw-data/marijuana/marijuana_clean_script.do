clear all
set more off

infile using marijuana_use.dct
reshape long smoked_sdli_ first_smoked_ ever_use_mj_ days_smoked_last_30_, i(id) j(year)

*Insert age data and get rid of unmatched observations with master
merge 1:1 id year using age.dta
drop if _merge == 2
drop _merge

*store age smoker was if they answered yes to smoking sdli
gen age_smoked_sdli = age_int_date_ if smoked_sdli_ > 0 & !missing(smoked_sdli_)
gen days_smoked_sdli = days_smoked_last_30_ if days_smoked_last_30_ >= 0 & !missing(days_smoked_last_30_)

*have to resort id for some reason
sort id

*Take the max of the ever_use_mj variable, drop the original, and rename
by id: egen ever_use_mj_max = max(ever_use_mj_)
drop ever_use_mj_
rename ever_use_mj_max ever_use_mj_

*Deal with id 319 who apparently answered refused every time
replace ever_use_mj_ = 0 if ever_use_mj_ == -1 

*Store max of first_smoked and rename
by id: egen first_smoked_max = max(first_smoked_)
drop first_smoked_
rename first_smoked_max first_smoked_
replace first_smoked_ = -4 if first_smoked < 0

*Create new variable for age first smoked
by id: egen first_smoked_2 = min(age_smoked_sdli)
replace first_smoked_  = 9999 if first_smoked_ < 0
replace first_smoked_2 = min(first_smoked_, first_smoked_2)
replace first_smoked_2 = 0 if first_smoked_2 == 9999
replace ever_use_mj_ = 1 if first_smoked_2 > 0

drop first_smoked_
drop age_smoked_sdli
drop smoked_sdli_
rename first_smoked_2 first_smoked_mj

*Get frequency of smoker in high school
by id: egen smoker_frequency = max(days_smoked_sdli) if age_int_date_ <= 18 & age_int_date > 0
by id: egen smoker_frequency_2 = max(smoker_frequency)
drop smoker_frequency
rename smoker_frequency_2 smoker_frequency
replace smoker_frequency = -1 if missing(smoker_frequency)
replace smoker_frequency = 0 if ever_use_mj_ == 1 & smoker_frequency == -1


collapse first_smoked_ ever_use_mj smoker_frequency, by(id)


gen smoker_frequency_2 = smoker_frequency
recode smoker_frequency_2 (-1=0) (0/6=1) (7/13=2) (14/30=3)
drop smoker_frequency
rename smoker_frequency_2 mj_frequency
