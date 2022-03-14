% xcpd2dcanmotion.m
% Usage: xcpd2dcanmotion(inFile,outDir), where inFile is an XCP-D "*.-DCAN.hdf5" motion data file
% Outputs a motion data file in DCANBOLDProc "*_power_2014_FD_only.mat" format  
% Tested with hdf5 output of XCP-D unstable03112022a (commit 24e15c582e5dc193565aacb5fdfedf4b04253421)

function xcpd2dcanmotion(inFile,outDir)

% get h5info on FD groups (one group per FD increment)
h5i = h5info(inFile,'/dcan_motion');

% get total number of FD increments
ngroups = size(h5i.Groups,1);

% motion data cell array in DCANBOLDProc format
motion_data = cell(1,ngroups);

% loop over FDs 
% copy fields from hdf5 into temp struct then add to motion_data
for i = 1:ngroups 
fdgroup = string(h5i.Groups(i).Name);
tmpstruct = struct();
tmpstruct.skip = h5read(inFile,fdgroup + '/skip');
tmpstruct.FD_threshold = h5read(inFile,fdgroup + '/threshold');
tmpstruct.frame_removal = h5read(inFile,fdgroup + '/binary_mask');
tmpstruct.total_frame_count = h5read(inFile,fdgroup + '/total_frame_count');
tmpstruct.remaining_frame_count = h5read(inFile,fdgroup + '/remaining_total_frame_count');
tmpstruct.remaining_seconds = h5read(inFile,fdgroup + '/remaining_seconds');
tmpstruct.remaining_frame_mean_FD = h5read(inFile,fdgroup + '/remaining_frame_mean_FD');
motion_data{1,i} = tmpstruct;
end

% save to file
[filepath,name,ext] = fileparts(inFile);
outFile = strcat(outDir,'/',name,'_power_2014_FD_only.mat')
save(outFile,'motion_data')
