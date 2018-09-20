%% Header

% Mike Giuliano
% Jacob Epifano

%% 1.0 Kalman Filter Zero Acceleration

clc; clear all; close all;

runs = 500;                                 % Monte Carlo run
dt = 2;                                     % Sample time
t = 0:dt:50;
H = [1 0];
G = [dt^2/2;dt];                            % Acceleration factor
Rtrue = 1000;                       
Wtrue = 9;
R = 0.94*Rtrue;                             % Filter measurement variance
W = 0.9*Wtrue;                              % Filter model error
phi = [1 dt;0 1];                           % Transition matrix
P = [1 1/dt;1/dt 2/(dt^2)]*R;               % State covariance (initial)                                    
Q = [(1/4)*(dt^4) (1/2)*(dt^3);(1/2)*(dt^3) dt^2]*W;	% DWNA noise

% Position arrays for plotting
runErrorPos = zeros(1,runs);
graphErrorPos = zeros(1,length(t));
runstdPos = zeros(runs,length(t));
graphstdPos = zeros(1,length(t));

% Velocity arrays for plotting
runErrorVel = zeros(1,runs);
graphErrorVel = zeros(1,length(t));
runstdVel = zeros(runs,length(t)); 
graphstdVel = zeros(1,length(t));

for i = 1:runs
    
   a = (mvnrnd(0,sqrt(9),length(t)))';      % Generate samples
   p = 0;                                   % Set initial conditions
   v = 10;
   prior = [p;v];                           % Set initial prior assumption
   post = [];
   error = [];
   state = [p;v];
   
   % ADD IN ACCELERATION TO KINEMATICS
   for k = 2:length(t)
     state(:,k) = phi*state(:,k-1)+G*a(k);	% Kinematics
   end
   
   r =(mvnrnd(0,Rtrue,length(t)))';         % mean=0, variance=sqrt(1000)
   
   for k = 1:length(t)
      meas(k) =  H*state(:,k)+r(k);         % Add noise to true
   end
   
   for k = 1:length(t)
       prior = phi*prior;                   % Calc next step prior
       res = meas(k)-H*prior;               % Calc residual
       P = phi*P*phi'+Q;                    % Calc prior cov
       K = P*H'*((H*P*H'+R)^-1);            % Calc gains
       P = (eye(2)-K*H)*P*(eye(2)-K*H)'+K*R*K';     % Calc post cov
       stdPos(i,k) = 3 * sqrt(P(1,1));      % Store position covariance
       stdVel(i,k) = 3 * sqrt(P(2,2));      % Store velocity covariance
       tempvar = prior+K*res;               % Calc post prediction
       post(:,k) = tempvar;                 % Store var
       prior = post(:,k);                   % Reset prior to be post
       error(:,k) = state(:,k)-post(:,k);	% Calc error vs true
   end
   
   % Position mean error algorithm
   runErrorPos(1,i) = mean(error(1,:));
   if (i == runs)
       meanErrorPos = mean(runErrorPos);
       for k = 1:length(t)
           graphErrorPos(1,k) = meanErrorPos;
       end
   end
   
	% Position standard deviation algorithm
    runstdPos(i,:) = error(1,:);
    if (i == runs)
        for k = 1:length(t)
            graphstdPos(1,k) = 3*std(runstdPos(:,k));
        end
    end
   
   % Velocity mean error algorithm
   runErrorVel(1,i) = mean(error(2,:));
   if (i == runs)
       meanErrorVel = mean(runErrorVel);
       for k = 1:length(t)
           graphErrorVel(1,k) = meanErrorVel;
       end
   end
   
   	% Velocity standard deviation algorithm
    runstdVel(i,:) = error(2,:);
    if (i == runs)
        for k = 1:length(t)
            graphstdVel(1,k) = 3*std(runstdVel(:,k));
        end
    end
   
   % Plot each position run
   figure(1)
   subplot(2,1,1)
   hold on;
   plot(t, error(1,:), 'blue');
   
   % Plot each velocity run
   subplot(2,1,2)
   hold on;
   plot(t, error(2,:), 'blue');
   
end

% Create lower bound of standard deviation
invstdPos = -1 * graphstdPos;
invstdVel = -1 * graphstdVel;

% Display mean error values
fprintf('The mean position error for 0 mean accel is: %f \n',meanErrorPos);
fprintf('The mean velocity error for 0 mean accel is: %f \n\n',meanErrorVel);

% Calculate filter 3 sigma error from last Monte Carlo run
sigPos = zeros(1,length(t));
sigVel = zeros(1,length(t));
for k = 1:length(t)
    sigPos(1,k) = 3*sqrt(P(1,1))+20;
    sigVel(1,k) = 3*sqrt(P(2,2));
end
negSigPos = -1 * sigPos;
negSigVel = -1 * sigVel;
fprintf('The filter 3 sigma posiiton error for 0 mean accel is: %f \n',mean(sigPos));
fprintf('The filter 3 sigma velocity error for 0 mean accel is: %f \n',mean(sigVel));

% Position State Covariance Graph
subplot(2,1,1);
plot(t, graphErrorPos, 'green', 'LineWidth',1);
plot(t, graphstdPos, 'red');
plot(t, invstdPos, 'red');
plot(t, sigPos, '--red', 'LineWidth',1);
plot(t, negSigPos, '--red', 'LineWidth',1);
hold off;
xlabel('Time [sec]');
ylabel('Position Error [m]');
ylim([-120 120]);
title('Target Position Covariance and State Error for Zero Mean Accel');

% Velocity State Covariance Graph
subplot(2,1,2);
plot(t, graphErrorVel, 'green', 'LineWidth',1);
plot(t, graphstdVel, 'red');
plot(t, invstdVel, 'red');
plot(t, sigVel, '--red', 'LineWidth',1);
plot(t, negSigVel, '--red', 'LineWidth',1);
hold off;
xlabel('Time [sec]');
ylabel('Velocity Error [m/s]');
ylim([-30 30]);
title('Target Velocity Covariance and State Error for Zero Mean Accel');

%% 1.1 Kalman Filter Constant Acceleration

clc; clear all;

runs = 500;                                 % Monte Carlo run
dt = 2;                                     % Sample time
t = 0:dt:50;
H = [1 0];
G = [dt^2/2;dt];                            % Acceleration factor
Rtrue = 1000;                       
Wtrue = 9;
R = 0.94*Rtrue;                             % Filter measurement variance
W = 0.9*Wtrue;                              % Filter model error
phi = [1 dt;0 1];                           % Transition matrix
P = [1 1/dt;1/dt 2/(dt^2)]*R;               % State covariance (initial)                                    
Q = [(1/4)*(dt^4) (1/2)*(dt^3);(1/2)*(dt^3) dt^2]*W;	% DWNA noise

% Position arrays for plotting
runErrorPos = zeros(1,runs);
graphErrorPos = zeros(1,length(t));
runstdPos = zeros(runs,length(t));
graphstdPos = zeros(1,length(t));

% Velocity arrays for plotting
runErrorVel = zeros(1,runs);
graphErrorVel = zeros(1,length(t));
runstdVel = zeros(runs,length(t)); 
graphstdVel = zeros(1,length(t));

for i = 1:runs
    
   a = (mvnrnd(9,0,length(t)))';            % Generate samples
   p = 0;                                   % Set initial conditions
   v = 10;
   prior = [p;v];                           % Set initial prior assumption
   post = [];
   error = [];
   state = [p;v];
   
   % ADD IN ACCELERATION TO KINEMATICS
   for k = 2:length(t)
     state(:,k) = phi*state(:,k-1)+G*a(k);	% Kinematics
   end
   
   r =(mvnrnd(0,Rtrue,length(t)))';         % mean=0, variance=sqrt(1000)
   
   for k = 1:length(t)
      meas(k) =  H*state(:,k)+r(k);         % Add noise to true
   end
   
   for k = 1:length(t)
       prior = phi*prior;                   % Calc next step prior
       res = meas(k)-H*prior;               % Calc residual
       P = phi*P*phi'+Q;                    % Calc prior cov
       K = P*H'*((H*P*H'+R)^-1);            % Calc gains
       P = (eye(2)-K*H)*P*(eye(2)-K*H)'+K*R*K';     % Calc post cov
       stdPos(i,k) = 3 * sqrt(P(1,1));      % Store position covariance
       stdVel(i,k) = 3 * sqrt(P(2,2));      % Store velocity covariance
       tempvar = prior+K*res;               % Calc post prediction
       post(:,k) = tempvar;                 % Store var
       prior = post(:,k);                   % Reset prior to be post
       error(:,k) = state(:,k)-post(:,k);	% Calc error vs true
   end
   
   % Position mean error algorithm
   runErrorPos(1,i) = mean(error(1,:));
   if (i == runs)
       meanErrorPos = mean(runErrorPos);
       for k = 1:length(t)
           graphErrorPos(1,k) = meanErrorPos;
       end
   end
   
	% Position standard deviation algorithm
    runstdPos(i,:) = error(1,:);
    if (i == runs)
        for k = 1:length(t)
            graphstdPos(1,k) = 3*std(runstdPos(:,k));
        end
    end
   
   % Velocity mean error algorithm
   runErrorVel(1,i) = mean(error(2,:));
   if (i == runs)
       meanErrorVel = mean(runErrorVel);
       for k = 1:length(t)
           graphErrorVel(1,k) = meanErrorVel;
       end
   end
   
   	% Velocity standard deviation algorithm
    runstdVel(i,:) = error(2,:);
    if (i == runs)
        for k = 1:length(t)
            graphstdVel(1,k) = 3*std(runstdVel(:,k));
        end
    end
   
   % Plot each position run
   figure(2)
   subplot(2,1,1)
   hold on;
   plot(t, error(1,:), 'blue');
   
   % Plot each velocity run
   subplot(2,1,2)
   hold on;
   plot(t, error(2,:), 'blue');
   
end

% Create lower bound of standard deviation
invstdPos = -1 * graphstdPos;
invstdVel = -1 * graphstdVel;

% Display mean error values
fprintf('The mean position error for const accel is: %f \n',meanErrorPos);
fprintf('The mean velocity error for const accel is: %f \n\n',meanErrorVel);

% Calculate filter 3 sigma error from last Monte Carlo run
sigPos = zeros(1,length(t));
sigVel = zeros(1,length(t));
for k = 1:length(t)
    sigPos(1,k) = 3*sqrt(P(1,1))+20;
    sigVel(1,k) = 3*sqrt(P(2,2));
end
negSigPos = -1 * sigPos;
negSigVel = -1 * sigVel;
fprintf('The filter 3 sigma posiiton error for cosnt accel is: %f \n',mean(sigPos));
fprintf('The filter 3 sigma velocity error for const accel is: %f \n',mean(sigVel));

% Position State Covariance Graph
subplot(2,1,1);
plot(t, graphErrorPos, 'green', 'LineWidth',1);
plot(t, graphstdPos, 'red');
plot(t, invstdPos, 'red');
plot(t, sigPos, '--red', 'LineWidth',1);
plot(t, negSigPos, '--red', 'LineWidth',1);
hold off;
xlabel('Time [sec]');
ylabel('Position Error [m]');
ylim([-120 150]);
title('Target Position Covariance and State Error for Constant Accel');

% Velocity State Covariance Graph
subplot(2,1,2);
plot(t, graphErrorVel, 'green', 'LineWidth',1);
plot(t, graphstdVel, 'red');
plot(t, invstdVel, 'red');
plot(t, sigVel, '--red', 'LineWidth',1);
plot(t, negSigVel, '--red', 'LineWidth',1);
hold off;
xlabel('Time [sec]');
ylabel('Velocity Error [m/s]');
ylim([-30 60]);
title('Target Velocity Covariance and State Error for Constant Accel');
