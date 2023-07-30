clear

infile using household_income.dct
reshape long hh_income_, i(id) j(year)

merge id year using age.dta
drop _merge

drop sex
drop bday_m
drop bday_y
drop sample_type
drop race

sort id
by id: egen hh_income_avg =  mean(hh_income) if age_int_date_ <= 18 & hh_income > 0
by id: egen hh_income_avg_2 = max(hh_income_avg)

drop hh_income_avg
rename hh_income_avg_2 hh_income_avg

collapse hh_income_avg, by(id)
