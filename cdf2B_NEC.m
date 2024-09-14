function B_NEC = cdf2B_NEC(MAGA_LR_1B_filename)
data = cdfread(MAGA_LR_1B_filename);
B_NEC = data(:,12);
