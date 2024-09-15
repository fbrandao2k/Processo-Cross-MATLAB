%% Cross
%
% This is a MATLAB program for solving a continuous beam using the
% Cross Process.
% Euler-Bernoulli flexural behavior is assumed (Navier beam theory).
% This is an initial version without any GUI (Graphics User Interface)>
%
% This program implements the Cross Process for continuous beams with
% uniformly distributed loads in each spam.
%
% For more details of this process, refer to the book "Análise de
% Estruturas: Conceitos e Métodos Básicos", Second Edition, by Luiz
% Fernando Martha, Elsevier, 2017.
%
%% Object oriented classes
% This program adopts an Object Oriented Programming (OOP) paradigm, in
% which the following OOP classes are implemented:
%%%
% * <crosssolver.html CrossSolver class>.
% * <crossmember.html CrossMember class>.
% * <crossnode.html CrossNode class>.
% * <crossdraw.html CrossDraw class>.
%
%% Author
% Luiz Fernando Martha
%
%% History
% @version 1.00
%
% Initial version: September 2017
%%%
% Initially prepared for the course CIV 2801 - Fundamentos de Computação
% Gráfica, 2017, second term, Department of Civil Engineering, PUC-Rio.
%
%% Clear memory
clc;
clear all; %#ok<CLALL>
close all;

%% Launch GUI
%%%%%%% COMPLETE HERE - MAIN: 01 %%%%%%%
%%% Enter the name of function of the first function in your
%%% main figure file.
cross_process();
%%%%%%% COMPLETE HERE - MAIN: 01 %%%%%%%
