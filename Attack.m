classdef Attack
    
    %A class used to attack Permutation ciphers
    
    properties
        ciphertext %the encrypted text
        key %the key we use to decrypt ciphertext
        past %the previous two letters swapped in the key (if any)
    end
    
    methods
        function a = Attack(message) %constructor method
            %takes an encrypted message and stores as the ciphertext
            %property
            a.ciphertext=message; 
            a.key=PermutationKey((1:26)); %default value of the key is the identity permutation
            a.past=[]; %initialises "past" with the empty list
        end
        
        function disp(a) %display method
            %displays the current key followed by the first 300 characters 
            %of the ciphertext decrypted with the current key
            disp(['The stored key is the following:',13,]) %,13, creates a linebreak
            disp(a.key)
            decryptedmessage=decryption(a.key, a.ciphertext);%decrypts using the decryption function in PermutationKey
            if length(decryptedmessage) <= 300 %set number of repeats to avoid exceeding array elements
                repeats= length(decryptedmessage);
            else
                repeats=300; %we only want the first 300 characters
            end
            disp([13,'Up to the first 300 characters of the message decrypted with "key" are:',13,])
            if length(a.ciphertext)<81 %for short ciphertexts
                disp(decryptedmessage) %displays all of it since it's length is less than or equal to our chosen row length (80)
            else
                for i=81:80:repeats
                    disp([decryptedmessage(i-80:i),13,])      %displays 80 characters of  the message, then the next 50 on a new line   
                end
                disp(decryptedmessage(i+1:repeats)) %displays the remaining characters of the decrypted message, the #characters left
                %will be length(decryptedmessage) mod 50      
            end
        end
        
        function frequencies=lettercount(a)
            numerical=double(a.ciphertext); %converts the cipher text to ascii values
            numerical=numerical-64; %converts to alphabetical values
            frequencies=zeros(1,26); %creates an array to store # of occurunces of letters, initially this is just 26 zeros
            for i=1:length(numerical) %looks at each element of the numerical ciphertext
                if (numerical(i)>=1)&&(numerical(i)<=26) %only alters letters
                    frequencies(numerical(i))=frequencies(numerical(i))+1; %adds 1 to the value at the position in "frequencies" 
                    %that corresponds to that letter          
                end          
            end           
        end
        
        function a=attack(a)
            %carries out a frequency attack to try and guess a key based on a giiven message          
            letterRarity=('ZQXJKVBPYGFWMUCLDRHSNIOATE'); %the given list of rarities of letter in english from most to least rare
            letterRarity=double(letterRarity)-64; %converts to alphabetical values (1:26)
            letterFrequency=lettercount(a); %uses "lettercount" to work out the frequency of letters in the message
            letterFrequency=permutation(letterFrequency); %uses permutation function to return the matching permutation
            newKey=(1:26); %creates a variable to store our new key, it's values here don't matter
            for i=1:26
                newKey(letterRarity(i))=letterFrequency(i); %creates the new key by matching the frequencies of letters in the code with
                %their frequency in the english language
            end
            a.past=[]; %removes undo info
            a.key=PermutationKey(newKey); %changes the key to the new one
        end
        
        function chosenSample=sample(a)
            %takes a random 300 character sample of ciphertext and decrypts
            %with the current key
            sampleStart=length(a.ciphertext)-300; %picks a random start point more than 300 characters away from the endpoint of ciphertext 
            if sampleStart<1 %occurs when the length of the ciphertext is less than or equal to 300
                sampleStart=1;
                sampleEnd=length(a.ciphertext); %can only take a sample up to as long as the ciphertext
            else %for a ciphertext of lenght greater than 300
                sampleStart=randi(sampleStart); %picks start of sample
                sampleEnd=sampleStart+300; %picks end of sample
            end
            chosenSample=a.ciphertext(sampleStart:sampleEnd); %acquires the sample from the ciphertext
            chosenSample=decryption(a.key, chosenSample); %decrypts sample            
        end
        
         function a=swap(a, L1, L2)
             %swaps two characters in the current key
             a.past=[L1,L2];
             a.key=a.key.swap(L1,L2); %swaps the two letters using the swap function in PermutationKey
                                     
         end
        
         function a=undo(a)
             if isempty(a.past) %checks if past is empty
                 disp('There is no undo information') %does nothing if "past" is empty
                 return
             else
                 a=a.swap(a.past(1),a.past(2)); %swaps the two letters in "past" back again
             end             
         end
         
         
         %%%%%%%%%%%%The given permutation function (used in the attack method)%%%%%%%%% 
         % Given the letter counts as an array B, return the matching permutation of
           % 1 to 26.
        function A = permutation(B)

            A = msort( [B ; 1:length(B)] );
            A = A(2,:);

        end

        % Merge sort
        function b = msort(a)

            % Number of columns
            n = size(a, 2);

            if n <= 1
                % Base case: length 1 arrays are sorted
                b = a;
            else
                % Recursive step: split input in two halves
                a1 = a(:, 1:floor(n/2));
                a2 = a(:, floor(n/2)+1:n);

                % Sort halves recursively and merge
                b = merge(msort(a1), msort(a2));
            end
        end

        % Merge
        function c = merge( a,b )

            % Pre-allocate for number of rows
            c = zeros(2, size(a,2) + size(b,2));

            % Initialize array indices
            i = 1 ; j = 1 ; k = 1 ;

            % Repeat while both a and b have elements remaining
            while i <= size(a,2) && j <= size(b,2)
                % Find larger of both "next" elements
                if a(1,i) < b(1,j)
                    % Put column from a onto c
                    c(:,k) = a(:,i) ; i = i+1 ; k = k+1 ;
                else
                    % Put column from b onto c
                    c(:,k) = b(:,j) ; j = j+1 ; k = k+1 ;
                end
            end

            % Copy remainder of a (if any)
            while i <= size(a,2)
                c(:,k) = a(:,i) ; i = i+1 ; k = k+1 ;
            end

            % Copy remainder of b (if any)
            while j <= size(b,2)
                c(:,k) = b(:,j) ; j = j+1 ; k = k+1 ;
            end

        end
            
        
    end
end

