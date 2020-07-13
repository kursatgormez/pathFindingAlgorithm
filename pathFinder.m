
%% 1 pre-map settings

% a and b must be added
way = zeros(100,200);
way(1,1) = 1;
[targetx,targety,map] = rand_Map_Tar(); %% used in tests

path = direct_Path(targetx,targety);
curx = 1 ;
cury = 1 ;

%% 2 main while
while (targetx ~= curx) || (targety ~= cury)

    [curx,cury] = opt_Borders(curx,cury);
    
     if (map(curx+1,cury+1) == 0) || (map(curx,cury+1) == 0) || (map(curx+1,cury) ==0) || curx==99 ||curx==0||cury==0||cury==199
     
         while way(curx,cury) ~= path(curx,cury)
             [curx,cury] = opt_Borders(curx,cury);
             eye = get_Eye(curx,cury,map);
                 
             if curx == 99|| cury==199 || curx == 2 || cury==2
                     flag = 0;

                    while flag ~= 2
                        eye = get_Eye(curx,cury,map);
                        [curx,cury,way]= go_Right(curx,cury,way,eye);

                        if way(curx,cury) == path(curx,cury)
                            flag = flag+1;
                        end
%                          spy(way,"b*");
                         
                    end
                    break;    
            end

            [curx,cury,way]= go_Left(curx,cury,way,eye); 
%              spy(way,"b*");
             
         end
     end
     
     [curx,cury,way] = go(curx,cury,targetx,targety,way);
%      spy(way,"b*"); 


     
end

%% 3 plots
printmap = ones(100,200);
printway = zeros(100,200);
printpath = zeros(100,200);


printmap(100:-1:1,:) = map ;
printway(100:-1:1,:) = way ;
printpath(100:-1:1,:) = path ;

% figure(1);
clf
spy(printmap);
hold on
spy(printpath,"r*");
spy(printway,"k*");
set(gca,'YtickLabel',100:-20:0)


%% 4 functions
function path = direct_Path(targetx,targety) % direct path generated
    
    path = zeros(100,200);
    path(targetx,targety) = 1;
    curx = 1 ;
    cury = 1 ;
    
    while (targetx ~= curx) || (targety ~= cury)

        if(targetx ~= curx) && (targety ~= cury) 
            curx = curx+1;
            cury = cury+1;
        elseif(targety ~= cury)
            cury = cury+1;
        elseif (targetx ~= curx)
            curx = curx+1;
        end

        path(curx,cury) = 1;
        
%         spy(path,"r*");

    end
    
    
    
end

function [tx,ty,map] = rand_Map_Tar() % random map and target generated

    
    map = ones(100,200);
    posx = randperm(50); %1 50 aras? rastgele sayi
    posy = randperm(150); %1 150 aras? rastgele sayi

    for x = 4:10 
        map(posx(x):posx(x)+5*x,posy(x):posy(x)+5*x) = 0; % rastgele kareler
    end

        while 1

            tx = mod(round(rand(1)*1000),98)+1;
            ty = mod(round(rand(1)*1000),198)+1;

            if (map(tx,ty) == 1)
                break;
            end
            
        end

%         spy(map); % binary matrix çizdirme
%         hold on
        
end

function eye = get_Eye(curx,cury,map) % eye sees the obstacles
    
    eye(1:8) = 0;
    
    if map(curx,cury+1)==0
        eye(2) = 1;
    end
    if map(curx+1,cury) ==0
        eye(4) = 1;
    end
    if map(curx,cury-1) ==0
        eye(6) = 1;
    end
    if map(curx-1,cury) == 0
        eye(8) = 1;
    end
    if map(curx-1,cury+1) == 0
        eye(1) = 1;
    end
    if map(curx+1,cury+1) == 0
     eye(3) = 1;
    end
    if map(curx+1,cury-1) == 0
        eye(5) = 1;
    end
    if map(curx-1,cury-1) == 0
        eye(7) = 1;  
    end
    
end

function [curx,cury] = opt_Borders(curx,cury) %for not exceed borders%
    
    if curx==1
        curx=2;
    end
    if cury==1
        cury=2;
    end
    if curx==100
        curx=99;
    end
    if curx==200
        curx=199;
    end
    
end

function [curx,cury,way]= go_Left(curx,cury,way,eye) % go only left on osbtacle
    pause(0.01)    
    if (eye(2) && eye(3) && eye(4))
        curx = curx-1;
    elseif eye(4) && eye(5) && eye(6)
        cury = cury+1;
    elseif eye(6) && eye(7) && eye(8)
        curx = curx+1;
    elseif eye(8) && eye(1) && eye(2)
        cury = cury-1;
    elseif eye(2)
        curx = curx-1;
    elseif eye(4)
        cury = cury+1;
    elseif eye(6)
        curx = curx+1;
    elseif eye(8)
        cury = cury-1;
    elseif eye(3)
        cury = cury+1;
    elseif eye(5)
        curx = curx+1;
    elseif eye(7)
        cury = cury-1;
    elseif eye(1)
        curx = curx-1;
    end
    
    way(curx,cury) = 1;
    
end

function [curx,cury,way]= go_Right(curx,cury,way,eye) %% go only right on osbtacle
    pause(0.01)
    if (eye(2) && eye(3) && eye(4))
        cury = cury-1;
    elseif eye(4) && eye(5) && eye(6)
        curx = curx-1;
    elseif eye(6) && eye(7) && eye(8)
        cury = cury+1;
    elseif eye(8) && eye(1) && eye(2)
        curx = curx+1;
    elseif eye(2)
        curx = curx+1;
    elseif eye(4)
        cury = cury-1;
    elseif eye(6)
        curx = curx-1;
    elseif eye(8)
        cury = cury+1;
    elseif eye(3)
        curx = curx+1;
    elseif eye(5)
        cury = cury-1;
    elseif eye(7)
        curx = curx-1;
    elseif eye(1)
        cury = cury+1; 
    end 
    
    way(curx,cury) = 1;
    
end

function [curx,cury,way] = go(curx,cury,targetx,targety,way) % go on direct path
    
    way(curx,cury) = 1; %current way indices
    
    if(targetx ~= curx) && (targety ~= cury) %moving on direct path
        curx = curx+1;
        cury = cury+1;
    elseif(targety ~= cury) %moving on direct path on Y
        cury = cury+1;
    elseif (targetx ~= curx) %moving on direct path on X
        curx = curx+1;
    end
  
end
