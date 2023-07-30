clear
infile using parent_education.dct
gen parent_ed = max(dad_ed,mom_ed)
replace parent_ed = 0 if parent_ed == 95
replace parent_ed = 0 if parent_ed < 0
