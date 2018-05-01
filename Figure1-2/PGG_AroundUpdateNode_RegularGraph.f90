subroutine PGG_AroundUpdateNode_RegularGraph(APlayerPayoff,BPlayerPayoff,nodeChosenUpdate,payoffUpdate, networkMain)
    use global
    implicit none
    real,intent(in)::APlayerPayoff(numPlayerInGame)
    real,intent(in)::BPlayerPayoff(numPlayerInGame)
    type(structuredPopulations),intent(in)::networkMain(Ntotal)
    integer,intent(in)::nodeChosenUpdate
    real,intent(out)::payoffUpdate
    !!
    integer::numAnodeUpdatePGG, numANeighborPGG
    integer::nodeNeighNow, indexNeigh
    integer::strategyUpdateNode, strategyNeighNode
    
    ! Compute the payoff of the node Chosen For Update 
    strategyUpdateNode = strategyPGG(nodeChosenUpdate)
    !
    payoffUpdate = 0.0
    
    !!! # of A opponents
    numAnodeUpdatePGG = sum(strategyPGG(networkMain(nodeChosenUpdate)%neighborNode))
    
    !!! calculate the payoff of the focal game
    if(strategyUpdateNode == 1)then
        payoffUpdate = payoffUpdate + APlayerPayoff(numAnodeUpdatePGG + 1)
    else
        payoffUpdate = payoffUpdate + BPlayerPayoff(numAnodeUpdatePGG + 1)
    end if
    
    !write(*,*) "nodeChosenUpdate", nodeChosenUpdate
    !pause
    
    if(payoffCollectType == 0)then
        !!! only Single focal game is considered
        return
    end if
    
    
    !!!! Calculating the payoffs of games organized by neighbors
    do indexNeigh = 1, degreeMain
        nodeNeighNow = networkMain(nodeChosenUpdate)%neighborNode(indexNeigh)
        strategyNeighNode = strategyPGG(nodeNeighNow)
        !!! # of A opponents of the Update Node
        numANeighborPGG = strategyNeighNode + sum(strategyPGG(networkMain(nodeNeighNow)%neighborNode)) - strategyUpdateNode
        if(strategyUpdateNode == 1)then
            payoffUpdate = payoffUpdate + APlayerPayoff(numANeighborPGG + 1)
        else
            payoffUpdate = payoffUpdate + BPlayerPayoff(numANeighborPGG + 1)
        end if
    end do
    !!!! accumulated payoff (default)
    !!!! average payoff
    payoffUpdate = payoffUpdate / (degreeMain + 1)
   
    return
end subroutine PGG_AroundUpdateNode_RegularGraph