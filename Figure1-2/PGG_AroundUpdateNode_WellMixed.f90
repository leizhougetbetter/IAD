subroutine PGG_AroundUpdateNode_WellMixed(APlayerPayoff,BPlayerPayoff,nodeChosenUpdate,payoffUpdate)
    use global
    implicit none
    real,intent(in)::APlayerPayoff(numPlayerInGame)
    real,intent(in)::BPlayerPayoff(numPlayerInGame)
    integer,intent(in)::nodeChosenUpdate
    real,intent(out)::payoffUpdate
    !!
    integer::numAnodeUpdatePGG
    real::randNodeUpdate
    integer::nodeNeighArray(1)
    integer::nodeNeigh, numNeighChosen
    integer::availableNeigh(Ntotal), availableNeighNow(Ntotal)
    integer::strategyUpdateNode
    integer::avgTimesPGG, indexPGG
    
    ! Compute the payoff of the node Chosen For Update
    availableNeigh = 1
    availableNeigh(nodeChosenUpdate) = 0
    strategyUpdateNode = strategyPGG(nodeChosenUpdate)
    !
    !!! Only one game 
    avgTimesPGG = 1
    !
    payoffUpdate = 0.0
    do indexPGG = 1,  avgTimesPGG
        availableNeighNow = availableNeigh
        numAnodeUpdatePGG = 0
        numNeighChosen = 0
        do while(numNeighChosen < numPlayerInGame - 1)
            call RNUND(Ntotal, nodeNeighArray)
            nodeNeigh = nodeNeighArray(1)
            if(availableNeighNow(nodeNeigh) == 1)then
                numAnodeUpdatePGG = numAnodeUpdatePGG + strategyPGG(nodeNeigh)
                numNeighChosen = numNeighChosen + 1
                availableNeighNow(nodeNeigh) = 0
            end if
        end do
        if(strategyUpdateNode == 1)then
            payoffUpdate = payoffUpdate + APlayerPayoff(numAnodeUpdatePGG + 1)
        else
            payoffUpdate = payoffUpdate + BPlayerPayoff(numAnodeUpdatePGG + 1)
        end if
    end do
    payoffUpdate = payoffUpdate / avgTimesPGG
   !!!!
    return
end subroutine PGG_AroundUpdateNode_WellMixed