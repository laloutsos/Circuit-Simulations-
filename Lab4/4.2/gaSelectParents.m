1;
function [parent1, parent2, score1, score2] = gaSelectParents(scores, population, N, L)
best = -1; sbest = -1;
besti = -1; sbesti = -1;

for i = 1:N
    if scores(i) > best
        sbest = best;
        best = scores(i);
        sbesti = besti;
        besti = i;
    elseif scores(i) >= sbest
        sbest = scores(i);
        sbesti = i;
    end
end

% Ensure parent1 and parent2 are not the same
if besti == sbesti
    warning('Best and second-best are the same. Selecting second-best randomly.');
    sbesti = randi([1,N]);
    while sbesti == besti
        sbesti = randi([1,N]);
    end
end

parent1 = population{besti};
parent2 = population{sbesti};
score1 = best;
score2 = sbest;
end

