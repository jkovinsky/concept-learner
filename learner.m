% concept learning for the number game
clear all; 

% define hypothesis space
% type 1: Mathematical properties (24 hypotheses): 
% Odd, even, square, cube, prime numbers
h{1} = 1:2:99; 
h{2} = 2:2:100;
h{3} = (1:10).^2;
h{4} = (1:4).^3;
h{5} = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97];

% Multiples of small integers,1,2,3,4,5,6,7,8,9,10
h{6} = 1:100;
h{7} = 2*[1:50];
h{8} = 3*[1:floor(100/3)]; 
h{9} = 4*[1:floor(100/4)]; 
h{10} = 5*[1:floor(100/5)]; 
h{11} = 6*[1:floor(100/6)]; 
h{12} = 7*[1:floor(100/7)]; 
h{13} = 8*[1:floor(100/8)]; 
h{14} = 9*[1:floor(100/9)]; 
h{15} = 10*[1:floor(100/10)]; 

% Powers of small integers,2,3,4,5,6,7,8,9,10 
h{16} = 2.^[1:6]; 
h{17} = 3.^[1:4]; 
h{18} = 4.^[1:3]; 
h{19} = 5.^[1:2]; 
h{20} = 6.^[1:2]; 
h{21} = 7.^[1:2]; 
h{22} = 8.^[1:2]; 
h{23} = 9.^[1:2]; 
h{24} = 10.^[1:2]; 

% Type 2: Raw magnitude (5050 hypotheses): 
% All intervals of integers with endpoints between 1 and 100.
hcount = 24;
for i=1:100
    for j = i:100
        hcount= hcount+1;
        h{hcount} = [i:j];
    end;
end;

% Type 3: Approximate magnitude (10 hypotheses):
% Decades (1-10, 10-20, 20-30, …)
h{5075} = [1:10];
h{5076} = [10:20];
h{5077} = [20:30];
h{5078} = [30:40];
h{5079} = [40:50];
h{5080} = [50:60];
h{5081} = [60:70];
h{5082} = [70:80];
h{5083} = [80:90];
h{5084} = [90:100];


% input three learning trials

% compute prior probability for each h

% Part a and Part b

trials = {64, [8, 2, 16, 64], [48, 64, 60, 72, 66]};

c = 1/3;
mathProp_prior = c/24; % mathematical property
rawMag_prior = c/5050; % raw magnitude
approxMag_prior = c/10; % approximate magnitude


likelihood = zeros(length(h), length(trials));

% compute likelihoods for each trial given a hypothesis 
for i = 1:length(trials)

    % mathematical properties likelihood
    for j = 1:24

        if sum(ismember(trials{i}, h{j})) == length(trials{i})
            likelihood(j, i) = (1/length(h{j}))^length(trials{i});
        else
            likelihood(j, i) = 0; 
        end
    end

    % raw magnitude properties likelihood
    for k = 25:5074

        if sum(ismember(trials{i}, h{k})) == length(trials{i})
            likelihood(k, i) = (1/length(h{k}))^length(trials{i});
        else
            likelihood(k, i) = 0;
        end

    end

    % approximate magnitude likelihood
    for l  = 5075:5084

        if sum(ismember(trials{i}, h{l})) == length(trials{i})
            likelihood(l, i) = (1/length(h{l}))^length(trials{i});
        else
            likelihood(l, i) = 0;
        end

    end

end

% compute posteriors for each trial given a hypothesis
posterior = zeros(length(h), length(trials));

for i = 1:length(trials)

    % marginalization constant for each trial
    marg_const = sum(likelihood(1:24, i).*mathProp_prior) + sum(likelihood(25:5074, i).*rawMag_prior) + sum(likelihood(5075:5084, i).*approxMag_prior);

    % mathematical properties posterior
    for j = 1:24
        posterior(j, i) = (likelihood(j, i)*mathProp_prior)/marg_const; 
    end

    % raw magnitude posterior
    for k = 25:5074
        posterior(k, i) = (likelihood(k, i)*rawMag_prior)/marg_const; 
    end

    % approximate magnitude posterior
    for l  = 5075:5084
        posterior(l, i) = (likelihood(l, i)*approxMag_prior)/marg_const; 
    end

end

% bar graph of the top 20 hypotheses with highest posterior probability
[sort_trial1, pos_trial1] = (sort(posterior(:,1), 'descend'));
Max20_trial1 = sort_trial1(1:20);

figure('Name', 'Trial 1: [64]'); 
bar(Max20_trial1);
xticks(1:numel(Max20_trial1));
xticklabels({num2str(pos_trial1(1:20))});
ylabel('Posterior Probability');
xlabel('Hypothesis');

[sort_trial2, pos_trial2] = (sort(posterior(:,2), 'descend')); 
Max20_trial2 = sort_trial2(1:20); 

figure('Name', 'Trial 2: [8, 2, 16, 64]');
bar(Max20_trial2);
xticks(1:numel(Max20_trial2));
xticklabels({num2str(pos_trial2(1:20))});
ylabel('Posterior Probability');
xlabel('Hypothesis');

[sort_trial3, pos_trial3] = (sort(posterior(:,3), 'descend')); 
Max20_trial3 = sort_trial3(1:20);

figure('Name', 'Trial 3: [48, 64, 60, 72, 66]');
bar(Max20_trial3);
xticks(1:numel(Max20_trial3));
xticklabels({num2str(pos_trial3(1:20))});
ylabel('Posterior Probability');
xlabel('Hypothesis');

% Generalizing to new objects

y = 1:100; % test examples

hypo_avg = zeros(100, length(trials));

% hypothesis averaging
for i = 1:length(trials)
    for j = 1:length(y)
        for k = 1:length(h)
            hypo_avg(j, i) = hypo_avg(j, i) + ismember(y(j), h{k})*posterior(k, i);
        end
    end
end

figure('Name', 'Trial 1 Generalization: [64]');
bar(hypo_avg(:,1));
ylim([0, 1]);
xlabel('Number');
ylabel('Probability C');

figure('Name', 'Trial 2 Generalization: [8, 2, 16, 64]');
bar(hypo_avg(:,2));
ylim([0, 1]);
xlabel('Number');
ylabel('Probability C');

figure('Name', 'Trial 3 Generalization: [48, 64, 60, 72, 66]');
bar(hypo_avg(:,3));
ylim([0, 1]);
xlabel('Number');
ylabel('Probability C');
