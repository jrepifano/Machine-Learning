prob_goat_given_picked_door = 1/2;
prob_car_picked_door = 1/3;
sum_doors = 1/2 *1/3 + 1/3;

prob_car_picked_door = (prob_goat_given_picked_door * prob_car_picked_door)/sum_doors;
prob_car_switched_door = 1 - prob_car_picked_door;

disp(prob_car_picked_door);
disp(prob_car_switched_door);
