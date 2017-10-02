subroutine Inital_strategies_not_equal()
    use global
    implicit none
    !randomly selected a percentage of individuals as cooperators initially
    integer::indexC(NINT(initialFrequencyA * Ntotal))
    !the nodes(index) that initially are cooperators 
    integer::indexTotal(Ntotal)
    integer::indexCount
    !loop parameters
    integer::i, j
    !random number
    real:: randReal
    integer::randIntegerArray(1)
    integer::randInteger
    !!!
    !!!!!
    if(mod(Ntotal,2) /= 0)then
        write(*,*) "The size of population is not multiples of 2!!"
        stop
    end if
    
    do i = 1, Ntotal
        indexTotal(i) = i
    end do
    !
    indexCount = 1

    ! A players
    do while (indexCount <= NINT(initialFrequencyA * Ntotal))
        call RNUND(Ntotal, randIntegerArray)
        randInteger = randIntegerArray(1)
        if(indexTotal(randInteger) /= -1)then
            indexC(indexCount) = randInteger
            indexCount = indexCount + 1
            indexTotal(randInteger) = -1
        end if
    end do
    
    !set the strategy arrary
    strategyPGG = 0 
    do j = 1, NINT(initialFrequencyA * Ntotal)
        ! A player
        strategyPGG(indexC(j)) = 1
    end do

    !write(*,*) "Initial frequency of A:", sum(strategyPGG) * 1.0 / Ntotal
    !pause
    return
    end subroutine Inital_strategies_not_equal