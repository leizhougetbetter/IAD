subroutine PGG_OnlyFocalNode_AnyGraph_New(APlayerPayoff,BPlayerPayoff,nodeChosenUpdate,degreeNodeChosen, payoffUpdate, networkMain)
    use global
    implicit none
    real(8),intent(in)::APlayerPayoff(numPlayerInGame)
    real(8),intent(in)::BPlayerPayoff(numPlayerInGame)
    type(structuredPopulations),intent(in)::networkMain(Ntotal)
    integer,intent(in)::nodeChosenUpdate
    integer, intent(in):: degreeNodeChosen
    integer::randPermuationNeighIndex(degreeNodeChosen)
    real(8),intent(out)::payoffUpdate
    !!!
    integer::gameNeighChosen(numPlayerInGame - 1)
    integer::indexGameNeighChosen(numPlayerInGame - 1)
    !!
    integer::numAnodeUpdatePGG
    integer::strategyUpdateNode
 
    strategyUpdateNode = strategyPGG(nodeChosenUpdate)
    !
    !
    payoffUpdate = 0
    
    !!! ---------- newly modified 2018-1-8 using random permutation ----------!!!
    gameNeighChosen = 0
    indexGameNeighChosen = 0
    randPermuationNeighIndex = 0
    
    call RNPER(randPermuationNeighIndex)
    indexGameNeighChosen = randPermuationNeighIndex(1:(numPlayerInGame - 1))
    
    
    if(any(indexGameNeighChosen < 1))then
        !!! there are possibilities that the elements of randPermuationNeighIndex being zero
        !!! if this happens, permutate again.
        call RNPER(randPermuationNeighIndex)
        indexGameNeighChosen = randPermuationNeighIndex(1:(numPlayerInGame - 1))
    end if
    
    gameNeighChosen = networkMain(nodeChosenUpdate)%neighborNode(indexGameNeighChosen)
    
    numAnodeUpdatePGG = sum(strategyPGG(gameNeighChosen))
    if(strategyUpdateNode == 1)then
        payoffUpdate = payoffUpdate + APlayerPayoff(numAnodeUpdatePGG + 1)
    else
        payoffUpdate = payoffUpdate + BPlayerPayoff(numAnodeUpdatePGG + 1)
    end if
   
    return
end subroutine PGG_OnlyFocalNode_AnyGraph_New