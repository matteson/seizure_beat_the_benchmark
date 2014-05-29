prefixes = {'Dog_1/','Dog_2/','Dog_3/','Dog_4/','Patient_1/','Patient_2/','Patient_3/','Patient_4/','Patient_5/','Patient_6/','Patient_7/','Patient_8/'};
biases = [1,2,3,1,2,26,26,26,26,100,26,26];

for iter = 5:12
    
    fprintf(prefixes{iter});
    fprintf('...');
    [resultsCell{iter},earlyDeviance(iter), basicDeviance(iter)] = predict_seizure_variance(prefixes{iter});
end

%%

submissionTable = vertcat(resultsCell{:});
writetable(submissionTable);