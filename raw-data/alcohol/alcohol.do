clear
infile using alcohol.dct
reshape long ever_drank_ days_drank_last_30_ first_drank_, i(id) j(year)

by id: egen ever_drank_2 = max(ever_drank)
drop ever_drank_
rename ever_drank_2 ever_drank_
replace ever_drank = 0 if ever_drank == -1

by id: egen age_first_drank = max(first_drank_)

merge 1:1 id year using age.dta
drop if _merge == 2
drop _merge
sort id

gen a = age_int_date if days_drank_last_30_ > 0
by id: egen age_first_drank_2 = min(a)
drop a

replace age_first_drank_2 = age_first_drank if age_first_drank < age_first_drank_2 & age_first_drank > 0
replace age_first_drank_2 = 0 if age_first_drank < 0 & missing(age_first_drank_2)
drop age_first_drank
rename age_first_drank_2 age_first_drank

drop if age_int_date > 18 | age_int_date < 14

by id: egen frequency_drank = mean(days_drank_last_30_) if days_drank_last_30 >= 0
by id: egen frequency_drank_2 = max(frequency_drank)
drop frequency_drank
rename frequency_drank_2 frequency_drank

collapse ever_drank age_first_drank frequency_drank, by(id)

replace ever_drank = 1 if age_first_drank > 0
