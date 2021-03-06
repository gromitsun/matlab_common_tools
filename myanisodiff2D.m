function im = myanisodiff2D(im, num_iter, delta_t, kappa, option, verbose)
%ANISODIFF2D Conventional anisotropic diffusion
%   DIFF_IM = ANISODIFF2D(IM, NUM_ITER, DELTA_T, KAPPA, OPTION) perfoms 
%   conventional anisotropic diffusion (Perona & Malik) upon a gray scale
%   image. A 2D network structure of 8 neighboring nodes is considered for 
%   diffusion conduction.
% 
%       ARGUMENT DESCRIPTION:
%               IM       - gray scale image (MxN).
%               NUM_ITER - number of iterations. 
%               DELTA_T  - integration constant (0 <= delta_t <= 1/7).
%                          Usually, due to numerical stability this 
%                          parameter is set to its maximum value.
%               KAPPA    - gradient modulus threshold that controls the conduction.
%               OPTION   - conduction coefficient functions proposed by Perona & Malik:
%                          1 - c(x,y,t) = exp(-(nablaI/kappa).^2),
%                              privileges high-contrast edges over low-contrast ones. 
%                          2 - c(x,y,t) = 1./(1 + (nablaI/kappa).^2),
%                              privileges wide regions over smaller ones. 
% 
%       OUTPUT DESCRIPTION:
%                DIFF_IM - (diffused) image with the largest scale-space parameter.
% 
%   Example
%   -------------
%   s = phantom(512) + randn(512);
%   num_iter = 15;
%   delta_t = 1/7;
%   kappa = 30;
%   option = 2;
%   ad = anisodiff2D(s,num_iter,delta_t,kappa,option);
%   figure, subplot 121, imshow(s,[]), subplot 122, imshow(ad,[])
% 
% See also anisodiff1D, anisodiff3D.

% References: 
%   P. Perona and J. Malik. 
%   Scale-Space and Edge Detection Using Anisotropic Diffusion.
%   IEEE Transactions on Pattern Analysis and Machine Intelligence, 
%   12(7):629-639, July 1990.
% 
%   G. Grieg, O. Kubler, R. Kikinis, and F. A. Jolesz.
%   Nonlinear Anisotropic Filtering of MRI Data.
%   IEEE Transactions on Medical Imaging,
%   11(2):221-232, June 1992.
% 
%   MATLAB implementation based on Peter Kovesi's anisodiff(.):
%   P. D. Kovesi. MATLAB and Octave Functions for Computer Vision and Image Processing.
%   School of Computer Science & Software Engineering,
%   The University of Western Australia. Available from:
%   <http://www.csse.uwa.edu.au/~pk/research/matlabfns/>.
% 
% Credits:
% Daniel Simoes Lopes
% ICIST
% Instituto Superior Tecnico - Universidade Tecnica de Lisboa
% danlopes (at) civil ist utl pt
% http://www.civil.ist.utl.pt/~danlopes
%
% May 2007 original version.

% Get verbose option
if nargin < 6
    verbose = false;
end

% Convert input image to double.
im = double(im);

% Center pixel distances.
dx = 1;
dy = 1;
dd = sqrt(2);

% 2D convolution masks - finite differences.
hN = [0 1 0; 0 -1 0; 0 0 0];
hS = [0 0 0; 0 -1 0; 0 1 0];
hE = [0 0 0; 0 -1 1; 0 0 0];
hW = [0 0 0; 1 -1 0; 0 0 0];
hNE = [0 0 1; 0 -1 0; 0 0 0];
hSE = [0 0 0; 0 -1 0; 0 0 1];
hSW = [0 0 0; 0 -1 0; 1 0 0];
hNW = [1 0 0; 0 -1 0; 0 0 0];

% Anisotropic diffusion.
for t = 1:num_iter
        
    % N
    % Finite differences. [imfilter(.,.,'conv') can be replaced by conv2(.,.,'same')]
    nabla = imfilter(im,hN,'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_im = (1/(dy^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_im = (1/(dy^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end

    % S
    % Finite differences. [imfilter(.,.,'conv') can be replaced by conv2(.,.,'same')]
    nabla = imfilter(im,hS,'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_im = diff_im + (1/(dy^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_im = diff_im + (1/(dy^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end

    % W
    % Finite differences. [imfilter(.,.,'conv') can be replaced by conv2(.,.,'same')]
    nabla = imfilter(im,hW,'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_im = diff_im + (1/(dx^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_im = diff_im + (1/(dx^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end

    % E
    % Finite differences. [imfilter(.,.,'conv') can be replaced by conv2(.,.,'same')]
    nabla = imfilter(im,hE,'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_im = diff_im + (1/(dx^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_im = diff_im + (1/(dx^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end

    % NE
    % Finite differences. [imfilter(.,.,'conv') can be replaced by conv2(.,.,'same')]
    nabla = imfilter(im,hNE,'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_im = diff_im + (1/(dd^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_im = diff_im + (1/(dd^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end

    % SE
    % Finite differences. [imfilter(.,.,'conv') can be replaced by conv2(.,.,'same')]
    nabla = imfilter(im,hSE,'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_im = diff_im + (1/(dd^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_im = diff_im + (1/(dd^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end

    % SW
    % Finite differences. [imfilter(.,.,'conv') can be replaced by conv2(.,.,'same')]
    nabla = imfilter(im,hSW,'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_im = diff_im + (1/(dd^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_im = diff_im + (1/(dd^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end

    % NW
    % Finite differences. [imfilter(.,.,'conv') can be replaced by conv2(.,.,'same')]
    nabla = imfilter(im,hSE,'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_im = diff_im + (1/(dd^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_im = diff_im + (1/(dd^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end

    % Step forward PDE
    im = im + delta_t * diff_im;

    % Iteration warning.
    if verbose
        fprintf('\rIteration %d\n',t);
    end
end