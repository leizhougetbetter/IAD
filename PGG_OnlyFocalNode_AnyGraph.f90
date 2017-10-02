subroutine PGG_OnlyFocalNode_AnyGraph(APlayerPayoff,BPlayerPayoff,nodeChosenUpdate,degreeNodeChosen, randNeighChoseNew, payoffUpdate, networkMain)
    use global
    implicit none
    real,intent(in)::APlayerPayoff(numPlayerInGame)
    real,intent(in)::BPlayerPayoff(numPlayerInGame)
    type(structuredPopulations),intent(in)::networkMain(Ntotal)
    integer,intent(in)::nodeChosenUpdate
    integer, intent(in):: degreeNodeChosen
    !!!!
    real, intent(in)::randNeighChoseNew(degreeNodeChosen)
    !!! Output the payoff of individuals
    real,intent(out)::payoffUpdate
    !!!
    integer,allocatable::gameNeighChosen(:), indexGameNeighChosen(:)
    real::randNeighChosenGamePlay(degreeNodeChosen)
    !!!
    integer::indexSelect, numSelect
    integer::numAlreadySelect
    !!
    integer::numAnodeUpdatePGG, numANeighborPGG
    real::randNodeUpdate
    integer::nodeNeighNow, indexNeigh
    integer::strategyUpdateNode, strategyNeighNode

    strategyUpdateNode = strategyPGG(nodeChosenUpdate)
    !
    !
    payoffUpdate = 0.0
    
    !!! # of A opponents
    allocate(gameNeighChosen(numPlayerInGame - 1))
    gameNeighChosen = 0
    !!!!
    !!!! Choose a subset of the random permutation of the index of neighbors
    randNeighChosenGamePlay = randNeighChoseNew
    allocate(indexGameNeighChosen(numPlayerInGame - 1))

    numSelect = 0
    do while(numSelect < numPlayerInGame - 1)
        numSelect = numSelect + 1
        !!!! Function minloc() returns the index of the minimum value in the array
        indexGameNeighChosen(numSelect) = minloc(randNeighChosenGamePlay, dim=1)
        randNeighChosenGamePlay(indexGameNeighChosen(numSelect)) = 10.0
    end do    
    gameNeighChosen = networkMain(nodeChosenUpdate)%neighborNode(indexGameNeighChosen)
    
    !write(*,*) "gameNeighChosen", gameNeighChosen
    !pause
    if(numSelect < numPlayerInGame - 2)then
        write(*,*) "Not enough Random Neighbors!!"
        stop
    end if
    !!!
    !!!
    !write(*,*) "Current Neighbors of the Focal Node"
    !write(*,*) networkMain(nodeChosenUpdate)%neighborNode
    !write(*,*) "Neighbors selected to play Game with"
    !write(*,*) gameNeighChosen
    !pause
    !!!
    
    !!!! Calculate the number of A co-players and the payoff
    numAnodeUpdatePGG = sum(strategyPGG(gameNeighChosen))
    if(strategyUpdateNode == 1)then
        !!!! Zero A co-players corresponds to index 1 of the array
        payoffUpdate = payoffUpdate + APlayerPayoff(numAnodeUpdatePGG + 1)
    else
        payoffUpdate = payoffUpdate + BPlayerPayoff(numAnodeUpdatePGG + 1)
    end if
    !!!
    !write(*,*) "Payoff Check"
    !write(*,*) "Payoff of Node Update"
    !write(*,*) payoffUpdate
    !write(*,*) "Strategy Update Node"
    !write(*,*) strategyUpdateNode
    !write(*,*) "num of A opponents in a PGG"
    !write(*,*) numAnodeUpdatePGG
    !write(*,*) "num of Chosen Neigh in a PGG"
    !write(*,*) numNeighChosen
    !pause
    !pause
    !
    deallocate(gameNeighChosen, indexGameNeighChosen)
   
    return
end subroutine PGG_OnlyFocalNode_AnyGraph