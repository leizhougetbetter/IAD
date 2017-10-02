subroutine frequencyCalculation(timesRepeated, numGraphRealization, APlayerPayoff, BPlayerPayoff)
    use global
    implicit none
    integer,intent(in)::timesRepeated, numGraphRealization
    real,intent(in)::BPlayerPayoff(numPlayerInGame)
    real,intent(inout)::APlayerPayoff(numPlayerInGame)
    !!
    !runs (generations) in one repeat
    integer::run
    !repeated times in one benefit in one realization 
    integer::indexRepeated
    integer::averageTimes      
    !
    integer::averageBeginRun
    !Output
    character(4)::timeRepeatFile
    !!!
    integer::generationNum
    integer::numA
    logical::fileExist
    character(50)::formatOutput
    !!! calculate the distribution of the num of A
    integer::numDistribution
    character(2)::strNumDistribution
    !!!
    integer::nodeChosenUpdate
    real::payoffUpdate
    !!!
    type(structuredPopulations)::networkMain(Ntotal)
    !!! First entry of the payoff matrix
    real::a0Value
    character(5)::a0Str
    !!! Distribution of the number of A players
    integer::numADist(Ntotal+1)
    !!! Random update sequence pre-set
    integer, allocatable::nodeRandUpdate(:)
    integer::numNodeRandExceedNtotal, indexNodeRandExceedNtotal
    integer::iNodeRandExceed, nodeRandReDraw(1)
    !!! Information of updating node randomly selected
    integer::degreeNodeUpdateNow, nodeUpdateNow
    integer::totalRandNumUseGame
    real, allocatable::randNumUseGame(:)
    integer:: indexRandNumUseGameBeg, indexRandNumUseGameEnd
    !!
    real, allocatable::randNumUseUpdate(:)
    
    !!!!
    !!! Total number of generations in each run
    generationNum = 2e7 + 1
    !!! Starting point of the statistics (last 1e7 time steps)
    averageBeginRun = generationNum - 1e7
    
    !!!!
    write(*,*) "For "//networkType//" Networks!"
    
    !!!! Read static networks
    call readNetwork(networkMain)
    
    !!!! Output network information
    write(*,*) "Average Degree = ", sum(degreeMain)*1.0/Ntotal
    write(*,*) "Max Degree = ", maxval(degreeMain)
    write(*,*) "Min Degree = ", minval(degreeMain)
    write(*,*)
    
    !!
    allocate(nodeRandUpdate(generationNum))
    allocate(randNumUseUpdate(generationNum))
    !!
    a0Loop: do a0Value = a0Beg, a0End, a0Gap
        write(a0Str, "(F5.2)") a0Value
        APlayerPayoff(1) = a0Value
        
                write(*,*) "----------------"
                write(*,"('  Payoff Parameters')")
                write(*,*) "A:",APlayerPayoff
                write(*,*) "B:",BPlayerPayoff
                write(*,*) "----------------"
                open(unit = 121,file = "numA_Dist"//"_a0_"//trim(adjustl(a0Str)))
                !!!
                !!!
                timeRepeatedOneRealization:do indexRepeated=1, timesRepeated
                    write(timeRepeatFile,"(I4)")  indexRepeated
                    write(*,*) "-------------------"
                    write(*,*) "Repeat = "//timeRepeatFile
                    
                    numADist = 0
                    !-------Initialize strategies-------!
                    call Inital_strategies_not_equal()
                    !
                    numA = sum(strategyPGG)
                    !
                    run = 0
                    !reset runs   
                    run = 1
                    averageTimes = 0
        
                    numDistribution = 1
                    !!!
                    nodeRandUpdate = -1
                    !! All the randomly chosen nodes 
                    call RNUND(Ntotal, nodeRandUpdate)
                    if(any(nodeRandUpdate > Ntotal))then
                        !write(*,*) "Updated Nodes exceed Population size -- ReDraw!!"
                        numNodeRandExceedNtotal = count(nodeRandUpdate > Ntotal)
                        !write(*,*) "numNodeRandExceedNtotal", numNodeRandExceedNtotal
                        !!! redraw the nodes that exceed population size
                        do iNodeRandExceed = 1, numNodeRandExceedNtotal
                            indexNodeRandExceedNtotal = maxloc(nodeRandUpdate, dim=1)
                            call RNUND(Ntotal, nodeRandReDraw)
                            nodeRandUpdate(indexNodeRandExceedNtotal) = nodeRandReDraw(1)
                        end do
                    end if
                    if(any(nodeRandUpdate > Ntotal))then
                        write(*,*) "Updated Nodes Still exceed Population size!!"
                        pause
                    end if                    
                    !!
                    !! All the random numbers used in selecting the game opponents
                    totalRandNumUseGame = sum(degreeMain(nodeRandUpdate))
                    !write(*,*) "totalRandNumUseGame", totalRandNumUseGame
                    !pause
                    allocate(randNumUseGame(totalRandNumUseGame))
                    call RNUN(randNumUseGame)
                    !! All the random numbers used in the updating
                    randNumUseUpdate = -1.0
                    call RNUN(randNumUseUpdate)
                    !!!
                    indexRandNumUseGameBeg = 1
                    !!
                    generationLoop:do while(run <= generationNum)
                        !!! ---------------------------- !!!
                        !!! ------Game and Update------- !!!
                        nodeUpdateNow = nodeRandUpdate(run)
                        degreeNodeUpdateNow = degreeMain(nodeUpdateNow)
                        !!
                        indexRandNumUseGameEnd = indexRandNumUseGameBeg + degreeNodeUpdateNow - 1
                        !!
                        call PGG_OnlyFocalNode_AnyGraph(APlayerPayoff,BPlayerPayoff,nodeUpdateNow,degreeNodeUpdateNow, randNumUseGame(indexRandNumUseGameBeg:indexRandNumUseGameEnd), payoffUpdate, networkMain)
                        indexRandNumUseGameBeg = indexRandNumUseGameEnd + 1
                        !!
                        call AspirationUpdate(nodeUpdateNow, payoffUpdate, randNumUseUpdate(run))
                        !!------------------------------!!
                        numA = sum(strategyPGG)
                        !!
                        if(run > averageBeginRun)then
                            !!! 1 sample every 10 steps, Buffer size = 10
                            !!! Sample period: last 1e7 time steps
                            if(mod(run-averageBeginRun, 10) == 1)then
                                numADist(numA + 1) = numADist(numA + 1) + 1
                            end if
                        end if
                        
                        run = run + 1
                    end do generationLoop
                    !!! record the distribution over the last 1e7 time steps for 100 independent repetitions
                    write(121,"(101(1X,I8))") numADist
                    !!
                    deallocate(randNumUseGame)
                    !!!
                end do timeRepeatedOneRealization
                close(121)
                
    end do a0Loop
    deallocate(nodeRandUpdate)
    deallocate(randNumUseUpdate )
    return 
end subroutine frequencyCalculationSampleBuffer