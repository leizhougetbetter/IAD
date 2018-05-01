subroutine frequencyCalculation2(timesRepeated, generationNum, APlayerPayoff, BPlayerPayoff)
    use global
    implicit none
    integer,intent(in)::timesRepeated, generationNum
    real,intent(in)::APlayerPayoff(numPlayerInGame),BPlayerPayoff(numPlayerInGame)
    !runs (generations) in one repeat
    integer::run
    ! number of runs (repetitions)
    integer::indexRepeated   
    !Output
    character(4)::timeRepeatFile
    character(5)::strEta
    !!!
    integer::numA
    !!! the distribution of the number of A players
    integer(kind=8)::numADist(Ntotal+1)
    !!!
    real::payoffUpdate
    !!
    integer, allocatable::nodeRandUpdate(:)
    integer::numNodeRandExceedNtotal, indexNodeRandExceedNtotal
    integer::iNodeRandExceed, nodeRandReDraw(1)
    !!
    integer::nodeUpdateNow
    !!
    real, allocatable::randNumUseUpdate(:)
    integer::numGenerationLoop, indexGenerationLoop
    !!!
    type(structuredPopulations)::networkMain(Ntotal)
    !!!
    !
    numGenerationLoop = 200
    
    !Testing
    !write(*,*) "For Finite Ring!"
    write(*,*) "For Well-mixed! Always Focal Game!"
    write(*,*) "Always 200 Generation Loops, Sample after 100 Loops"
    
    !!! Read networks
    !!! For structured populations, uncomment the next line
    !call readNetwork(networkMain)
    
    call RNSET(0)
    
    allocate(nodeRandUpdate(generationNum))
    allocate(randNumUseUpdate(generationNum))    
    
    open(unit = 121,file = "numA_Strategy_Dist")
    
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
        wholeGenerationLoop: do indexGenerationLoop = 1, numGenerationLoop
            !reset runs   
            run = 1
            
            !! ------------------Speed up the simulation--------------------------!!!!
            nodeRandUpdate = -1.0
            !! All the random chosen node         
            call RNUND(Ntotal, nodeRandUpdate)
            
            !!! Check the random chosen nodes
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
            !! --------------------------------------------------------!!!!

            !!!
            generationLoop:do while(run <= generationNum)
                !!! ---------------------------- !!!
                !!! ------Game and Update------- !!!
                nodeUpdateNow = nodeRandUpdate(run)
                
                !!! For Regular graph, uncomment this line
                !call PGG_AroundUpdateNode_RegularGraph(APlayerPayoff,BPlayerPayoff,nodeUpdateNow,payoffUpdate, networkMain)
                
                !!! For well-mixed populations, uncomment this line
                call PGG_AroundUpdateNode_WellMixed(APlayerPayoff,BPlayerPayoff,nodeUpdateNow,payoffUpdate)
                
                !!! For both well-mixed & Regular graphs
                call AspirationUpdate(nodeUpdateNow, payoffUpdate, randNumUseUpdate(run))
                !!------------------------------!!
                numA = sum(strategyPGG)
                !!
                
                !!! Sample after a relaxtion time of 100 * generationNum time steps
                if(indexGenerationLoop > 100)then
                    numADist(numA + 1) = numADist(numA + 1) + 1        
                end if
                
                run = run + 1
            end do generationLoop
            
        end do wholeGenerationLoop
        
        write(121,"(101(1X,I8))") numADist
        
    end do timeRepeatedOneRealization
    
    deallocate(nodeRandUpdate)
    deallocate(randNumUseUpdate)
    
    close(121)
    
    return 
end subroutine frequencyCalculation2