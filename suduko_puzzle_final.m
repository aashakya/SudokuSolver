% Aakrista Shakya
% Tutorial 5
% Problem 3
% The purpose of this code is to solve suduko puzzle
clear all
close all
clc
% Enter or load the unfinished puzzle (represent empty spaces with zeros)
puzzle=load('puzzle_c.csv');
% Create an array of the option that must fill each nonet, row, and column
opts=1:9;
diary('tutorial_2b')

% Continuously attempt to place numbers in the puzzle until it is filled
contin=1;
while contin==1
    % Look at each nonet(each 3x3 sub-grid in the larger suduko grid), one at a
    placement_count=0;
    for n=1:9
        % time
        % Within the current nonet, determine the positions of the empty spaces (if
        % there are any)
        % Within the current nonet, determine what numbers are missing
        
        % Determine the row indices for the current nonet
        if n==1|n==2|n==3
            nonet_row_inds=1:3;
        elseif n==4|n==5|n==6
            nonet_row_inds=4:6;
        else
            nonet_row_inds=7:9;
        end
        
        %Determine the column indices for the current nonet
        if n==1|n==4|n==7
            nonet_col_inds=1:3;
        elseif n==2|n==5|n==8
            nonet_col_inds=4:6;
        else
            nonet_col_inds=7:9;
        end
        % Extract the nonet from the puzzle
        nonet=puzzle(nonet_row_inds, nonet_col_inds);
        % Use a logical statement to determine the indices where the numbers are
        % greater than zero
        nonzero_indices=nonet>0;
        % Extract the non-zero values from the nonet variable using the
        % nonzero_indices variable
        nonzeros_in_nonet=nonet(nonzero_indices);
        % Determine the indices of the elements from the "opts" array that ARE
        %found in the "nonzeros_in_nonet" array.
        indices_of_numbers_in_nonet=ismember(opts,nonzeros_in_nonet);
        % Use the not operator(~) to determine the indices of the elements of "opts"
        % that are NOT found in the "nonzeros_in_nonet" array
        indices_of_numbers_NOT_in_nonet=~indices_of_numbers_in_nonet;
        % Extract the number that are not in the nonet from the opts array using
        % the indices_of_numbers_NOT_in_nonet array
        nonet_options=opts(indices_of_numbers_NOT_in_nonet);
        
        for k=1:length(nonet_options)
           pairs=find_empty_inds(puzzle, nonet_col_inds, nonet_row_inds);
            % Iterate over the rows of the current nonet
            for m=nonet_row_inds
                % Extract the entire row from the puzzle
                r=puzzle(m,:);
                % Check to see if the current value of nonet_options is in the row
                if ismember(nonet_options(k),r)
                    % If the current number is in the row, remove all pairs with that row
                    
                    % Extract the indices in the first column of "pairs"(i.e. the row indices)
                    % that are not equal to the index of the current row, m
                    pair_inds=pairs(:,1)~=m;
                    % Redefine the pairs array based on the updated indices
                    pairs=pairs(pair_inds,:);
                end
            end
            % Iterate over the columns of the current nonet
            for m=nonet_col_inds
                % Extract the entire column from the puzzle
                c=puzzle(:,m);
                % Check to see if the current value of nonet_options is in the column
                if ismember(nonet_options(k),c)
                    % If the current number is in the column,
                    % remove all pairs with that column
                    
                    % Extract the indices in the second column of "pairs" (i.e., the
                    % column indices) that are not equal to the index of the current
                    % column,m
                    pair_inds=pairs(:,2)~=m;
                    
                    % Redefine the pairs array based on the updated indices
                    pairs=pairs(pair_inds,:);
                end
            end
            % Determine the number of rows in the pairs array
            [n_pairs,~]=size(pairs);
            % Use a conditional statement to see if only one position is available
            if n_pairs==1
                placement_count=placement_count+1;
                % Extract the indices for the row and column if there is only one
                % position
                r_ind=pairs(1);
                c_ind=pairs(2);
                
                % Place the current option at the correct position in the puzzle
                puzzle(r_ind,c_ind)=nonet_options(k);
            end
        end
        
        pairs=find_empty_inds(puzzle,nonet_col_inds, nonet_row_inds);
     
        [n_pairs,~]=size(pairs);
        for k=1:n_pairs
            % Extract the index of the row for the current position
            r_ind=pairs(k,1);
            % Extract the row from the puzzle based on the row index
            r=puzzle(r_ind,:);
            
            % Extract the index of the column for the current position
            c_ind=pairs(k,2);
            % Extract the column from the puzzle based on the column index
            c=puzzle(:,c_ind);
            
            % Determine the indices of the elements in nonet_options that are not in
            % the row
            not_in_row_inds=~ismember(nonet_options,r);
            % Determine the elements in nonet_options that are not in the row
            not_in_row=nonet_options(not_in_row_inds);
            
            % Determine indices of elements of not_in_row that are not in the column
            not_in_row_or_col_inds=~ismember(not_in_row,c);
            % Determine the elements from not_in_row that are not in the column
            not_in_row_or_column=not_in_row(not_in_row_or_col_inds);
            
            % Place a number if only one number remains after the elimination above
            if length(not_in_row_or_column)==1
                placement_count=placement_count+1;
                puzzle(r_ind,c_ind)=not_in_row_or_column;
            end
            
        end
        
        % At each empty position in the nonet, determine what numbers could fill
        % that position based on the other numbers in the nonet
        % Check to see if any of the possible numbers at the empty position can be
        % found in the same row or column as the current empty postion
    end
    
    % After attempting to place numbers in each nonet, check to see if the
    % puzzle is completely filled
    
    % If the puzzle is filled, stop attempting to place numbers
    if placement_count==0
        contin=0; % Stop the while loop if no new numbers are placed
    end
end
% Show the completed puzzle
puzzle
% Open a file to save the solved puzzle
fid=fopen('solved_puzzle_c.csv','w');

% Write the puzzle variable to the file
save solved_puzzle_c.csv puzzle -ascii

% Close the file
fclose(fid);
save('sudoku_puzzle_solver');
