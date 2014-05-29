function [results, earlyDeviance, basicDeviance] = predict_seizure_variance(prefix)

ictalClips = dir([prefix '*_ictal*.mat']);
interIctalClips = dir([prefix '*_interictal_*.mat']);
testClips = dir([prefix '*_test_*.mat']);

mat = matfile([prefix ictalClips(1).name]);
numChannels = size(mat,'data',1);
varStore = zeros(numChannels,length(ictalClips)+length(interIctalClips));
latencyStore= zeros(1,1);%length(ictalClips)+length(interIctalClips));

for iter = 1:length(ictalClips)
    thisFile = load([prefix ictalClips(iter).name]);
    varStore(:,iter) = var(thisFile.data,[],2);
    latencyStore(iter) = thisFile.latency;
    isSeizure(iter) = true;
    isEarlySeizure(iter) = thisFile.latency<=16;
end

for iter = (1+ length(ictalClips)):(length(interIctalClips)+ length(ictalClips))
    thisFile = load([prefix interIctalClips(iter-length(ictalClips)).name]);
    varStore(:,iter) = var(thisFile.data,[],2);
    isSeizure(iter) = false;
    isEarlySeizure(iter) = false;
end

%% test

clip = cell(length(testClips),1);
testVarStore = zeros(numChannels,length(testClips));
for iter = 1:length(testClips)
    clip{iter} = testClips(iter).name;
    thisFile = load([prefix testClips(iter).name]);
    testVarStore(:,iter) = var(thisFile.data,[],2);
end

%%
rng('default');
[Bearly,FitInfoEarly] = lassoglm(varStore',isEarlySeizure','binomial','lambda',1e-3);

earlyIndx = 1; % if you change the above to use the 'CV' parameter, then this should be set to FitInfoEarly.Index1SE;

cnst = FitInfoEarly.Intercept(earlyIndx);
mdlEarly = [cnst;Bearly(:,earlyIndx)];

rng('default');
[Bbasic,FitInfoBasic] = lassoglm(varStore',isSeizure','binomial','lambda',1e-3);

basicIndx = 1; % if you change to use 'CV' set this equal to FitInfoBasic.Index1SE;

cnst = FitInfoBasic.Intercept(basicIndx);
mdlBasic = [cnst;Bbasic(:,basicIndx)];

earlyDeviance = FitInfoEarly.Deviance(earlyIndx);
basicDeviance = FitInfoBasic.Deviance(basicIndx);

%%

early   = glmval(mdlEarly,testVarStore','logit');
seizure = glmval(mdlBasic,testVarStore','logit');

results = table(clip,seizure,early);

toc
