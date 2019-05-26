clear;
brainMatrixCohort = Cohort;
brainMatrixCohort.loadCohortMembersFromFile('CONN_UOC\Dem_clin_MS_HV.csv');

brainMatrixCohort.analizeCohort();
brainMatrixCohort.evaluateCohort();
brainMatrixCohort.showAnalysisResults();
% brainMatrixCohort.showPlots();

featuresMatrix  = getFeaturesMatrix(brainMatrixCohort);
saveDataToCsv(featuresMatrix, 0, 'BrainMatrixData');