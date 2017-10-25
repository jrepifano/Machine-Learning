prob_disease = 0.01;
prob_test_pos_given_disease = 0.9;
prob_nodisease = 0.99;
prob_test_pos_given_nodisease = 0.02;

prob_disease_give_test_pos = (prob_disease * prob_test_pos_given_disease)/(prob_disease * prob_test_pos_given_disease + prob_nodisease * prob_test_pos_given_nodisease);
disp(prob_disease_give_test_pos);