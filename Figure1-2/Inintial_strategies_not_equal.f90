subroutine Inital_strategies_not_equal()
    use global
    implicit none
    !randomly assign arbitrary proportion of cooperators
    !
    integer::i
    real::randCooperator, randCooperatorArray(1)
    
    strategyPGG = 0
    do i = 1, Ntotal
        call RNUN(randCooperatorArray)
        randCooperator = randCooperatorArray(1)
        if(randCooperator < initialFrequencyA)then
            strategyPGG(i) = 1
        end if
    end do
    
    !stop
    return 
end subroutine Inital_strategies_not_equal