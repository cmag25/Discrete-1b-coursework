classdef PermutationKey
    
    %class to store and handle permutaion keys
    
    properties
        perm = (1:26) %Default value is identity permutation
    end
    
    methods
        function a = PermutationKey(p) %constructor method
            if nargin==0 %checks to see if no inputs were given
                a.perm=randperm(26); %if no inputs given, creates a random permutation
                return         
            end
                
            if isvector(p) && (length(p)==26) %checks for an invalid p
                if isnumeric(p) %the numeric case
                    for i=1:26 %checks each element of p
                        if ismember(p,i)==zeros(1,26) %checks to make sure every letter of the alphabet is accounted for
                            error("a numeric p must have every number from 1 to 26 to be a permutation")
                        end
                    end
                    a.perm=p;
                else %the character case
                    alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
                    for i=1:26
                        if ismember(p,alphabet(i))==zeros(1,26) %checks to make sure every letter is contained in p
                            error("A permutation of characters must have every upper-case letter")
                        end
                    end
                    a.perm=double(p)-64; %converts to alphabetical values for the disp method
                end
            else
                error("The permutation must be a vector with each of the 26 numbers from 1-26, or must contain one of every capital letter")
            end
        end
        
        function disp(a) %display method
            %displays a PermutationKey as a permutation of the alphabet
            %adds 64 to the permutation to get to ASCII values
            %converts to characters:
            AlphaPerm=char((a.perm)+64);
            disp(AlphaPerm)
            
        end
        
        function lom=mtimes(l,m)
            %takes two keys and gives their composition
            lom=(1:26); %sets lom (the compostion of l o m) to the defualt 
            %identity permutation
            for i=1:26
                lom(i)=l.perm(m.perm(i)); %sets the ith item of lom to the 
                %(character in the ith position of m)th postion of l 
                %this gives the correct answer
            end
            lom=PermutationKey(lom); %displays the permutation as
            %characters using the disp function
        end
        
        function inverse=invertion(K)
            %finds inverse of a key K
            inverse=(1:26);
            for i=1:26
                inverse(K.perm(i))=i; %sets the item in the (ith position
                %of K)th position to i, giving the inverse
            end
            inverse=PermutationKey(inverse); %displays inverse in terms 
            %of characters using disp function
        end
        
        function encrypted=encryption(k,m)
           %encrypts message m with key k
           upperCase=upper(m); %converts to upper case
           numerical=double(upperCase); %converts to ascii values
           numerical=numerical-64; %converts from ascii to alphabet values
            for i=1:length(m)
                if (numerical(i)>=1)&&(numerical(i)<=26) %only alters letters
                    numerical(i)=k.perm(numerical(i)); 
                    %sets the ith number of numerical to that number's
                    %position in the permutation k
                end                          
            end
           numerical=numerical+64; %converts back to ascii
           encrypted=char(numerical); %converts from ascii to letters           
        end
        
        function decrypted=decryption(k,m)
            %decrypts a message m with key k
            kInverse=invertion(k); %gets inverse key of k from invertion
            decrypted=encryption(kInverse,m);
            %encrypts with inverse key to get answer
        end
        
         function a=swap(a, L1, L2)            
            %swaps two characters in the current key
            L1=double(L1)-64; %alphabetical value of letter 1
            L2=double(L2)-64; %alphabetical value of letter 2
            if ((L1>=1)&&(L1<=26))&&((L2>=1)&&(L2<=26)) %checks if L1 and L2 are in the alphabet
                stored=a.perm(L1); %stores the value of L1, as this will be replaced by L2
                a.perm(L1)=a.perm(L2); %replaces the character in the position of L1 with the 
                %character in L2's position
                a.perm(L2)=stored; %sets the character in the position of L2 to the stored value of L1's character
            else
                error('The two latters must be uppercase letters of the alphabet') %for the case when either of L1 or L2 is not 
                %an upper-case letter
            end
         end
           
    end
end

