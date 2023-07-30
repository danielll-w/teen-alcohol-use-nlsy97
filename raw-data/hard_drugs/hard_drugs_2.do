clear
infile using hard_drugs_2.dct
reshape long times_hard_sdli_ hard_sdli_, i(id) j(year)

merge 1:1 id year using age.dta
drop if _merge == 2
drop _merge
sort id

replace ever_hard = 0 if ever_hard == -5 | ever_hard == -2 | ever_hard == -1

by id: egen first_hard_2 = max(first_hard)
drop first_hard
rename first_hard_2 first_hard

gen first_hard_2 = age_int_date if hard_sdli_ == 1
by id: egen first_hard_3 = min(first_hard_2)
drop first_hard_2
rename first_hard_3 age_first_hard

replace age_first_hard = first_hard if first_hard < age_first_hard & first_hard > 0
replace age_first_hard = 0 if first_hard < 0 & missing(age_first_hard)
drop first_hard

collapse age_first_hard ever_hard, by(id)
replace ever_hard = 1 if age_first_hard > 0
