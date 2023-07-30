clear
infile using gpa.dct
reshape long gpa_, i(id) j(year)

merge 1:1 id year using age.dta
drop if _merge == 2
drop _merge

drop bday_m
drop bday_y
drop sample_type
drop race
drop sex

sort id

by id: egen mean_gpa = mean(gpa) if gpa > 0
by id: egen mean_gpa_2 = max(mean_gpa)
drop mean_gpa
rename mean_gpa_2 mean_gpa
collapse mean_gpa, by(id)

merge 1:1 id year using alcohol.dta
drop if _merge == 2
drop _merge

drop first_drank
drop ever_drank

drop if year < 1997
drop if gpa_ == -6 | gpa == -4 | gpa == -7 | gpa == -8 | gpa == -9

replace days_drank_last_30_ = 0 if days_drank_last_30 == -4 | days_drank_last_30_ == -5 | days_drank_last_30_ == -2 | days_drank_last_30_ == -1

drop if age_int_date_ > 18 | age_int_date < 14

recode days_drank_last_30_ (0=0) (1/6=1) (7/21=2) (21/30=3)

xtset id year
xtreg gpa days_drank_last_30_ i.year, fe

eststo
esttab using test.tex, title(Test Table\label{tab1})
