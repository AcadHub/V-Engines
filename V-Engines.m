% Simulate the dynamic behavior of V-engine components (pistons and crankshaft)

% Input parameters (user-defined or constant values)
mass_piston = input('Enter the mass of each piston (in kg): '); % Mass of each piston
force_peak = input('Enter the peak force applied to the piston (in N): '); % Peak force (N)
engine_speed = input('Enter the engine speed (RPM): '); % Engine speed (in RPM)
stroke_length = input('Enter the piston stroke length (in meters): '); % Stroke length (m)
duration = input('Enter the simulation duration (in seconds): '); % Duration of simulation (s)
angle_of_bank = input('Enter the angle of the second bank (in degrees): '); % Angle of the second bank (degrees)

% Constants
omega = 2 * pi * engine_speed / 60; % Angular velocity in rad/s (convert RPM to rad/s)
time_step = 0.001; % Time step for the simulation (in seconds)

% Initial conditions (position and velocity of the pistons)
initial_position = 0; % Initial position of the piston (m)
initial_velocity = 0; % Initial velocity of the piston (m/s)

% Time vector for simulation
time = 0:time_step:duration;

% Crankshaft angle calculation (for two pistons in a V-engine)
crank_angle_1 = omega * time; % Crank angle for bank 1
crank_angle_2 = omega * time + deg2rad(angle_of_bank); % Crank angle for bank 2 (with phase difference)

% Force as a function of crank angle (simplified model: sinusoidal force profile)
force_function = @(t) force_peak * sin(crank_angle_1);

% Differential equations (motion of piston 1 and piston 2)
% Using Newton's second law: F = ma -> a = F/m

% Define the ODEs for both pistons
ode_fun = @(t, y) [y(2); force_function(t) / mass_piston];

% Initial conditions (position and velocity for both pistons)
initial_conditions = [initial_position, initial_velocity];

% Solve ODE for piston 1 (first bank)
[time_vals, piston1_vals] = ode45(ode_fun, time, initial_conditions);

% Update force function for piston 2 (second bank)
force_function_2 = @(t) force_peak * sin(crank_angle_2); % Different phase for second piston

% Define the ODE for piston 2
ode_fun_2 = @(t, y) [y(2); force_function_2(t) / mass_piston];

% Solve ODE for piston 2 (second bank)
[~, piston2_vals] = ode45(ode_fun_2, time, initial_conditions);

% Plot the piston movements for both banks
figure;
subplot(2, 1, 1);
plot(time_vals, piston1_vals(:, 1), 'r', 'LineWidth', 1.5); % Piston 1 (first bank)
hold on;
plot(time_vals, piston2_vals(:, 1), 'b', 'LineWidth', 1.5); % Piston 2 (second bank)
title('Piston Position vs Time');
xlabel('Time (s)');
ylabel('Position (m)');
legend('Piston 1 (Bank 1)', 'Piston 2 (Bank 2)');
grid on;

% Animate the piston movement
figure;
hold on;
axis([-stroke_length stroke_length -stroke_length stroke_length]);
title('Piston Movement Animation');
xlabel('Position (m)');
ylabel('Position (m)');

h_piston1 = plot(0, 0, 'ro', 'MarkerFaceColor', 'r');
h_piston2 = plot(0, 0, 'bo', 'MarkerFaceColor', 'b');

for i = 1:length(time_vals)
    % Update piston positions
    set(h_piston1, 'XData', piston1_vals(i, 1), 'YData', 0);
    set(h_piston2, 'XData', piston2_vals(i, 1), 'YData', 0);
    
    % Pause for a smooth animation
    pause(time_step);
end
