seizure_beat_the_benchmark
==========================

Files to beat the benchmark for the Kaggle contest http://www.kaggle.com/c/seizure-detection/

Unpack the files predict_seizure_variance.m and runPredict.m into the "clips" folder of the competition data. 

>> runPredict

will put together a basic model based on variance of the signal from each electorde. Get's about a .772 on the public leaderboard. The output is written to submissionTable.txt within the clips folder.

===========================
Algorithm calculates the variance of each electorde's signal. The model then uses the lassoglm function to perform logistic regression.

