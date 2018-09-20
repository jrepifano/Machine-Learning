% 3.0 ORSE Filter Zero Mean Acceleration

clc; clear all; close all;

runs = 500;                                 % Monte Carlo run
dt = 1;                                     % Sample time
t = 0:dt:50;
H = [1 0 0 0 0 0;
     0 1 0 0 0 0;
     0 0 1 0 0 0];
G = [dt^2/2 0 0;
     0 dt^2/2 0;
     0 0 dt^2/2;
     dt 0 0;
     0 dt 0;
     0 0 dt];                               % Acceleration factor
Rtrue = 1000;                       
R = Rtrue;                             % Filter measurement variance
phi = eye(6);                               % Transition matrix
phi(1,4)=dt;phi(2,5)=dt;phi(3,6)=dt;                                          

% Position arrays for plotting
runErrorPos = zeros(3,runs);
graphErrorPos = zeros(3,length(t));
runstdPosX = zeros(runs,length(t));
runstdPosY = zeros(runs,length(t));
runstdPosZ = zeros(runs,length(t));
graphstdPos = zeros(3,length(t));
sigPos = zeros(3,length(t));
stdPosX = zeros(runs,length(t));
stdPosY = zeros(runs,length(t));
stdPosZ = zeros(runs,length(t));

% Velocity arrays for plotting
runErrorVel = zeros(3,runs);
graphErrorVel = zeros(3,length(t));
runstdVelX = zeros(runs,length(t)); 
runstdVelY = zeros(runs,length(t));
runstdVelZ = zeros(runs,length(t));
graphstdVel = zeros(3,length(t));
sigVel = zeros(3,length(t));
stdVelX = zeros(runs,length(t));
stdVelY = zeros(runs,length(t));
stdVelZ = zeros(runs,length(t));

for i = 1:runs
    
   M = 10000*ones(6,6);
   D = zeros(6,3);
   
   A = [0;0;-1]*9.81+2*rand;                % Generate samples 
                                            % account for const gravity
   p = [0;0;200000];                        % Set initial conditions
   v = [0;10;0];
   prior = [p;v];                           % Set initial prior assumption
   post = [];
   error = [];
   state = [p;v];
   
   % Generate noise to add to measurements
   r =(mvnrnd([0 0 0],[Rtrue Rtrue Rtrue],length(t)))';
   % Generate Lambda based on max acc
   lambda = [10 0 0;0 10 0;0 0 10];
   
   % Kinematic state vector
   for k = 2:length(t)
      state(:,k) = phi*state(:,k-1)+G*A;     % Kinematics
   end
   
   for k = 1:length(t)
      meas(:,k) =  H*state(:,k)+r(:,k);     % Add noise to true
   end
   
   for k = 1:length(t)
       prior = phi*prior;                   % Calc next step prior
       res = meas(:,k)-H*prior;               % Calc residual
       M = phi*M*phi';                      % Calc prior cov
       D = phi*D+G;
       S = M+D*(lambda^2)*D';
       K = S*H'*((H*S*H'+R)^-1);              % Calc gains
       M = (eye(6)-K*H)*M*(eye(6)-K*H)'+K*R*K';     % Calc post cov
       D = (eye(6)-K*H)*D;                  % update lag
       stdPosX(i,k) = 3 * sqrt(S(1,1));     % Store covariance pos X
       stdPosY(i,k) = 3 * sqrt(S(2,2));     % Store covariance pos Y
       stdPosZ(i,k) = 3 * sqrt(S(3,3));     % Store covariance pos Z
       stdVelX(i,k) = 3 * sqrt(S(4,4));     % Store covariance vel X
       stdVelY(i,k) = 3 * sqrt(S(5,5));     % Store covariance vel Y
       stdVelZ(i,k) = 3 * sqrt(S(6,6));     % Store covariance vel Z
       tempvar = prior+K*res;               % Calc post prediction
       post(:,k) = tempvar;                 % Store var
       prior = post(:,k);                   % Reset prior to be post
       error(:,k) = state(:,k)-post(:,k);	% Calc error vs true
       
       % Calculate filter 3 sigma error from last Monte Carlo run
       if (i == runs)
           sigPos(1,k) = stdPosX(i,k)+20;
           sigPos(2,k) = stdPosY(i,k)+20;
           sigPos(3,k) = stdPosZ(i,k)+20;
           sigVel(1,k) = stdVelX(i,k);
           sigVel(2,k) = stdVelY(i,k);
           sigVel(3,k) = stdVelZ(i,k);
%            disp(sigPos(1,k)); disp(sigPos(2,k)); disp(sigPos(3,k));
%            disp(sigVel(1,k)); disp(sigVel(2,k)); disp(sigVel(3,k));
       end
   end
   
   % Position mean error algorithm
   runErrorPos(1,i) = mean(error(1,:));
   runErrorPos(2,i) = mean(error(2,:));
   runErrorPos(3,i) = mean(error(3,:));
   if (i == runs)
       meanErrorPosX = mean(runErrorPos(1,:));
       meanErrorPosY = mean(runErrorPos(2,:));
       meanErrorPosZ = mean(runErrorPos(3,:));
       for k = 1:length(t)
           graphErrorPos(1,k) = meanErrorPosX;
           graphErrorPos(2,k) = meanErrorPosY;
           graphErrorPos(3,k) = meanErrorPosZ;
       end
   end
   
   % Velocity mean error algorithm
   runErrorVel(1,i) = mean(error(4,:));
   runErrorVel(2,i) = mean(error(5,:));
   runErrorVel(3,i) = mean(error(6,:));
   if (i == runs)
       meanErrorVelX = mean(runErrorVel(1,:));
       meanErrorVelY = mean(runErrorVel(2,:));
       meanErrorVelZ = mean(runErrorVel(3,:));
       for k = 1:length(t)
           graphErrorVel(1,k) = meanErrorVelX;
           graphErrorVel(2,k) = meanErrorVelY;
           graphErrorVel(3,k) = meanErrorVelZ;
       end
   end
   
   	% Position standard deviation algorithm
    runstdPosX(i,:) = error(1,:);
    runstdPosY(i,:) = error(2,:);
    runstdPosZ(i,:) = error(3,:);
    if (i == runs)
        for k = 1:length(t)
            graphstdPos(1,k) = 3*std(runstdPosX(:,k));
            graphstdPos(2,k) = 3*std(runstdPosY(:,k));
            graphstdPos(3,k) = 3*std(runstdPosZ(:,k));
        end
    end
    
    % Position standard deviation algorithm
    runstdVelX(i,:) = error(4,:);
    runstdVelY(i,:) = error(5,:);
    runstdVelZ(i,:) = error(6,:);
    if (i == runs)
        for k = 1:length(t)
            graphstdVel(1,k) = 3*std(runstdVelX(:,k));
            graphstdVel(2,k) = 3*std(runstdVelY(:,k));
            graphstdVel(3,k) = 3*std(runstdVelZ(:,k));
        end
    end
   
   % Plot the position run
   figure(1)
   subplot(3,1,1)
   hold on;
   plot(t, error(1,:),'blue');
   title('Target Position Covariance and State Error - ORSE3D');
   subplot(3,1,2)
   hold on;
   plot(t, error(2,:),'blue');
   subplot(3,1,3)
   hold on;
   plot(t, error(3,:),'blue');

   % Plot each velocity run
   figure(2)
   subplot(3,1,1)
   hold on;
   plot(t, error(4,:),'blue');
   title('Target Velocity Covariance and State Error - ORSE3D');
   subplot(3,1,2)
   hold on;
   plot(t, error(5,:),'blue');
   subplot(3,1,3)
   hold on;
   plot(t, error(6,:),'blue');
   
end

% Create inverse bound of standard deviation
invstdPos(1,:) = -1 * graphstdPos(1,:);
invstdPos(2,:) = -1 * graphstdPos(2,:);
invstdPos(3,:) = -1 * graphstdPos(3,:);
invstdVel(1,:) = -1 * graphstdVel(1,:);
invstdVel(2,:) = -1 * graphstdVel(2,:);
invstdVel(3,:) = -1 * graphstdVel(3,:);

% Create inverse bound of 3 sigma position error
negSigPos(1,:) = -1 * sigPos(1,:);
negSigPos(2,:) = -1 * sigPos(2,:);
negSigPos(3,:) = -1 * sigPos(3,:);
negSigVel(1,:) = -1 * sigVel(1,:);
negSigVel(2,:) = -1 * sigVel(2,:);
negSigVel(3,:) = -1 * sigVel(3,:);

% Display mean error values
fprintf('The mean position error in X direction: %f \n',meanErrorPosX);
fprintf('The mean position error in Y direction: %f \n',meanErrorPosY);
fprintf('The mean position error in Z direction: %f \n',meanErrorPosZ);
fprintf('The mean velocity error in X direction: %f \n',meanErrorVelX);
fprintf('The mean velocity error in Y direction: %f \n',meanErrorVelY);
fprintf('The mean velocity error in Z direction: %f \n\n',meanErrorVelZ);

fprintf('The filter 3 sigma posiiton error in X direction: %f \n',mean(sigPos(1,:)));
fprintf('The filter 3 sigma posiiton error in Y direction: %f \n',mean(sigPos(2,:)));
fprintf('The filter 3 sigma posiiton error in Z direction: %f \n',mean(sigPos(3,:)));
fprintf('The filter 3 sigma velocity error in X direction: %f \n',mean(sigVel(1,:)));
fprintf('The filter 3 sigma velocity error in Y direction: %f \n',mean(sigVel(2,:)));
fprintf('The filter 3 sigma velocity error in Z direction: %f \n',mean(sigVel(3,:)));

% Position State Covariance Graph
figure(1)
subplot(3,1,1);
plot(t, graphErrorPos(1,:), 'green', 'LineWidth',1);
plot(t, graphstdPos(1,:), 'red');
plot(t, invstdPos(1,:), 'red');
plot(t, sigPos(1,:), '--red', 'LineWidth',1);
plot(t, negSigPos(1,:), '--red', 'LineWidth',1);
hold off;
xlabel('Time [sec]');
ylabel('Pos Error X [m]');

subplot(3,1,2);
plot(t, graphErrorPos(2,:), 'green', 'LineWidth',1);
plot(t, graphstdPos(2,:), 'red');
plot(t, invstdPos(2,:), 'red');
plot(t, sigPos(2,:), '--red', 'LineWidth',1);
plot(t, negSigPos(2,:), '--red', 'LineWidth',1);
hold off;
xlabel('Time [sec]');
ylabel('Pos Error Y [m]');

subplot(3,1,3);
plot(t, graphErrorPos(3,:), 'green', 'LineWidth',1);
plot(t, graphstdPos(3,:), 'red');
plot(t, invstdPos(3,:), 'red');
plot(t, sigPos(3,:), '--red', 'LineWidth',1);
plot(t, negSigPos(3,:), '--red', 'LineWidth',1);
hold off;
xlabel('Time [sec]');
ylabel('Pos Error Z [m]');

% Velocity State Covariance Graph
figure(2)
subplot(3,1,1);
plot(t, graphErrorVel(1,:), 'green', 'LineWidth',1);
plot(t, graphstdVel(1,:), 'red');
plot(t, invstdVel(1,:), 'red');
plot(t, sigVel(1,:), '--red', 'LineWidth',1);
plot(t, negSigVel(1,:), '--red', 'LineWidth',1);
hold off;
xlabel('Time [sec]');
ylabel('Vel Error X [m]');

subplot(3,1,2);
plot(t, graphErrorVel(2,:), 'green', 'LineWidth',1);
plot(t, graphstdVel(2,:), 'red');
plot(t, invstdVel(2,:), 'red');
plot(t, sigVel(2,:), '--red', 'LineWidth',1);
plot(t, negSigVel(2,:), '--red', 'LineWidth',1);
hold off;
xlabel('Time [sec]');
ylabel('Vel Error Y [m]');

subplot(3,1,3);
plot(t, graphErrorVel(3,:), 'green', 'LineWidth',1);
plot(t, graphstdVel(3,:), 'red');
plot(t, invstdVel(3,:), 'red');
plot(t, sigVel(3,:), '--red', 'LineWidth',1);
plot(t, negSigVel(3,:), '--red', 'LineWidth',1);
hold off;
xlabel('Time [sec]');
ylabel('Vel Error Z [m]');