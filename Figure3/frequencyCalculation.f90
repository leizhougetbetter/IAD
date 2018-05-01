subroutine frequencyCalculation(timesRepeated, APlayerPayoff, BPlayerPayoff)
    use global
    implicit none
    integer,intent(in)::timesRepeated
    real(8),intent(in)::BPlayerPayoff(numPlayerInGame)
    real(8),intent(inout)::APlayerPayoff(numPlayerInGame)
    !runs (generations) in one repeat
    integer::run
    !repeated times in one benefit in one realization 
    integer::indexRepeated
    !Output
    character(4)::timeRepeatFile
    character(5)::strEta
    !!!
    integer::generationNum
    integer::numA
    !!!
    integer::nodeChosenUpdate
    real(8)::payoffUpdate
    !!!
    type(structuredPopulations)::networkMain(Ntotal)
    !!!
    real(8)::a0Value, yValue, zValue
    character(5)::xStr, yStr, zStr
    integer(kind=8)::numADist(Ntotal+1)
    !!!
    integer, allocatable::nodeRandUpdate(:)
    integer::numNodeRandExceedNtotal, indexNodeRandExceedNtotal
    integer::iNodeRandExceed, nodeRandReDraw(1)
    !!
    integer::degreeNodeUpdateNow, nodeUpdateNow
    !!
    real(8), allocatable::randNumUseUpdate(:)
    integer::numGenerationLoop, indexGenerationLoop
    !!!!
    
    numGenerationLoop = 101
    generationNum = 5e7
    
    !Testing
    write(*,*) "For "//networkType//" Networks!"
    !stop
    !write(*,*) "*************************"
    call readNetwork(networkMain)
    
    
    write(*,*) "Average Degree = ", sum(degreeMain)*1.0/Ntotal
    write(*,*) "Max Degree = ", maxval(degreeMain)
    write(*,*) "Min Degree = ", minval(degreeMain)
    write(*,*)

    !!write(*,*) "----------------"
    !!write(*,"('  Payoff Parameters')")
    !!write(*,*) "A:",APlayerPayoff
    !!write(*,*) "B:",BPlayerPayoff
    !!write(*,*) "----------------"
    !!
    allocate(nodeRandUpdate(generationNum))
    allocate(randNumUseUpdate(generationNum))
    !!
    xLoop: do a0Value = a0Beg, a0End, a0Gap
        write(xStr, "(F5.2)") a0Value
        APlayerPayoff(1) = a0Value
        
                write(*,*) "----------------"
                write(*,"('  Payoff Parameters')")
                write(*,*) "A:",APlayerPayoff
                write(*,*) "B:",BPlayerPayoff
                write(*,*) "----------------"
                !open(unit = 121,file = "numA_Dist"//"_a0_"//trim(adjustl(xStr)))
                !open(unit = 151,file = "numA_Strategy_Dist_repeat"
                !!!
                !!!
                timeRepeatedOneRealization:do indexRepeated=1, timesRepeated
                    write(timeRepeatFile,"(I4)")  indexRepeated
                    write(*,*) "-------------------"
                    write(*,*) "Repeat = "//timeRepeatFile
                    
                    open(unit = 151,file = "numA_Strategy_Dist_repeat_"//trim(adjustl(timeRepeatFile)))
                    !open(unit = 153,file = "numA_time_repeat_"//trim(adjustl(timeRepeatFile)))
                    
                    !!! Every 5e9 (One repeat), reset the seed (optional)
                    call RNSET(0)
                
                    !-------Initialize strategies-------!
                    call Inital_strategies_not_equal()
                    !
                    numA = sum(strategyPGG)
                    !
                    numADist = 0
                    
                    wholeGenerationLoop: do indexGenerationLoop = 1, numGenerationLoop
                    
                    run = 1
                    
                    
                    !!! --------------------Speed up simulation---------------------!!!
                    nodeRandUpdate = -1.0
                    !! All the random chosen node 
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
                    
                    !! All the random numbers used in the updating
                    randNumUseUpdate = -1.0
                    call RNUN(randNumUseUpdate)
                    !!!
                    !!! -------------------------------------------------------!!!
                    !!
                    generationLoop:do while(run <= generationNum)
                        !!! ---------------------------- !!!
                        !!! ------Game and Update------- !!!
                        nodeUpdateNow = nodeRandUpdate(run)
                        degreeNodeUpdateNow = degreeMain(nodeUpdateNow)
                        !!
                        !!!!!!!
                        call PGG_OnlyFocalNode_AnyGraph_New(APlayerPayoff,BPlayerPayoff,nodeUpdateNow,degreeNodeUpdateNow, payoffUpdate, networkMain)
                        !!
                        !pause
                        call AspirationUpdate(nodeUpdateNow, payoffUpdate,randNumUseUpdate(run))
                        !!------------------------------!!
                        numA = sum(strategyPGG)
                        
                        
                        if(indexGenerationLoop > 1)then
                            !!!! Sample 5e9
                            numADist(numA + 1) = numADist(numA + 1) + 1
                        end if                               
                        run = run + 1
                    end do generationLoop
                    
                    end do wholeGenerationLoop
                    !!! record the last 5e9 + 5e7 - 5e7 steps
                    write(151,"(1001(1X,I10))") numADist  
                    
                    close(151)
                    !!!                
                end do timeRepeatedOneRealization
                
    end do xLoop
    deallocate(nodeRandUpdate)
    deallocate(randNumUseUpdate)
    return 
end subroutine frequencyCalculation