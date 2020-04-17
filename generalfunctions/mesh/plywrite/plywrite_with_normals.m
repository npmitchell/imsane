function plywrite_with_normals(filename,faces,verts,varargin)
% plywrite(filename, faces, verts, normals, rgb)
% Will write a face vertex mesh data in ply format.
%
% INPUTS
% ------
% faces : polygonal descriptions in terms of vertex indices
% verts : list of vertex coordinate triplets
%   faces and verts can be obtained by using the MATLAB isosurface function.
% varargin: normals or normals and rgb, optional
%   normals is an optional N x 3 float array of vertex normal vectors
%   rgb is an optional N x 3 int array of color information at each vertex
%
% plywrite(filename,faces,verts,normals)
% Will add normals to the vertices
% normals : optional list of vertex normals (one per vertex)
%
% plywrite(filename,faces,verts,normals,rgb)
% Will add color information.
% rgb : optional list of RGB triplets per vertex
%
% A by-product of ongoing computational materials science research 
% at MINED@Gatech.(http://mined.gatech.edu/)
%
% Copyright (c) 2015, Ahmet Cecen and MINED@Gatech -  All rights reserved.
% Modified Noah P Mitchell 2019 to include normals, changed header

% Create File
fileID = fopen(filename,'w');


% Plain Mesh
if nargin == 3
    
    % Insert Header
    fprintf(fileID, ...
        ['ply\n', ...
        'format ascii 1.0\n', ...
        'element vertex %u\n', ...
        'property float x\n', ...
        'property float y\n', ...
        'property float z\n', ...
        'element face %u\n', ...
        'property list uint8 int32 vertex_indices\n', ...
        'end_header\n'], ...
        length(verts),length(faces));

    % Insert Colored Vertices
    for i=1:length(verts)
        fprintf(fileID, ...
            ['%.6f ', ...
            '%.6f ', ...
            '%.6f\n'], ...
            verts(i,1),verts(i,2),verts(i,3));
    end

    % Insert Faces
    dlmwrite(filename,[size(faces,2)*ones(length(faces),1),faces-1],'-append','delimiter',' ','precision',10);

% Mesh with normals
elseif nargin == 4
    
    normals=varargin{1};
    
    % Insert Header
    fprintf(fileID, ...
        ['ply\n', ...
        'format ascii 1.0\n', ...
        'element vertex %u\n', ...
        'property float x\n', ...
        'property float y\n', ...
        'property float z\n', ...
        'property float nx\n', ...
        'property float ny\n', ...
        'property float nz\n', ...
        'element face %u\n', ...
        'property list uchar int vertex_indices\n', ...
        'end_header\n'], ...
        length(verts),length(faces));

    % Insert Colored Vertices
    for i=1:size(verts, 1)
        fprintf(fileID, ...
            ['%.6f ', ...
            '%.6f ', ...
            '%.6f ', ...
            '%.6f ', ...
            '%.6f ', ...
            '%.6f\n'], ...
            verts(i,1),verts(i,2),verts(i,3),...
            normals(i,1),normals(i,2),normals(i,3));
    end

    % Insert Faces
    dlmwrite(filename,[size(faces,2)*ones(length(faces),1),faces-1],'-append','delimiter',' ','precision',10);

% Colored Mesh or mesh with quality field
elseif nargin == 5
    
    normals = varargin{1} ;
    rgb = varargin{2};
    
    % todo: add quality option 
    
    % Insert Header
    fprintf(fileID, ...
        ['ply\n', ...
        'format ascii 1.0\n', ...
        'element vertex %u\n', ...
        'property float x\n', ...
        'property float y\n', ...
        'property float z\n', ...
        'property float nx\n', ...
        'property float ny\n', ...
        'property float nz\n', ...
        'property uchar red\n', ...
        'property uchar green\n', ...
        'property uchar blue\n', ...
        'element face %u\n', ...
        'property list uchar int vertex_indices\n', ...
        'end_header\n'], ...
        length(verts),length(faces));

    % Insert Colored Vertices
    for i=1:length(verts)
    fprintf(fileID, ...
        ['%.6f ', ...
        '%.6f ', ...
        '%.6f ', ...
        '%.6f ', ...
        '%.6f ', ...
        '%.6f ', ...
        '%u ', ...
        '%u ', ...
        '%u\n'], ...
        verts(i,1),verts(i,2),verts(i,3),...
        normals(i,1),normals(i,2),normals(i,3),...
        rgb(i,1),rgb(i,2),rgb(i,3));
    end

    % Insert Faces
    dlmwrite(filename,[size(faces,2)*ones(length(faces),1),faces-1],'-append','delimiter',' ','precision',10);

end