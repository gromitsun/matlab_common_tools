function diff_vol = myanisodiff3D(vol, num_iter, delta_t, kappa, option, voxel_spacing, verbose)
%ANISODIFF2D Conventional anisotropic diffusion
%   DIFF_VOL = ANISODIFF3D(VOL, NUM_ITER, DELTA_T, KAPPA, OPTION, VOXEL_SPACING) perfoms 
%   conventional anisotropic diffusion (Perona & Malik) upon a stack of gray scale images.
%   A 3D network structure of 26 neighboring nodes is considered for diffusion conduction.
% 
%       ARGUMENT DESCRIPTION:
%               VOL      - gray scale volume data (MxNxP).
%               NUM_ITER - number of iterations. 
%               DELTA_T  - integration constant (0 <= delta_t <= 3/44).
%                          Usually, due to numerical stability this 
%                          parameter is set to its maximum value.
%               KAPPA    - gradient modulus threshold that controls the conduction.
%               OPTION   - conduction coefficient functions proposed by Perona & Malik:
%                          1 - c(x,y,z,t) = exp(-(nablaI/kappa).^2),
%                              privileges high-contrast edges over low-contrast ones. 
%                          2 - c(x,y,z,t) = 1./(1 + (nablaI/kappa).^2),
%                              privileges wide regions over smaller ones.
%          VOXEL_SPACING - 3x1 vector column with the x, y and z dimensions of
%                          the voxel (milimeters). In particular, only cubic and 
%                          anisotropic voxels in the z-direction are considered. 
%                          When dealing with DICOM images, the voxel spacing 
%                          dimensions can be extracted using MATLAB's dicominfo(.).
% 
%       OUTPUT DESCRIPTION:
%               DIFF_VOL - (diffused) volume with the largest scale-space parameter.
% 
%   Example
%   -------------
%   vol = randn(100,100,100);
%   num_iter = 4;
%   delta_t = 3/44;
%   kappa = 70;
%   option = 2;
%   voxel_spacing = ones(3,1);
%   diff_vol = anisodiff3D(vol, num_iter, delta_t, kappa, option, voxel_spacing);
%   figure, subplot 121, imshow(vol(:,:,50),[]), subplot 122, imshow(diff_vol(:,:,50),[])
% 
% See also anisodiff1D, anisodiff2D.

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
if nargin < 7
    verbose = false;
end

% Convert input volume to double.
vol = double(vol);

% Center voxel distances.
x = voxel_spacing(1);
y = voxel_spacing(2);
z = voxel_spacing(3);
dx = 1;
dy = 1;
dz = z/x;
dd = sqrt(dx^2+dy^2);
dh = sqrt(dx^2+dz^2);
dc = sqrt(dd^2+dz^2);

% 3D convolution masks - finite differences.
h1 = zeros(3,3,3); h1(2,2,2) = -1; h1(2,2,1) = 1;
h2 = zeros(3,3,3); h2(2,2,2) = -1; h2(2,2,3) = 1;
h3 = zeros(3,3,3); h3(2,2,2) = -1; h3(2,1,2) = 1;
h4 = zeros(3,3,3); h4(2,2,2) = -1; h4(2,3,2) = 1;
h5 = zeros(3,3,3); h5(2,2,2) = -1; h5(3,2,2) = 1;
h6 = zeros(3,3,3); h6(2,2,2) = -1; h6(1,2,2) = 1;

h7 = zeros(3,3,3); h7(2,2,2) = -1; h7(3,1,1) = 1;
h8 = zeros(3,3,3); h8(2,2,2) = -1; h8(2,1,1) = 1;
h9 = zeros(3,3,3); h9(2,2,2) = -1; h9(1,1,1) = 1;
h10 = zeros(3,3,3); h10(2,2,2) = -1; h10(3,2,1) = 1;
h11 = zeros(3,3,3); h11(2,2,2) = -1; h11(1,2,1) = 1;
h12 = zeros(3,3,3); h12(2,2,2) = -1; h12(3,3,1) = 1;
h13 = zeros(3,3,3); h13(2,2,2) = -1; h13(2,3,1) = 1;
h14 = zeros(3,3,3); h14(2,2,2) = -1; h14(1,3,1) = 1;

h15 = zeros(3,3,3); h15(2,2,2) = -1; h15(3,1,2) = 1;
h16 = zeros(3,3,3); h16(2,2,2) = -1; h16(1,1,2) = 1;
h17 = zeros(3,3,3); h17(2,2,2) = -1; h17(3,3,2) = 1;
h18 = zeros(3,3,3); h18(2,2,2) = -1; h18(1,3,2) = 1;

h19 = zeros(3,3,3); h19(2,2,2) = -1; h19(3,1,3) = 1;
h20 = zeros(3,3,3); h20(2,2,2) = -1; h20(2,1,3) = 1;
h21 = zeros(3,3,3); h21(2,2,2) = -1; h21(1,1,3) = 1;
h22 = zeros(3,3,3); h22(2,2,2) = -1; h22(3,2,3) = 1;
h23 = zeros(3,3,3); h23(2,2,2) = -1; h23(1,2,3) = 1;
h24 = zeros(3,3,3); h24(2,2,2) = -1; h24(3,3,3) = 1;
h25 = zeros(3,3,3); h25(2,2,2) = -1; h25(2,3,3) = 1;
h26 = zeros(3,3,3); h26(2,2,2) = -1; h26(1,3,3) = 1;

% Anisotropic diffusion.
for t = 1:num_iter

    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h1, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = (1/(dz^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = (1/(dz^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h2, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dz^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dz^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h3, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dx^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dx^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h4, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dx^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dx^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h5, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dy^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dy^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h6, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dy^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dy^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h7, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dc^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dc^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end    
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h8, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dh^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dh^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h9, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dc^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dc^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end    
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h10, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dh^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dh^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h11, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dh^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dh^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h12, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dc^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dc^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h13, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dh^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dh^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h14, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dc^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dc^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h15, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dd^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dd^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h16, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dd^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dd^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h17, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dd^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dd^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h18, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dd^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dd^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h19, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dc^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dc^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h20, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dh^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dh^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h21, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dc^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dc^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end    
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h22, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dh^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dh^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h23, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dh^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dh^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h24, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dc^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dc^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h25, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dh^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dh^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Finite differences. [imfilter(.,.,'conv') can be replaced by convn(.,.,'same')]
    nabla = imfilter(vol, h26, 'conv');
    % Diffusion function & Discrete PDE solution.
    if option == 1
        diff_vol = diff_vol + (1/(dc^2)) * exp(-(nabla/kappa).^2) .* nabla;
    elseif option == 2
        diff_vol = diff_vol + (1/(dc^2)) ./(1 + (nabla/kappa).^2) .* nabla;
    end
    
    % Step forward PDE
    vol = vol + delta_t * diff_vol;

    % Iteration warning.
    if verbose
        fprintf('\rIteration %d\n',t);
        beep on
        beep, pause(0.2), beep
        beep off
    end
end

% "End of Program" warning.
beep on;
beep, pause(0.5), beep, pause(0.5), beep, pause(0.5),
beep, pause(0.5), beep, pause(0.5), beep, pause(0.5);
% Search at MATLAB Central's FileExchange for the beepbeep(.) function
% ("beepbeep" as keyword). It is a useful application to alert the termination of 
% a program execution by emitting a ritmic sequence of OS beeps.
% http://www.mathworks.com/matlabcentral/fileexchange/loadCategory.do