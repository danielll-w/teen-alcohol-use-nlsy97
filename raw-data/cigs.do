clear all
infile using cigs.dct
drop f
drop g
reshape long ever_cig_ first_cig_ cigs_last_30_ cigs_pd_last_30_ cig_sdli_, i(id) j(year)

by id: egen ever_cig_2 = max(ever_cig)
replace ever_cig_2 = 0 if ever_cig_2 == -1

drop ever_cig_
rename ever_cig_2 ever_cig

by id: egen first_cig_2 = max(first_cig_)
drop first_cig_
rename first_cig_2 first_cig

merge 1:1 id year using age.dta
drop if _merge == 2
drop _merge
sort id

gen age_smoked = age_int_date if cig_sdli_ == 1
by id: egen age_smoked_2 = min(age_smoked)
drop age_smoked
rename age_smoked_2 age_smoked

replace age_smoked = first_cig if first_cig < age_smoked & first_cig > 0
replace age_smoked = 0 if first_cig < 0 & missing(age_smoked)

collapse age_smoked ever_cig , by(id)
replace ever_cig = 1 if age_smoked > 0
