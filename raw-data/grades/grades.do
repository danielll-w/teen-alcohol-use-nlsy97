clear
infile using grades.dct
gen SAT_score = mean(SAT_math, SAT_verbal)

drop SAT_math
drop SAT_verbal
