clear;
brainMatrixCohort = Cohort;
brainMatrixCohort.loadCohortMembersFromFile('CONN_UOC\Dem_clin_MS_HV.csv');

brainMatrixCohort.analizeCohort();
brainMatrixCohort.evaluateCohort();
brainMatrixCohort.showAnalysisResults();
% brainMatrixCohort.showPlots();

featuresMatrixFA  = getFeaturesMatrix(brainMatrixCohort, 'FAMatrix');
featuresMatrixSC  = getFeaturesMatrix(brainMatrixCohort, 'SCMatrix');

saveDataToCsv(featuresMatrixFA, 0, 'FAMatrixSignificantData');
saveDataToCsv(featuresMatrixSC, 0, 'SCMatrixSignificantData');

globalfeaturesMatrixFA = getGlobalSignificantFeaturesMatrix(brainMatrixCohort, 'FAMatrix');
globalfeaturesMatrixSC = getGlobalSignificantFeaturesMatrix(brainMatrixCohort, 'SCMatrix');

saveDataToCsv(globalfeaturesMatrixFA, 0, 'globalFAMatrixSignificantData');
saveDataToCsv(globalfeaturesMatrixSC, 0, 'globalSCMatrixSignificantData');