# number-game
This script reproduces a portion of Joshua Tenenbaum's [PhD thesis](https://dspace.mit.edu/handle/1721.1/16714), which illustrates some fundamental ideas about Bayesian concept learning.

**Motivation**:  The basic setup is as follows: I give you a set of numbers from 1 to 100, and you try to guess another number in the set. For example, I give you the numbers {4,8,64,2}. Intuitively, you might say another number in the set is 16, because that's consistent with the concept that the set contains powers of 2. It could also be the case this example set contains only even numbers. Hence, predicting 24 or 92 would also be reasonable. We could also say the next number is 43, because the full underlying set is {4,8,64,2,43,57}, which could represent 6 uniform random draws from the range 1 to 100. How can we say with complete confidence what the next number in the set will be?

**Experiment:**
- The `learner.m` file contains the entire hypothesis space. This space includes 24 hypotheses for mathematical properties, 5050 hypthoses for raw magnitude range, and 10 hypotheses for approximate magnitude. Each type of hypothesis is assigned with 1/3 prior probability.
<p align="center">
  <img src="https://github.com/jkovinsky/number-game/assets/108347901/c5fde537-e1ac-4857-97b5-7da73d9ba2ce">
</p>

- There are only three learning trials providing the numbers that are positive examples of a concept. A further set of numbers will then be judged as to whether they belong to the learned concept or not.
- The model will first learn the concept from the training data, and then perform the generalization task by predicting the probability that a particular number instantiates the same concept as the positive examples.
- Here are three training trials used during the model implementation:
  - Trial 1: [64]
  - Trial 2: [8, 2, 16, 64]
  - Trial 3: [48, 64, 60, 72, 66]

**Script Format**
- Part I: For each learning trial, the likelihood is computed using the size principle.
<p align="center">
    <img src="https://github.com/jkovinsky/number-game/assets/108347901/7b3a231c-e8e9-4fa2-b95e-4eb0206c722e" alt="Screenshot">
</p>

- Part II: For each learning trial, the script computes the posterior probability distribution and then plots the top 20 hypotheses with the highest probability distribution.
- Part III: After learning the concept from the positive exemplars, the model makes generalization judgements for new numbers. The model uses hypothesis averaging to make the generalization judgement by computing the probability that each number between 1 and 100 instantiates the same concept as the positive examples provided in each trial. A bar graph is displayed to show the generalization judgements for each trial.
<p align="center">
  <img src="https://github.com/jkovinsky/number-game/assets/108347901/c2182836-ab4e-45ea-a5bd-88ac888d752d"
alt="Screenshot">
</p>
